import 'dart:async';
import 'package:flutter/material.dart';
import 'package:map_app/common_widgets/custom_button.dart';
import 'package:map_app/common_widgets/custom_pass_text_form_field.dart';
import 'package:map_app/common_widgets/custom_text_form_field.dart';
import 'package:map_app/common_widgets/platform_alert_dialog.dart';
import 'package:map_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:map_app/common_widgets/validators.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/screen_navigation.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/landing_page.dart';
import 'package:map_app/screens/sign_in/phone_sign_in/verify_phone_number.dart';
import 'package:map_app/screens/sign_in/reset_password_page.dart';
import 'package:map_app/screens/sign_in/sign_up_page.dart';
import 'package:map_app/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

class SignInPage extends StatefulWidget with ValidatorsClass {
  final AuthBase auth;
   SignInPage({Key key, this.auth}) : super(key: key);
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context,listen: false);
    return SignInPage(auth: auth);
  }

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isBusy = false;
  final _myKey = GlobalKey<FormState> ();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  String  _email ;
  String  _password ;
  String _smsOTP;

  _signIn(Future<void> Function() signInMethod) async {
      setState(() {
      isBusy = true;
    });
    try {
    await signInMethod();
    if(mounted){
      setState(() {
        isBusy = false;
      });
    }
      beginScreen(context, LandingPage());
    }  catch (e) {
      setState(() {
        isBusy = false;
      });
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }
  Future<void> _signInWithGoogle() async => await _signIn(widget.auth.signInWithGoogle);
  Future<void> _signInWithFacebook() async{
    APlatformAlertDialog(
      defaultActionText: "موافق",
      title: "تنبيه هام",
      content: "قد لا يعمل التسجيل عبر ال facebook مع بعض هواتف هواوى",
      cancelActionText: "الغاء",
    ).show(context).then((value)async => value==true?await _signIn(widget.auth.signInWithFacebook):null);
  }

  Future<void> _signInWithOtp() async {
    setState(() {
      isBusy = true;
    });
    try {
      await widget.auth.signInWithOtp(_smsOTP);
      if(mounted){
        setState(() {
          isBusy = false;
        });
      }
      //TODO فى مشكلة فى ال begin Screen
      beginScreen(context, LandingPage());
    } on PlatformException catch (e) {
      setState(() {
        isBusy = false;
      });
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }


  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      isBusy = true;
    });
    try {
      await widget.auth.signInWithEmailAndPassword(_email, _password);
      if(mounted){
        setState(() {
          isBusy = false;
        });
      }
      //TODO فى مشكلة فى ال begin Screen
      beginScreen(context, LandingPage());
    } on PlatformException catch (e) {
      setState(() {
        isBusy = false;
      });
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isBusy,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: backgroundColor,
          body:Form(
            key: _myKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: <Widget>[
                Container(
                  width: screenWidth(context),
                  height: screenWidth(context)*.28,
                  child: Center(child: Text("تسجيل الدخول",maxLines: 1,textScaleFactor: 1, style: TextStyle(color: googleColor,fontSize: screenWidth(context)*.12,fontWeight: FontWeight.bold),)),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    padding: EdgeInsets.only(top:12),
                    child: CustomTextFormField(
                      maxLength: 80,
                      counterTextShow: false,
                      contentPadding: EdgeInsets.symmetric(vertical: 14,horizontal: 10),
                      fillColor: fillColor,
                      enabled: !isBusy,
                      labelFontSize: screenWidth(context)*.06,
                      fontSize:screenWidth(context)*.06 ,
                      cursorColor: cursorColor,
                      hint: "Email",
                      focusBorderColor: focusBorderColor,
                      enableBorderColor: enableBorderColor,
                      hintColor:hintColor ,
                      keyboardType: TextInputType.emailAddress,
                      focusNode: _emailFocusNode,
                      onSaved: (value)=>_email=value,
                      nextFocusNode: _passwordFocusNode,
                      validator: widget.emailValidator,
                    ),
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Container(
                    padding: EdgeInsets.only(top:12),
                    child: CustomPassTextFormField(
                      contentPadding: EdgeInsets.symmetric(vertical: 14,horizontal: 10),
                      enabled: !isBusy,
                      hint: "Password",
                      fillColor: fillColor,
                      hintColor: hintColor,
                      cursorColor: cursorColor,
                      labelFontSize: screenWidth(context)*.06,
                      fontSize:screenWidth(context)*.06 ,
                      focusBorderColor: focusBorderColor,
                      enableBorderColor: enableBorderColor,
                      iconColor: enableBorderColor,
                      onSaved: (value)=>_password=value,
                      focusNode: _passwordFocusNode,
                      textInputAction:TextInputAction.done,
                      validator:  widget.passwordValidator,
                      enterPressed: (){
                        if(widget.validateAndSaveForm(_myKey))
                        {
                          _signInWithEmailAndPassword();
                        }
                      },
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:16),
                  child: CustomButton(
                    text: "تسجيل",
                    onTap: (){
                      if(widget.validateAndSaveForm(_myKey))
                      {
                        _signInWithEmailAndPassword();
                      }
                    },
                  ),
                ),
//                  widget.userBack?Container():
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: InkWell(
                    onTap:()=>changeScreenWithoutAnimation(context, ResetPasswordPage.create(context)),
                    child: Container(
                        padding: EdgeInsets.only(top:16),
                        child: Text("نسيت كلمة السر ؟",maxLines: 1,textScaleFactor: 1, style: TextStyle(fontSize: screenWidth(context)*.059,color: textColor,fontWeight: FontWeight.bold))),
                  ),
                ),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: screenWidth(context)*.36,
                      color: enableBorderColor,
                      height: 2,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                        width: 60,
                        child: Text("أو",textAlign: TextAlign.center,textScaleFactor: 1,   style: TextStyle(fontSize: screenWidth(context)*.059,color: enableBorderColor,fontWeight: FontWeight.bold),)),
                    Container(
                      width: screenWidth(context)*.36,
                      color: enableBorderColor,
                      height: 2,
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.only(top:12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                      width: screenWidth(context)*.38,
                        height: MediaQuery.of(context).size.width / 8.5,
                        child: CustomButton(
                            text: "facebook",
                            color: facebookColor,
                            onTap:_signInWithFacebook ),
                      ),
                      Container(
                        width: screenWidth(context)*.38,
                        height: MediaQuery.of(context).size.width / 8.5,
                        child: CustomButton(
                            text: "Google",
                            onTap:_signInWithGoogle ),
                      )
                  ],),
                ),
                SizedBox(height: 8,),
                Container(
                  padding: EdgeInsets.only(top:12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: screenWidth(context)*.38,
                        height: MediaQuery.of(context).size.width / 8.5,
                        child: CustomButton(
                            text: "twitter",
                            color: Colors.blue,
                            onTap:(){} ),
                      ),
                      Container(
                        width: screenWidth(context)*.38,
                        height: MediaQuery.of(context).size.width / 8.5,
                        child: CustomButton(
                            iconData: Icons.phone,
                            color: Colors.green,
                            onTap:()=> changeScreenWithoutAnimation(context,VerifyPhoneNumberPage.create(context)),
                        ),
                      ),
                    ],),
                ),
                SizedBox(height: 14,),
              Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text("ليس لدى حساب ؟",maxLines: 1,textScaleFactor: 1, style: TextStyle(fontSize: screenWidth(context)*.059,color: textColor,fontWeight: FontWeight.bold),),
                   SizedBox(width: 10,),
                      InkWell(
                          onTap:()=> changeScreenWithoutAnimation(context,SignUpPage.create(context)),

//                            onTap:()=> changeScreen(context,SignUpPage.create(context),true),
                          child: Text("انشاء حساب.",maxLines: 1,textScaleFactor: 1, style: TextStyle(fontSize: screenWidth(context)*.059,color: googleColor,fontWeight: FontWeight.bold))),
                    ],),
                ),
              ),
//               widget.userBack?Container():Container(
//                    padding: EdgeInsets.all(12),
//                    child: CustomButton(
//                      text: "سوف اقوم بالتسجيل لاحقا",
//                      onTap: _signInAnonymously,
//                    ),
//                  ),



//                CustomButton(
//                  onTap: () {
//                  if(widget.myStringValidator.validateForm(_myKey))
//                  {
//                    _submit();
//                  }
//                },
//                  text:  "Sign in",
//                ),

              ],
            ),
          ),

        ),
      ),
    );
  }
}
