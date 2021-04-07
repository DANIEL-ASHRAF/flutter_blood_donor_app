import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:map_app/common_widgets/custom_launcher.dart';
import 'package:map_app/helper/screen_navigation.dart';
import 'package:map_app/models/search_model.dart';
import 'package:map_app/models/user_model_with_distance.dart';
import 'package:map_app/screens/home/components/my_app_bar.dart';
import 'package:map_app/screens/home/components/my_drawer.dart';
import 'package:map_app/screens/home/utilties/calculate_distance.dart';
import 'package:map_app/screens/sign_in/user_data.dart';
import 'package:map_app/services/geoLocator_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:map_app/common_widgets/custom_floating_button.dart';
import 'package:map_app/common_widgets/platform_alert_dialog.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/services/auth.dart';
import 'package:map_app/services/permission.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/common_widgets/empty_content.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/models/user_model.dart';
import 'package:map_app/services/database_firebase.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../item_list.dart';
import '../../user_profile.dart';


class MYMapPage extends StatefulWidget with CustomLauncher , MYDistance{
const MYMapPage({Key key, this.currentPosition, this.userFromFirebase, this.database, this.auth}) : super(key: key);
  final Position currentPosition;
  final UserFromFirebase userFromFirebase;
  final DatabaseFirebase database;
  final AuthBase auth;
  static Widget create({BuildContext context}) {
    final currentPosition = Provider.of<Position>(context,listen: false);
    final userFromFirebase = Provider.of<UserFromFirebase>(context);
    final database = Provider.of<DatabaseFirebase>(context, listen: false);
    final auth = Provider.of<AuthBase>(context,listen:false);
    return MYMapPage(currentPosition: currentPosition,
      userFromFirebase: userFromFirebase,database: database,auth: auth);
  }

  @override
  _MYMapPageState createState() => _MYMapPageState();
}

class _MYMapPageState extends State<MYMapPage> {

  List<Marker> markers = [];
  String filter ="";
  MapType _currentMapType =MapType.normal;
  GoogleMapController _googleMapController;
//  double lat,lng;
  bool makeMove=false;

  String data;
  Future getData() async {
    String dataIn="test";
    return dataIn;
  }
  callMe() async {
    await Future.delayed(Duration(milliseconds: 500));
    getData().then((value) => {
      if(mounted){
        setState(() {
          data = value;
        })}
    });
  }

  @override
  void initState() {
    super.initState();
    callMe();

//    lat=widget.currentPosition.latitude;
//    lng=widget.currentPosition.longitude;
    }




  _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType =_currentMapType == MapType.normal?
      MapType.hybrid:MapType.normal;
    });
  }

  _goToMyLocation(_cameraPosition){
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  void _showBottom(UserModelWithDistance userModelWithDistance,UserModel user) {
    final userName=user?.name??"";
    showMaterialModalBottomSheet(
        backgroundColor: Colors.white.withOpacity(0),
        context: context,
        builder: (context, scrollController) =>
       Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          GestureDetector(onTap: ()=>Navigator.pop(context),
          child:Container(
              width: 45,height: 30,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(30)
              ),
              child: Center(child: Icon(Icons.arrow_drop_down,color: Colors.white,size: 30,))),),
        Container(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ItemList(
              color: Colors.red,
              bottomRadius: 0,
              userName: userModelWithDistance.userModel.name,
              area: userModelWithDistance.userModel.area,
              bloodType: userModelWithDistance.userModel.bloodType,
              distance: userModelWithDistance.distance,
              phoneOnTap:(){
                if(userName==""){
                  APlatformAlertDialog(
                    defaultActionText: "موافق",
                    cancelActionText: "لا",
                    title: "عذراً",
                    content: "لا يمكن اجراء العملية بدون تسجيل بياناتك",
                  ).show(context).then((value) => value==true?changeScreen(context, UserData.create(context: context,userModel: user),true):null);
                }else{
                  widget.customLaunch(context:context,command:'tel:${userModelWithDistance.userModel.phone}');
                }
              },
              nameTap:(){
                if(userName==""){
                  APlatformAlertDialog(
                    defaultActionText: "موافق",
                    cancelActionText: "لا",
                    title: "عذراً",
                    content: "لا يمكن اجراء العملية بدون تسجيل بياناتك",
                  ).show(context).then((value) => value==true?
                  changeScreen(context, UserData.create(context: context,userModel: user),true):null);
                }
                else{
                  //TODO كحل !!!
//                  Navigator.pop(context);
                  changeScreen(context, UserProfile(userModelWithDistance: userModelWithDistance,), true); }},
              smsOnTap:(){
                if(userName==""){
                  APlatformAlertDialog(
                    defaultActionText: "موافق",
                    cancelActionText: "لا",
                    title: "عذراً",
                    content: "لا يمكن اجراء العملية بدون تسجيل بياناتك",
                  ).show(context).then((value) => value==true?changeScreen(context, UserData.create(context: context,userModel: user),true):null);
                }else{
                  widget.customLaunch(context:context,command:'sms:${userModelWithDistance.userModel.phone}');
                }
              },
            ),
          ),
        ),
        Container(height: 45,)
      ],
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    final searchSetting = Provider.of<SearchSettings>(context);

    return  SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body:  StreamBuilder<UserModel>(
              stream: widget.database.userStream(widget.userFromFirebase),
              builder: (context, snapshot) {
                final user = snapshot?.data;
                final userName=user?.name??"";
              return Container(
                width: screenWidth(context),
                height: screenHeight(context),
                child: Stack(
                  children: [
                    StreamBuilder<List<UserModel>>(
                        stream: widget.database.usersStream(
                          bloodType: searchSetting.filter.bloodType,
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final List items = snapshot.data;
                            List<Marker> newMarkers = [];
                            if (items.isNotEmpty) {
                              _addMarkerToList(items, newMarkers, widget.userFromFirebase.uid,user);
                              return GoogleMap(
                                mapToolbarEnabled: false,
                                mapType: _currentMapType,
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        widget.currentPosition.latitude,widget.currentPosition.longitude),
                                    zoom: 17),
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                                markers: Set.from(markers),
                                onMapCreated: (GoogleMapController controller) {
                                  _googleMapController=controller;
                                },
                              );
                            }
                            else {
//                          return EmptyContent();
                              return GoogleMap(
                                mapType: _currentMapType,
                                mapToolbarEnabled: false,
                                initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        widget.currentPosition.latitude,widget.currentPosition.longitude),
                                    zoom: 17),
                                myLocationEnabled: true,
                                myLocationButtonEnabled: false,
                                zoomControlsEnabled: false,
                                onMapCreated: (GoogleMapController controller) {
                                  _googleMapController=controller;
                                },
                              );
                            }
                          }
                          else if (snapshot.hasError) {
                            return EmptyContent(
                              title: 'Something went wrong',
                              message: 'Can\'t load items right now',
                            );
                          }
                          return Center(child: CircularProgressIndicator());
                        }
                    ),

