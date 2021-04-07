import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/ui_helpers.dart';

class CustomButton extends StatelessWidget {
  CustomButton({@required this.onTap, this.text, this.color:googleColor, this.iconData});
  final VoidCallback onTap;
  final String text;
  final Color color;
  final IconData iconData;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 2,
        height: MediaQuery.of(context).size.width / 7,
        child: Center(
            child: iconData!=null? Icon(iconData,color: Colors.white,size:screenWidth(context)*.08,):
            Text(text,
                maxLines: 1,textScaleFactor: 1,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                  fontSize: screenWidth(context)*.066,
                ))),
        decoration: BoxDecoration(
          color: color,
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                offset: Offset(0, 5),
                blurRadius: 10.0,
              )
            ],
            borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
