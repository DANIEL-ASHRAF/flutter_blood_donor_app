import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app/common_widgets/custom_button.dart';
import 'package:map_app/common_widgets/custom_text_form_field.dart';
import 'package:map_app/common_widgets/platform_exception_alert_dialog.dart';
import 'package:map_app/common_widgets/validators.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/screen_navigation.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/models/user_model.dart';
import 'package:map_app/screens/select_marker_page.dart';
import 'package:map_app/services/auth.dart';
import 'package:map_app/services/database_firebase.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class UserData extends StatefulWidget with ValidatorsClass {
  UserData({Key key, this.userModel, this.userFromFirebase}) : super(key: key);
  final UserModel userModel;
  final UserFromFirebase userFromFirebase;
  static Widget create({BuildContext context,UserModel userModel}) {
    final userFromFirebase = Provider.of<UserFromFirebase>(context,listen: false);
    return UserData(userFromFirebase: userFromFirebase,userModel: userModel,);
  }


  @override
  _UserDataState createState() => _UserDataState();
}
// TODO validation for new user
class _UserDataState extends State<UserData> {
  bool isLoading =false;
  String _uid;
  String _name;
  String _phone;
  String _bloodTypeLetter;
  String _area;
  String _bloodTypeSign;
  bool _bloodTypeExist=false;
  String _bloodType;
  UserLocation _geo;
  bool _isSwitched;
  final _myKey = GlobalKey<FormState> ();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _areaFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();

  bool _validateGeo=true;
  bool validateGeo(){
    if(_geo != null){
      setState(() {
        _validateGeo=true;
      });
      return true;
    }
//    if(_lat!=0){
//      _geo=UserLocation(latitude: _lat,longitude: _lng);
//      return true;
//    }
    setState(() {
      _validateGeo=false;
    });
    return false;
  }

  bool _validateBloodType=true;
  bool validateBloodType(){
    if(_bloodTypeLetter !=''&&_bloodTypeSign !=''){
      _bloodType= _bloodTypeLetter+_bloodTypeSign ;
      setState(() {
        _validateBloodType=true;
      });
    return true;
    }
    setState(() {
      _validateBloodType=false;
    });
    return false;
  }


