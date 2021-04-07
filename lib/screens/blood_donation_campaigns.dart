import 'package:flutter/material.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/ui_helpers.dart';

class BloodDonationCampaigns extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'قريباً ...',textScaleFactor: 1,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize:screenWidth(context)*.1, color: facebookColor),
                ),
//                AutoSizeText(
//                 "سوف يتم اضافتها قريباً" ,
//                  style: TextStyle(fontSize: 30.0, color: enableBorderColor),
//                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
