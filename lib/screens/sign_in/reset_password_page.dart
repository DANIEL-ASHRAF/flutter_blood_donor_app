import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:map_app/models/user_model.dart';
import 'package:map_app/screens/sign_in/sign_in_page.dart';
import 'package:map_app/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';


class ResetPasswordPage extends StatefulWidget with ValidatorsClass {
  final AuthBase auth;
  ResetPasswordPage({Key key, this.auth}) : super(key: key);
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context,listen: false);
    return ResetPasswordPage(auth: auth,);
  }

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  bool isBusy = false;
  GlobalKey _myKey = GlobalKey<FormState> ();
  String _email;
  FocusNode _emailFocusNode = FocusNode();
//TODO اوحد حجم الخطوط   normaltextsize = 22 ,,, smalltextsize = .....
  Future<void> _sendPasswordResetEmail() async {
    setState(() {
      isBusy = true;
    });
    try {
      await widget.auth.sendPasswordResetEmail(_email);
      if(mounted){
        setState(() {
          isBusy = false;
        });
      }
      APlatformAlertDialog(
        defaultActionText: "موافق",
        title: "تنبيه هام",
        content: "سوف يتم ارسال رابط لكتابة كلمة السر الجديدة خلال 5 دقائق",
        ).show(context).whenComplete(() => beginScreen(context, SignInPage.create(context))
      );
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
                  child: Center(child: Text("نسيت كلمة السر",textScaleFactor: 1, maxLines: 1,style: TextStyle(color: googleColor,fontSize: screenWidth(context)*.12,fontWeight: FontWeight.bold),)),
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
                    focusNode: _emailFocusNode,
                    textInputAction: TextInputAction.done,
                    onSaved: (value)=>_email=value,
                    enterPressed: (){
                      if(widget.validateAndSaveForm(_myKey)){
                        _sendPasswordResetEmail();
                      }
                    },
                    validator: widget.emailValidator,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:16),
                  child: CustomButton(
                    text: "تم",
                    onTap: (){
                      if(widget.validateAndSaveForm(_myKey)){
                        _sendPasswordResetEmail();
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
