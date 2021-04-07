
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/shared_styles.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({Key key,
    this.hint,
    this.label,
    this.borderRadius: 10.0,
    @required this.validator,
    this.onSaved,
    this.keyboardType,
    this.labelFontSize,
    this.controller,
    this.enterPressed,
    this.onChanged,
    this.focusNode,
    this.nextFocusNode,
    this.obscureText:false,
    this.cursorWidth:3.0,
    this.child,
    this.textInputAction:TextInputAction.next,
    @required this.enabled, this.initialValue, this.fillColor,
    this.filled:true,
    this.labelColor,
    this.hintColor,
    this.enableBorderColor:const Color(0xfffefefe),
    this.focusBorderColor:const Color(0xfffefefe),
    this.cursorColor :const Color(0xfffefefe), this.maxLines:1,
     this.textDirection,
    this.contentPadding:const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    this.maxLength:20,
    this.counterTextShow:true, this.fontSize:22,
  });

    final TextEditingController controller;
    final FocusNode focusNode;
    final FocusNode nextFocusNode;
    final Function enterPressed;
    final String label;
    final double labelFontSize;
    final String hint;
    final Function(String) validator;
    final Function(String) onSaved;
    final double borderRadius;
    final TextInputType keyboardType;
    final TextInputAction textInputAction;
    final Function(String) onChanged;
    final bool obscureText ;
    final double cursorWidth;
    final bool enabled,filled;
    final Widget child;
    final String initialValue;
    final Color fillColor;
    final Color labelColor;
    final Color hintColor;
    final Color enableBorderColor;
    final Color focusBorderColor;
    final Color cursorColor;
    final int maxLines;
    final TextDirection textDirection;
    final EdgeInsetsGeometry contentPadding;
    final int maxLength;
    final bool counterTextShow;
    final double fontSize;
  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: widget.maxLength,
      maxLines: widget.maxLines,
      textDirection: widget.textDirection,
      initialValue: widget.initialValue,
      enabled: widget.enabled,
      style: TextStyle(fontSize:widget.fontSize,color: widget.cursorColor),
      obscureText:widget.obscureText,
      onSaved: widget.onSaved,
      onChanged: widget.onChanged,
      onFieldSubmitted: (value) {if (widget.nextFocusNode != null) {
          widget.nextFocusNode.requestFocus();
        }},
      onEditingComplete: () {if (widget.enterPressed != null) {
          FocusScope.of(context).requestFocus(FocusNode());
          widget.enterPressed();
        }},
      textInputAction: widget.textInputAction,
      cursorWidth: widget.cursorWidth ,
      focusNode: widget.focusNode,
      controller: widget.controller,
      keyboardType: widget.keyboardType ,
      validator:widget.validator,
      cursorColor:widget.cursorColor ,
      inputFormatters: [
         LengthLimitingTextInputFormatter(widget.maxLength),
      ],
      decoration: InputDecoration(
        counterText: widget.counterTextShow?null:"",
        counterStyle: TextStyle(color:widget.enableBorderColor,fontSize: widget.fontSize/1.7),
        contentPadding:widget.contentPadding,
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color:widget.enableBorderColor,width: 2)),
      labelText: widget.label,
      labelStyle: TextStyle(fontSize: widget.fontSize,color: widget.labelColor) ,
      hintText: widget.hint,
      hintStyle: TextStyle(fontSize: widget.fontSize,color: widget.hintColor) ,
        suffixIcon: widget.child,
        filled:widget.filled,
      fillColor:widget.fillColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color:widget.enableBorderColor,width: 2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color:widget.focusBorderColor,width: 2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: googleColor,width: 2)),
      errorMaxLines: 2,
      errorStyle: TextStyle(fontSize: widget.fontSize/1.5, color: googleColor,fontWeight: FontWeight.bold),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color:widget.enableBorderColor,width: 2)),
      ),
    );
  }
}