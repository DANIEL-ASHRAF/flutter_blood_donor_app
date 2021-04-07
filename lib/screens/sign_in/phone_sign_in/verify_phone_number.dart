import 'package:flutter/material.dart';
import 'package:map_app/common_widgets/custom_button.dart';
import 'package:map_app/common_widgets/custom_text_form_field.dart';
import 'package:map_app/common_widgets/platform_alert_dialog.dart';
import 'package:map_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:map_app/common_widgets/validators.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/screen_navigation.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/screens/sign_in/sign_in_page.dart';
import 'package:map_app/services/auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import '../../../landing_page.dart';
import 'confirm_otp_page.dart';


class VerifyPhoneNumberPage extends StatefulWidget with ValidatorsClass {
  final AuthBase auth;
  VerifyPhoneNumberPage({Key key, this.auth}) : super(key: key);
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context,listen: false);
    return VerifyPhoneNumberPage(auth: auth,);
  }

  @override
  _VerifyPhoneNumberPageState createState() => _VerifyPhoneNumberPageState();
}

class _VerifyPhoneNumberPageState extends State<VerifyPhoneNumberPage> {
  bool isBusy = false;
  GlobalKey _myKey = GlobalKey<FormState> ();
  String _phoneNumber;
  FocusNode _phoneNumberFocusNode = FocusNode();
  Future<void> _verifyPhoneNumber() async {
    setState(() {
      isBusy = true;
    });
    try {
      await widget.auth.verifyPhoneNumber("+20"+_phoneNumber);
      if(mounted){
        setState(() {
          isBusy = false;
        });
      }
      APlatformAlertDialog(
        defaultActionText: "موافق",
        title: "تنبيه هام",
        content: "سوف يتم ارسال رسالة برقم التفعيل خلال 5 دقائق",
      ).show(context).whenComplete(() {
        changeScreenWithoutAnimation(context, ConfirmOtpPage.create(context));}
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
    _phoneNumberFocusNode.dispose();
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
                  child: Center(child: Text("رقم الهاتف",textScaleFactor: 1, maxLines: 1,style: TextStyle(color: googleColor,fontSize: screenWidth(context)*.12,fontWeight: FontWeight.bold),)),
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
                    hint: "Phone number",
                    fillColor: fillColor,
                    hintColor: hintColor,
                    cursorColor: cursorColor,
                    focusBorderColor: focusBorderColor,
                    enableBorderColor: enableBorderColor,
                    keyboardType: TextInputType.phone,
                    focusNode: _phoneNumberFocusNode,
                    textInputAction: TextInputAction.done,
                    onSaved: (value)=>_phoneNumber=value,
                    enterPressed: (){
                      if(widget.validateAndSaveForm(_myKey)){
                        _verifyPhoneNumber();
                      }
                    },
                    validator: widget.phoneValidator,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top:16),
                  child: CustomButton(
                    text: "تم",
                    onTap: (){
                      if(widget.validateAndSaveForm(_myKey)){
                        _verifyPhoneNumber();
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
