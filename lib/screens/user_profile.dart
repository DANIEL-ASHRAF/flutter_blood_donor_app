import 'package:flutter/material.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/models/user_model_with_distance.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({Key key,@required this.userModelWithDistance}) : super(key: key);
  final  UserModelWithDistance userModelWithDistance;


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: backgroundColor,
          body: ListView(
            padding: EdgeInsets.symmetric(horizontal: 12),
            children: [
              Container(
                padding: EdgeInsets.only(top:8),
                child: Text( "name: ${userModelWithDistance.userModel.name}",
                  style: TextStyle(fontSize: screenWidth(context)*.06,color: textColor),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top:8),
                child: Text( "area: ${userModelWithDistance.userModel.area}",
                  style: TextStyle(fontSize: screenWidth(context)*.06,color: textColor),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top:8),
                child: Text( "phone:${userModelWithDistance.userModel.phone}",
                  style: TextStyle(fontSize: screenWidth(context)*.06,color: textColor),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top:8),
                child: Text( "bloodType: ${userModelWithDistance.userModel.bloodType} ",
                  style: TextStyle(fontSize: screenWidth(context)*.06,color: textColor),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top:8),
                child: Text( "distance: ${userModelWithDistance.distance} ",
                  style: TextStyle(fontSize: screenWidth(context)*.06,color: textColor),
                ),
              ),
            ],
          )
      ),
    );
  }
}
