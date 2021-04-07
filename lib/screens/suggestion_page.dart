import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app/common_widgets/custom_button.dart';
import 'package:map_app/common_widgets/custom_text_form_field.dart';
import 'package:map_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:map_app/common_widgets/validators.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/models/user_model.dart';
import 'package:map_app/services/auth.dart';
import 'package:map_app/services/database_firebase.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class SuggestionPage extends StatefulWidget with ValidatorsClass {
 final UserFromFirebase userFromFirebase;

   SuggestionPage({Key key,@required this.userFromFirebase}) : super(key: key);

  @override
  _SuggestionPageState createState() => _SuggestionPageState();
}

class _SuggestionPageState extends State<SuggestionPage> {
  bool isLoading =false;
  final FocusNode _suggestionFocusNode = FocusNode();
  final _myKey = GlobalKey<FormState> ();

  Future<void> _submit() async {
    final database = Provider.of<DatabaseFirebase>(context, listen: false);

//    isSubmit=true;
    setState(() {
      isLoading = true;
    });
    if (widget.validateAndSaveForm(_myKey)) {
      try {
        //TODO ظبط موضوع ال uid in database
        final userSuggestion = UserSuggestion(
            suggestion: _suggest,);
        await database.setSuggestion(userSuggestion:userSuggestion ,userFromFirebase: widget.userFromFirebase);
        setState(() {
          isLoading = false;
        });
//      beginScreen(context, LandingPage());
        Navigator.pop(context);
      } on PlatformException catch (e) {
        setState(() {
          isLoading = false;
        });
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  String _suggest;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Scaffold(
              backgroundColor: backgroundColor,
              body: Form(
                key: _myKey,
                child:
                ListView(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  children: [
                    Container(
                      width: screenWidth(context),
                      height: screenWidth(context)*.28,
                      child: Center(
                        child: Text("ارسال الاقتراحات",maxLines: 1,textScaleFactor: 1,
                        style: TextStyle(color: googleColor, fontSize: screenWidth(context)*.12,
                            fontWeight: FontWeight.bold),),
                      ),
                    ),
                    Container(
                      child: CustomTextFormField(
                        maxLines: 8,
                        maxLength: 200,
                        enabled: !isLoading,
                        fillColor: fillColor,
                        cursorColor: facebookColor,
                        focusBorderColor: focusBorderColor,
                        enableBorderColor: enableBorderColor,
                        initialValue:_suggest ,
                        validator: widget.suggestionValidator,
                        onSaved:(value) => _suggest = value,
                        focusNode: _suggestionFocusNode,
                        enterPressed:()=> _submit(),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 16),
                      child: CustomButton(
                        text: "ارسال",
                        onTap: (){
                          if(widget.validateAndSaveForm(_myKey))
                          {
                            _submit();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
