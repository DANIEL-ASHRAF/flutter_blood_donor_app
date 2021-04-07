import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:map_app/common_widgets/custom_button.dart';
import 'package:map_app/common_widgets/custom_pass_text_form_field.dart';
import 'package:map_app/common_widgets/custom_text_form_field.dart';
import 'package:map_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:map_app/common_widgets/validators.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/screen_navigation.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/landing_page.dart';
import 'package:map_app/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';


class SignUpPage extends StatefulWidget with ValidatorsClass {
  final AuthBase auth;
  SignUpPage({Key key, this.auth}) : super(key: key);
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context,listen: false);
    return SignUpPage(auth: auth,);
  }

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isBusy = false;
  GlobalKey _myKey = GlobalKey<FormState> ();
   TextEditingController _emailController = TextEditingController();
   TextEditingController _passwordController = TextEditingController();
   TextEditingController _confirmPasswordController = TextEditingController();
   FocusNode _emailFocusNode = FocusNode();
   FocusNode _passwordFocusNode = FocusNode();
   FocusNode _confirmPasswordFocusNode = FocusNode();
  String get _email => _emailController.text;
  String get _password => _passwordController.text;

//TODO اوحد حجم الخطوط   normaltextsize = 22 ,,, smalltextsize = .....
  Future<void> _signUpWithEmailAndPassword({String email,String password}) async {
    setState(() {
      isBusy = true;
    });
    try {
//      widget.userBack?
//      await widget.auth.deleteUserFromFirebase().whenComplete(()async => await widget.auth.createUserWithEmailAndPassword(email, password) )
//          :
      await widget.auth.createUserWithEmailAndPassword(email, password);

//      await widget.auth.createUserWithEmailAndPassword(email, password);
      if(mounted){
        setState(() {
          isBusy = false;
        });
      }
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
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _confirmPasswordFocusNode.dispose();
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
                  child: Center(child: Text("انشاء حساب",textScaleFactor: 1, maxLines: 1,style: TextStyle(color: googleColor,fontSize: screenWidth(context)*.12,fontWeight: FontWeight.bold),)),
                ),
                Container(
                  padding: EdgeInsets.only(top:12),
                  child: CustomTextFormField(
                    maxLength: 80,
                    counterTextShow: false,
                    contentPadding: EdgeInsets.symmetric(vertical: 14,horizontal: 10),
                    enabled: !isBusy,
                    labelFontSize: screenWidth(context)*.06,
                    fontSize:screenWidth(context)*.06 ,
                    hint: "Email",
                    fillColor: fillColor,
                    hintColor: hintColor,
                    cursorColor: cursorColor,
                    focusBorderColor: focusBorderColor,
                    enableBorderColor: enableBorderColor,
                    keyboardType: TextInputType.emailAddress,
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    nextFocusNode: _passwordFocusNode,
                    validator: widget.emailValidator,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:12),
                  child: CustomPassTextFormField(
                    contentPadding: EdgeInsets.symmetric(vertical: 14,horizontal: 10),
                    enabled: !isBusy,
                    hint: "Password",
                    fillColor: fillColor,
                    hintColor: hintColor,
                    labelFontSize: screenWidth(context)*.06,
                    fontSize:screenWidth(context)*.06 ,
                    cursorColor: cursorColor,
                    focusBorderColor: focusBorderColor,
                    enableBorderColor: enableBorderColor,
                    iconColor: enableBorderColor,
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    textInputAction:TextInputAction.done,
                    validator:  widget.passwordValidator,
                    nextFocusNode: _confirmPasswordFocusNode,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:12),
                  child: CustomPassTextFormField(
                    contentPadding: EdgeInsets.symmetric(vertical: 14,horizontal: 10),
                    enabled: !isBusy,
                    hint: "Confirm Password",
                    fillColor: fillColor,
                    hintColor: hintColor,
                    cursorColor: cursorColor,
                    focusBorderColor: focusBorderColor,
                    labelFontSize: screenWidth(context)*.06,
                    fontSize:screenWidth(context)*.06 ,
                    enableBorderColor: enableBorderColor,
                    iconColor: enableBorderColor,
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocusNode,
                    textInputAction:TextInputAction.done,
                    validator: (val) => MatchValidator(errorText: 'passwords do not match').validateMatch(val,_password),
                    enterPressed: (){
                      if(widget.validateForm(_myKey))
                      {
                        _signUpWithEmailAndPassword(email: _email,password: _password);
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:16),
                  child: CustomButton(
                    text: "تسجيل",
                    onTap: (){
                      if(widget.validateForm(_myKey))
                      {
                        _signUpWithEmailAndPassword(email: _email,password: _password);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
