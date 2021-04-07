import 'package:flutter_offline/flutter_offline.dart';
import 'package:map_app/common_widgets/custom_launcher.dart';
import 'package:map_app/common_widgets/empty_content.dart';
import 'package:map_app/helper/screen_navigation.dart';
import 'package:map_app/models/search_model.dart';
import 'package:map_app/models/user_model_with_distance.dart';
import 'package:map_app/screens/home/components/my_app_bar.dart';
import 'package:map_app/screens/home/components/my_drawer.dart';
import 'package:map_app/screens/home/utilties/calculate_distance.dart';
import 'package:map_app/screens/sign_in/user_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:map_app/common_widgets/items_builder.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/services/auth.dart';
import 'package:map_app/services/permission.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/common_widgets/platform_alert_dialog.dart';
import 'package:map_app/models/user_model.dart';
import 'package:map_app/services/database_firebase.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../../item_list.dart';
import '../../user_profile.dart';

class MYListPage extends StatefulWidget  with CustomLauncher ,MYDistance{
 const MYListPage({Key key, this.currentPosition, this.userFromFirebase, this.database}) : super(key: key);
  final Position currentPosition;
  final UserFromFirebase userFromFirebase;
 final DatabaseFirebase database;


 static Widget create({BuildContext context}) {
    final userFromFirebase = Provider.of<UserFromFirebase>(context);
    final currentPosition = Provider.of<Position>(context);
    final database = Provider.of<DatabaseFirebase>(context, listen: false);
    return MYListPage(currentPosition: currentPosition,userFromFirebase: userFromFirebase,database: database,);
  }

//TODO limit retrive data , retrive data by distance , sort
  //TODO خلى كل الابعاد تبقى من ال screen
  // TODO must access to user's location ****
  // TODO connectivity
  // TODO listView and show in it with distance instead map
  // TODO refactor and use items builder with any stream
  // TODO is that good filter !! with 100000 users !!
  // TODO لو هتعدل طريقة الفلترة ابقى اعمل ال grid
  //TODO remove whitescreen
  //TODO حل مشكلة الخريطة والتاخير فيها حتى بالنسبة لل buttons


  @override
  _MYListPageState createState() => _MYListPageState();
}

class _MYListPageState extends State<MYListPage> {
  List _users = [];
  String filter ="";
  double lat,lng;

  @override
  void initState() {
    super.initState();
//    lat=widget.currentPosition.latitude;
//    lng=widget.currentPosition.longitude;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    final searchSetting = Provider.of<SearchSettings>(context);
    var _currents=["A+","A-", "B+","B-", "AB+", "AB-", 'O+', 'O-',"الكل"];
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
            body:StreamBuilder<UserModel>(
                stream: widget.database.userStream(widget.userFromFirebase),
                builder: (context, snapshot) {
                  // TODO refactor and use items builder
                  final user = snapshot?.data;
                return Container(
                  height: screenHeight(context),width: screenWidth(context),
                  child: StreamBuilder<List<UserModel>>(
                      stream: widget.database.usersStream(
                        bloodType: searchSetting.filter.bloodType,
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List items = snapshot.data;
                          if (items.isNotEmpty) {
                            return  _buildList(items,user) ;
                          } else {
//                        return EmptyContent();
                            return Container();
                          }
                        } else if (snapshot.hasError) {
                          return EmptyContent(
                            title: 'Something went wrong',
                            message: 'Can\'t load items right now',
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      }
                  )
          );
              }
            )
//                :PermissionWidget( Permission.location)
        ),
      ),
    );
  }

  Widget _buildList(List items,UserModel user) {
    final searchSetting = Provider.of<SearchSettings>(context);
    final userName=user?.name??"";
    return ListItemsBuilderWithDistance(
        distanceFilter: (searchSetting.filter.distance)*1000,
        snapshot: items,
        itemBuilder: (context,item)=>
        item.userModel.uid==widget.userFromFirebase.uid? ItemList(
        color: facebookColor,
        area: item.userModel.area,
        userName: item.userModel.name,
        bloodType: item.userModel.bloodType,
        distance: item.distance,
        nameTap: ()=>changeScreen(context, UserProfile(userModelWithDistance: item,), true),
        phoneOnTap:()=> widget.customLaunch(context:context,command:'tel:${item.userModel.phone}'),
        smsOnTap:()=>widget.customLaunch(context:context,command:'sms:${item.userModel.phone}'),
      ):
        ItemList(
          color: googleColor,
          area: item.userModel.area,
          userName: item.userModel.name,
          bloodType: item.userModel.bloodType,
          distance: item.distance,
          nameTap:(){
            if(userName==""){
              APlatformAlertDialog(
                defaultActionText: "موافق",
                cancelActionText: "لا",
                title: "عذراً",
                content: "لا يمكن اجراء العملية بدون تسجيل بياناتك",
              ).show(context).then((value) => value==true?changeScreen(context, UserData.create(context: context,userModel: user),true):null);
            }
            else{changeScreen(context, UserProfile(userModelWithDistance: item,), true); }},
          phoneOnTap:(){
            if(userName==""){
            APlatformAlertDialog(
            defaultActionText: "موافق",
            cancelActionText: "لا",
            title: "عذراً",
            content: "لا يمكن اجراء العملية بدون تسجيل بياناتك",
            ).show(context).then((value) => value==true?changeScreen(context, UserData.create(context: context,userModel: user),true):null);
            }
            else{ widget.customLaunch(context:context,command:'tel:${item.userModel.phone}');}},
          smsOnTap:(){
            if(userName==""){
              APlatformAlertDialog(
                defaultActionText: "موافق",
                cancelActionText: "لا",
                title: "عذراً",
                content: "لا يمكن اجراء العملية بدون تسجيل بياناتك",
              ).show(context).then((value) => value==true?changeScreen(context, UserData.create(context: context,userModel: user),true):null);
            }
            else{ widget.customLaunch(context:context,command:'sms:${item.userModel.phone}');}},
        ),
    );
  }
}