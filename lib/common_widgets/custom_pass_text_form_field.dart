import 'package:flutter/material.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/shared_styles.dart';
import 'package:map_app/helper/ui_helpers.dart';

class CustomPassTextFormField extends StatefulWidget {
  const CustomPassTextFormField({Key key,
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
    this.obscureText:true,
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
    this.height:70,
    this.contentPadding:const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
    @required this.iconColor, this.fontSize:22,
  });

  final EdgeInsetsGeometry contentPadding;
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
  final double height;
  final Color iconColor;
  final double fontSize;



  @override
  _CustomPassTextFormFieldState createState() => _CustomPassTextFormFieldState();
}

class _CustomPassTextFormFieldState extends State<CustomPassTextFormField> {
  bool obscureText;

  @override
  void initState() {
    super.initState();
    obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      enabled: widget.enabled,
      style: TextStyle(fontSize: widget.fontSize,color: widget.cursorColor),
      obscureText:obscureText,
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
      maxLines: widget.maxLines,
      validator:widget.validator,
      cursorColor:widget.cursorColor ,
      decoration: InputDecoration(
        contentPadding:widget.contentPadding,
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color:widget.enableBorderColor,width: 2)),
        labelText: widget.label,
        labelStyle: TextStyle(fontSize: widget.fontSize,color: widget.labelColor) ,
        hintText: widget.hint,
        hintStyle: TextStyle(fontSize: widget.fontSize,color: widget.hintColor) ,
        suffixIcon: GestureDetector(
            onTap: () => setState(() {
              obscureText = !obscureText;
            }),
            child:Container(
              width:  screenWidth(context)*.067,
              height:  screenWidth(context)*.067,
              child: Center(
                child: Icon(obscureText
                    ? Icons.visibility
                    : Icons.visibility_off,color:widget.iconColor,size: screenWidth(context)*.067,),
              ),
            )
        ),
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
        counterStyle: TextStyle(color:widget.enableBorderColor,fontSize: widget.fontSize/1.7),
        errorStyle: TextStyle(fontSize: widget.fontSize/1.5,color: googleColor,fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            borderSide: BorderSide(color:widget.enableBorderColor,width: 2)),

//        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
//        onSaved: (value) => _name = value,
        // for int values
        // onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
//        initialValue: _name,
//        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
      ),
    );
  }
}
