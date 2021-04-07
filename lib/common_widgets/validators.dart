import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ValidatorsClass {

  bool validateAndSaveForm(GlobalKey<FormState> key) {
    final myFormKey = key.currentState;
    if (myFormKey.validate()) {
      myFormKey.save();
      return true;
    }
    return false;
  }

  bool validateForm(GlobalKey<FormState> key) {
    final myFormKey = key.currentState;
    if (myFormKey.validate()) {
      return true;
    }
    return false;
  }

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
    MaxLengthValidator(20, errorText: 'Password must be no more than 20 digits long'),

//    PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
  ]);

  final phoneValidator = MultiValidator([
    RequiredValidator(errorText: 'من فضلك ادخل رقم الهاتف'),
    PatternValidator(r'(^[0-9]{11}$)', errorText: 'من فضلك ادخل رقم هاتف صحيح')
    // arabic
   // PatternValidator(r'[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]', errorText: 'من فضلك ادخل رقم هاتف صحيح (11 رقم)')
  ]);

  final otpValidator = MultiValidator([
    RequiredValidator(errorText: 'OTP required'),
    PatternValidator(r'(^[0-9]{6}$)', errorText: 'make sure your OTP is correct')
    // arabic
    // PatternValidator(r'[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]', errorText: 'من فضلك ادخل رقم هاتف صحيح (11 رقم)')
  ]);

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'من فضلك ادخل الاسم'),
    MinLengthValidator(3, errorText: 'يجب الا يقل الاسم عن ثلاث حروف'),
    MaxLengthValidator(15, errorText: 'يجب الا يزيد الاسم عن 15 حرف'),

//    PatternValidator(r'(^[A-Za-z]{3,20}$)', errorText: 'من فضلك ادخل الاسم صحيح بدون مسافات او ارقام ')
  ]);

  final suggestionValidator = MultiValidator([
    MaxLengthValidator(200, errorText: 'يجب الا يزيد الاقتراح عن 200 حرف'),
    RequiredValidator(errorText: 'لا يمكن ارسال المحتوى فارغاً'),
  ]);


  final areaValidator = MultiValidator([
    RequiredValidator(errorText: 'من فضلك ادخل المنطقة'),
    MinLengthValidator(3, errorText: 'لا يمكن ان تكون المنطقة اقل من ثلاث حروف'),
    MaxLengthValidator(15, errorText: 'يجب الا تزيد المنطقة عن 15 حرف'),

//    PatternValidator(r'(^[A-Za-z  ]{3,20}$)', errorText: 'من فضلك ادخل الاسم صحيح بدون مسافات او ارقام ')
  ]);

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: "Enter a valid email address")
  ]);
}

