import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:map_app/helper/ui_helpers.dart';

class CustomFloatingButton extends StatelessWidget {

  CustomFloatingButton({@required this.onTap,@required this.color, this.iconData, this.iconSize:36,@required this.heroTag, this.text});
  final VoidCallback onTap;
  final Color color;
  final IconData iconData;
  final double iconSize;
  final String heroTag;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenWidth(context)*.16,
      width: screenWidth(context)*.16,
      child: FloatingActionButton(
        heroTag: heroTag,
        onPressed: onTap,
        materialTapTargetSize: MaterialTapTargetSize.padded,
        backgroundColor: color,
        child:text==null? Icon(iconData,size: screenWidth(context)*.089,):Text(text,style: TextStyle(
          fontSize: screenWidth(context)*.089,
        ),),
      ),
    );
  }
}
