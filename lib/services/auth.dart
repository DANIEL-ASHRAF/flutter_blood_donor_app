import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
class UserFromFirebase {
  UserFromFirebase({this.phone,
    @required this.uid,
    this.isAnonymously,
  });
  final String uid;
  final bool isAnonymously;
  final String phone;
}

abstract class AuthBase {
  Stream<UserFromFirebase> get onAuthStateChanged;
  Future<UserFromFirebase> currentUser();
  Future signInAnonymously();
  Future deleteUserFromFirebase();
  Future<void> signInWithEmailAndPassword(String email, String password);
  Future createUserWithEmailAndPassword(String email, String password);
  Future sendPasswordResetEmail(String email);
  Future signInWithGoogle();
  Future signInWithFacebook();

  Future<void> verifyPhoneNumber(String number);
  Future signInWithOtp(String smsOTP);
  Future<void> signOut();
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;
//TODO
  UserFromFirebase _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return UserFromFirebase(
      uid: user.uid,
      phone: user.phoneNumber??"",
      isAnonymously: user.isAnonymous
    );
  }

  @override
  Stream<UserFromFirebase> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<UserFromFirebase> currentUser() async {
    final user =  _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future deleteUserFromFirebase()async{
    final user =  _firebaseAuth.currentUser;
    user?.delete();
  }

  @override
  Future signInAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try{
      final authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(authResult.user);
    }catch(e){
      throw PlatformException(
        code: '',
        message: e.message,
      );
    }
  }

  @override
  Future sendPasswordResetEmail(String email) async {
    try{
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    }catch(e){
      throw PlatformException(
        code: '',
        message: e.message,
      );
    }
  }

  @override
  Future createUserWithEmailAndPassword(
      String email, String password) async {
    try{
      final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return _userFromFirebase(authResult.user);
    }catch(e){
      throw PlatformException(
        code: '',
        message: e.message,
      );
    }
  }

///////////////////////////////////
  String verificationId;
  @override
  Future<void> verifyPhoneNumber(String number) async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) async {
      verificationId = verId;
    };
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: number.trim(), // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            verificationId = verId;
          },
          codeSent:smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 120),
          verificationCompleted: (AuthCredential phoneAuthCredential) async{
//         await _firebaseAuth.signInWithCredential(phoneAuthCredential);
            print(phoneAuthCredential.toString() + "lets make this work/////////////////");
          },
          verificationFailed: (FirebaseAuthException  exception) {
            print('$exception + something is wrong');
          });
    } catch (e) {
     print (e);
    }
  }

  @override
  signInWithOtp(String smsOTP) async {
    try {
//      final AuthCredential credential = PhoneAuthProvider.credential(
//        verificationId: verificationId,
//        smsCode: smsOTP,
//      );
    print(verificationId+"/////////////////////////////");
      final authResult = await _firebaseAuth.signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsOTP,
      ));
      return _userFromFirebase(authResult.user);
    } catch (e) {
      print("${e.toString()}");
    }
  }

  /////////////////////////////////////

  @override
  Future signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
          GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ),
        );
        return _userFromFirebase(authResult.user);
      } else {
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(
      ['public_profile'],
    );
    if (result.accessToken != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.credential(
          result.accessToken.token,
        ),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'Sign in aborted by user',
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }
}
