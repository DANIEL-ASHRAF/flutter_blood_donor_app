import 'package:flutter/material.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/ui_helpers.dart';

class EmptyContent extends StatelessWidget {
  const EmptyContent({
    Key key,
    this.title = 'Nothing here',
    this.message = 'Add a new item to get started',
  }) : super(key: key);
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,textScaleFactor: 1,
              style: TextStyle( fontSize: screenWidth(context)*.09,
                   color: facebookColor, fontWeight: FontWeight.bold),
            ),
            Text(
              message,textScaleFactor: 1,
              style: TextStyle(fontSize: screenWidth(context)*.07, color: enableBorderColor,fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