  Future<void> _submit() async {
    final database = Provider.of<DatabaseFirebase>(context, listen: false);

//    isSubmit=true;
    setState(() {
      isLoading = true;
    });
    if (widget.validateAndSaveForm(_myKey) && validateBloodType() &&
        validateGeo()) {
      try {
        final id = documentIdFromCurrentDate();
//        final user = UserModel(
//            uid: id,
//            name: _name,
//            bloodType: _bloodType,
//            userLocation: _geo,
//            phone: _phone,
//            area: _area,
//            available: _isSwitched);       //TODO ظبط موضوع ال uid in database
        final user = UserModel(
            uid: _uid,
            name: _name,
            bloodType: _bloodType,
            userLocation: _geo,
            phone: _phone,
            area: _area,
            available: _isSwitched);
        await database.setUser(user:user,userFromFirebase: widget.userFromFirebase);
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

  @override
  void initState() {
    super.initState();
    _uid = widget.userFromFirebase.uid;
    _name = widget.userModel?.name ?? '';
    _geo=widget.userModel?.userLocation??null;
    _phone = widget.userModel?.phone ?? '';
    _area = widget.userModel?.area ?? '';
    _isSwitched=widget.userModel?.available??true;
    if (widget.userModel?.bloodType != null) {
      _bloodTypeExist = true;
      bool _check = widget.userModel.bloodType[1] == "B" ? true : false;
      if (_check) {
        _bloodTypeLetter =
            widget.userModel.bloodType[0] + widget.userModel.bloodType[1];
        _bloodTypeSign = widget.userModel.bloodType[2];
      } else {
        _bloodTypeLetter = widget.userModel.bloodType[0];
        _bloodTypeSign = widget.userModel.bloodType[1];
      }
    } else {
      _bloodTypeLetter = "";
      _bloodTypeSign = "";
      _bloodTypeExist = false;
    }
  }


  @override
  void dispose() {
    _nameFocusNode.dispose();
    _areaFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }
//TODO تعديل ال isswatched and location لما يجى يعدل البانات
  //TODO mudal hud
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
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12),
                children: [
                  Container(
                    width: screenWidth(context),
                    height: screenWidth(context)*.28,
                    child: Center(child: Text(_name==''? "تسجيل البيانات":"تعديل البيانات",maxLines: 1,
                      textScaleFactor: 1, style: TextStyle(color: googleColor,
                          fontSize: screenWidth(context)*.12,fontWeight: FontWeight.bold),)),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:8),
                    child: CustomTextFormField(
                      maxLength: 15,
                      enabled: !isLoading,
                      keyboardType: TextInputType.text,
                      labelFontSize: screenWidth(context)*.06,
                      fontSize:screenWidth(context)*.06 ,
                      hint: "الاسم",
                      fillColor: fillColor,
                      hintColor: hintColor,
                      cursorColor: cursorColor,
                      focusBorderColor: focusBorderColor,
                      enableBorderColor: enableBorderColor,
                      initialValue:_name ,
                      validator: widget.nameValidator,
                      onSaved:(value) => _name = value,
                      focusNode: _nameFocusNode,
                      nextFocusNode: _areaFocusNode,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:8),
                    child: CustomTextFormField(
                      maxLength: 15,
                      enabled: !isLoading,
                      labelFontSize: screenWidth(context)*.06,
                      fontSize:screenWidth(context)*.06 ,
                      keyboardType: TextInputType.text,
                      hint: "المنطقة",
                      fillColor: fillColor,
                      hintColor: hintColor,
                      cursorColor: cursorColor,
                      focusBorderColor: focusBorderColor,
                      enableBorderColor: enableBorderColor,
                      initialValue:_area ,
                      validator: widget.areaValidator,
                      onSaved:(value) => _area = value,
                      focusNode: _areaFocusNode,
                      nextFocusNode: _phoneFocusNode,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5,top: 8),
                          child: CustomTextFormField(
                            maxLength: 11,
//                          contentPadding: const EdgeInsets.only(left: 10.0,right: 10,top: 8,bottom:12.0),
                            textDirection: TextDirection.ltr,
//                          counterTextShow: false,
                            enabled: !isLoading,
                            labelFontSize: screenWidth(context)*.06,
                            fontSize:screenWidth(context)*.06 ,
                            hint: "رقم الهاتف",
                            keyboardType: TextInputType.phone,
                            fillColor: fillColor,
                            hintColor: hintColor,
                            cursorColor: cursorColor,
                            focusBorderColor: focusBorderColor,
                            enableBorderColor: enableBorderColor,
                            initialValue:_phone ,
                            validator: widget.phoneValidator,
                            onSaved:(value) => _phone = value,
                            focusNode: _phoneFocusNode,
                            enterPressed: ()=>_phoneFocusNode.unfocus(),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 0,top: 0,right: 0,bottom: 14),
                        child: Text(
                          "20+",
                          textScaleFactor: 1,
                          maxLines: 1,
                          style: TextStyle(fontSize: screenWidth(context)*.059,color: textColor),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 0,top: 0,right: 2,bottom: 14),
                        child: Container(
                          height: screenWidth(context)*.08,
                          width: screenWidth(context)*.085,
                          child: Image.asset("assets/egypt_flag.png",fit:BoxFit.fill ),
                        ),
                      ),
                    ],
                  ),
                  Row(children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(top:8),
                        child: Text(
                          "استطيع التبرع بالدم فى الوقت الحالى",maxLines: 1,textScaleFactor: 1,
                          style: TextStyle(fontSize: screenWidth(context)*.059,color: textColor,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top:8),
                      child: InkWell(
                        onTap: (){
                          setState(() {
                            _isSwitched=!_isSwitched;
                          });
                        },
                        child:Icon(_isSwitched? Icons.check_box:Icons.check_box_outline_blank ,color: facebookColor,size:  screenWidth(context)*.08,),
                      ),
                    ),
                  ],),
                  !_isSwitched?Container(
                    child: Text(
                      "لن يتم عرض بياناتك للاشخاص الاخرين.",maxLines: 1,textScaleFactor: 1,
                      style: TextStyle(fontSize: screenWidth(context)*.059,color: googleColor,fontWeight: FontWeight.bold),
                    ),
                  ):Container(),
                  Container(
                    padding: EdgeInsets.only(top:8),
                    child: Text(
                      "اختر فصيلة الدم:",maxLines: 1,textScaleFactor: 1,
                      style: TextStyle(fontSize: screenWidth(context)*.059,color: textColor,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:8),
//                  height: 55,
                    child:_bloodTypeExist? CustomRadioButton(
                      defaultSelected: _bloodTypeLetter,
                      width:MediaQuery.of(context).size.width/4.6 ,
                      height: screenWidth(context)/8.2,
                      enableShape: true,
                      customShape: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: facebookColor, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      unSelectedColor: Colors.white,
                      buttonLables: [
                        'A',
                        'B',
                        'AB',
                        'O',
                      ],
                      buttonValues: [
                        'A',
                        'B',
                        'AB',
                        'O',
                      ],
                      buttonTextStyle: ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: facebookColor,
                          textStyle: TextStyle(fontSize: screenWidth(context)*.06,color: facebookColor)),
                      radioButtonValue: (value) {
                        print(value);
                        _bloodTypeLetter=value;
                      },
                      selectedColor: facebookColor,
                    )
                        :CustomRadioButton(
                      width:MediaQuery.of(context).size.width/4.6 ,
                      height: screenWidth(context)/8.2,
                      enableShape: true,
                      customShape: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: facebookColor, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      unSelectedColor: Colors.white,
                      buttonLables: [
                        'A',
                        'B',
                        'AB',
                        'O',
                      ],
                      buttonValues: [
                        'A',
                        'B',
                        'AB',
                        'O',
                      ],
                      buttonTextStyle: ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: facebookColor,
                          textStyle: TextStyle(fontSize: screenWidth(context)*.06,color: facebookColor)),
                      radioButtonValue: (value) {
                        print(value);
                        _bloodTypeLetter=value;
                      },
                      selectedColor: facebookColor,
                    ),
                  ),
                  _bloodTypeExist? Container(
                    padding: EdgeInsets.only(top:8),
                    child: CustomRadioButton(
                      defaultSelected: _bloodTypeSign,
                      width:MediaQuery.of(context).size.width/4.6 ,
                      height: screenWidth(context)/8.2,
                      enableShape: true,
                      customShape: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: facebookColor, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      unSelectedColor: Colors.white,
                      buttonLables: [
                        '+',
                        '-',
                      ],
                      buttonValues: [
                        '+',
                        '-',
                      ],
                      buttonTextStyle: ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: facebookColor,
                          textStyle: TextStyle(fontSize: screenWidth(context)*.062,color: facebookColor)),
                      radioButtonValue: (value) {
                        print(value);
                        _bloodTypeSign=value;
                      },
                      selectedColor: facebookColor,
                    ),
                  )
                      :Container(
                    padding: EdgeInsets.only(top:8),
                    child: CustomRadioButton(
                      width:MediaQuery.of(context).size.width/4.6 ,
                      height: screenWidth(context)/8.2,
                      enableShape: true,
                      customShape: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: facebookColor, width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                      unSelectedColor: Colors.white,
                      buttonLables: [
                        '+',
                        '-',
                      ],
                      buttonValues: [
                        '+',
                        '-',
                      ],
                      buttonTextStyle: ButtonTextStyle(
                          selectedColor: Colors.white,
                          unSelectedColor: facebookColor,
                          textStyle: TextStyle(fontSize: screenWidth(context)*.062,color: facebookColor)),
                      radioButtonValue: (value) {
                        print(value);
                        _bloodTypeSign=value;
                      },
                      selectedColor: facebookColor,
                    ),
                  ),
                  _validateBloodType?Container():Container(
                    child: Text(
                      "يرجى ادخال فصيلة الدم",maxLines: 1,textScaleFactor: 1,textAlign: TextAlign.center,
                      style: TextStyle(fontSize: screenWidth(context)*.059,color: googleColor,fontWeight: FontWeight.bold),
                    ),
                  ),

                  //TODO ظبط ال موقع
                  Container(
                    padding: EdgeInsets.only(top:12),
                    child: CustomButton(
                      color: facebookColor,
                      text: _geo==null? "اختر موقعك":"تعديل موقعك",
                      onTap: ()async{
                        UserLocation _userLocation=await moveToSecondPage(context,SelectMarkerPage(geo: _geo,));
                        if(_userLocation!=null){
                          _geo=_userLocation;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                  _validateGeo?Container():Container(
                    child: Text(
                      "يرجى تحديد موقعك",maxLines: 1,textScaleFactor: 1,textAlign: TextAlign.center,
                      style: TextStyle(fontSize: screenWidth(context)*.059,color: googleColor,fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top:12),
                    child: CustomButton(
                      text: "تسجيل",
                      onTap: (){
                        if(widget.validateAndSaveForm(_myKey))
                        {
                          _submit();
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 12,)
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}