//                TODO retrive data from ()limit
                  data!=null? Positioned(
                      top: 7,right: 5,
                      child:makeMove? Column(
                        children: [
                          CustomFloatingButton(
                            onTap: (){setState(() {
                              makeMove=!makeMove;
                            });},
                            color: Colors.grey,
                            iconData: Icons.close,
                            heroTag: "mode1",
                          ),
                          SizedBox(height: 7,),
                          CustomFloatingButton(
                            onTap: _onMapTypeButtonPressed,
                            color: googleColor,
                            iconData: Icons.layers,
                            heroTag: "layers1",
                          ),
                          SizedBox(height: 7,),
                          CustomFloatingButton(
                            onTap:()=>_goToMyLocation(CameraPosition(
                                zoom: 17,
                                target: LatLng(widget.currentPosition.latitude,widget.currentPosition.longitude)
                            )),
                            color: googleColor,
                            iconData: Icons.my_location,
                            heroTag: "location2",
                          ),
                        ],
                      ):
                      CustomFloatingButton(
                        onTap: (){setState(() {
                          makeMove=!makeMove;
                        });},
                        color: googleColor,
                        iconData: Icons.mode_edit,
                        heroTag: "mode1",
                      ),
                    ):Container(),
                  ],
                ),
              );
            }
          )
        ),
      ),
    ) ;
  }

//  body:OfflineBuilder(
//  connectivityBuilder: ( BuildContext context,ConnectivityResult connectivity,
//  Widget child,  ){
//  final bool connected = connectivity != ConnectivityResult.none;
//  return  ;
//  },
//  )



  _addMarkerToList(items,newMarkers,currentUid,user)async{
    final searchSetting = Provider.of<SearchSettings>(context);
    double distanceFilter=(searchSetting.filter.distance)*1000;

    UserModelWithDistance userModelWithDistance;
    List distanceList=[];
    items.forEach((element) {
      double lat=element.userLocation.latitude;
      double lng=element.userLocation.longitude;
      double distance = widget.calculateDistance(widget.currentPosition.latitude,widget.currentPosition.longitude, lat,lng);
      distance=double.parse((distance).toStringAsFixed(1));
      if(distance<=distanceFilter){
        userModelWithDistance=UserModelWithDistance(userModel: element,distance: distance);
        distanceList.add(userModelWithDistance);
      }
    });
//    widget.myProviderList.setList(distanceList);

    var bitmapData;
    await Future.forEach(distanceList, (element) async {
      //TODO فكرة ان اخزن ال uid لكل user اعتقد فى طريقة افضل
      element.userModel.uid == currentUid??"" ? bitmapData = await _createAvatar(
          110, 110, element.userModel.bloodType,color: facebookColor):
      bitmapData = await _createAvatar(
          110, 110, element.userModel.bloodType) ;
      var bitmapDescriptor = BitmapDescriptor.fromBytes(bitmapData);
      var marker = Marker(
          onTap: () =>
              _showBottom(element,user),
          markerId: MarkerId(element.userModel.uid),
          position: LatLng(
            element.userModel.userLocation.latitude, element.userModel.userLocation.longitude,),
          icon: bitmapDescriptor
      );
      newMarkers.add(marker);
    });
    if (mounted) {
      setState(() {
        markers = newMarkers;
      });
    }
  }
//TODO فى مشكلة بعد ما بيسجل بياناته لما يرجع لو ال bottom sheet ويدوس على الاسم هيقوله سجل بياناتك
  Future<Uint8List> _createAvatar(int width, int height, String name,
      {Color color : Colors.red}) async {
    final PictureRecorder pictureRecorder = PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()
      ..color = color;

    final double radius = width / 2;
    canvas.drawOval(
      Rect.fromCircle(
          center: Offset(radius, radius), radius: radius),
      paint,
    );

    final TextPainter painter = TextPainter(textDirection: TextDirection.ltr,);
    painter.text = TextSpan(
      text: name,
      style: TextStyle(
        fontSize: radius - 5,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
    painter.layout();
    painter.paint(canvas, Offset((width * .5) - painter.width * .5,
        (height * .5) - painter.height * .5));
    final image = await pictureRecorder.endRecording().toImage(width, height);
    final data = await image.toByteData(format: ImageByteFormat.png);
    return data.buffer.asUint8List();
  }
}