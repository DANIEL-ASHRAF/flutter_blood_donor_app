import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_app/common_widgets/custom_floating_button.dart';
import 'package:map_app/common_widgets/platform_alert_dialog.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/models/user_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';


class SelectMarkerPage extends StatefulWidget {
//  final Database database;
final UserLocation geo;
  const SelectMarkerPage({Key key, this.geo}) : super(key: key);

  @override
  _SelectMarkerPageState createState() => _SelectMarkerPageState();
}

class _SelectMarkerPageState extends State<SelectMarkerPage> {
  List<Marker> myMarker=[];
  double lng;
  double lat;
  GoogleMapController googleMapController;
  BitmapDescriptor customIcon;
//  Geo geo;

  @override
  void initState() {
    super.initState();
    lat = widget.geo?.latitude ?? 0;
    lng = widget.geo?.longitude ?? 0;
  }


  createMarker(context) {
    if (customIcon == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);
      BitmapDescriptor.fromAssetImage(configuration, 'assets/custom_marker.png')
          .then((icon) {
        setState(() {
          customIcon = icon;
        });
      });
    }
  }

  _create() {
    setState(() {
      myMarker=[];
      myMarker.add(Marker(
          icon: customIcon,
          markerId: MarkerId(lat.toString()),
          position: LatLng(lat,lng),
          draggable: true,
          onDragEnd: (dragEndPosition){
            lng=dragEndPosition.longitude;
            lat=dragEndPosition.latitude;
          }
      ));
    });
//    print(myMarker[0]??"");
  }


  _handleTap(LatLng argument) {
    setState(() {
      myMarker=[];
      myMarker.add(Marker(
          icon: customIcon,
          markerId: MarkerId(argument.toString()),
          position: argument,
          draggable: true,
          onDragEnd: (dragEndPosition){
            lng=dragEndPosition.longitude;
            lat=dragEndPosition.latitude;
            print("lng : $lng");
            print("lat : $lat");

          }
      ));
      lng=argument.longitude;
      lat=argument.latitude;
      print("lng : $lng");
      print("lat : $lat");
    });
//    print(myMarker[0]??"");
  }
  bool makeMove=false;

  @override
  Widget build(BuildContext context) {
    final currentPosition =Provider.of<Position>(context);
//    final database=  Provider.of<Database>(context);
    createMarker(context);
  if(lat!=0){ _create();}
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body:currentPosition!=null? Container(
            width: screenWidth(context),
            height: screenHeight(context),
            child: Stack(
              children: [
                GoogleMap(
                  mapType: _currentMapType,
                  mapToolbarEnabled: false,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  initialCameraPosition: CameraPosition(target: LatLng(currentPosition.latitude,currentPosition.longitude),zoom: 20 ),
                  zoomControlsEnabled: false,
//            mapType: MapType.hybrid,
                  markers:Set.from(myMarker),
                  onMapCreated: (GoogleMapController controller) {
                    _googleMapController=controller;
                  },
                  onTap: _handleTap,
                ),
                Positioned(
                  top: 7,right: 5,
                  child:SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        makeMove? Column(
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
                                  zoom: 20,
                                  target: LatLng(currentPosition.latitude,currentPosition.longitude)
                              )),
                              color: googleColor,
                              iconData: Icons.my_location,
                              heroTag: "location2",
                            ),
                            SizedBox(height: 7,),
                            CustomFloatingButton(
                              onTap:()=>_goToMyLocation(CameraPosition(
                                  zoom: 20,
                                  target: LatLng(currentPosition.latitude,currentPosition.longitude)
                              )),
                              color: googleColor,
                              text: "؟",
                              heroTag: "ww",
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
                        SizedBox(height: 7,),
                        CustomFloatingButton(
                          heroTag: "qq",
                          onTap: (){
                            if(lat==0&&lng==0){
                              APlatformAlertDialog(
                                defaultActionText: "موافق",
                                title: 'تنبيه هام',
                                content:"يجب اختيار مكانك" ,
                              ).show(context);
                            }else{
                              if(lat>=22&&lat<=32&&lng>=24&&lng<=37){
                                UserLocation myLocation = UserLocation( latitude: lat,longitude: lng);
                                Navigator.pop(context, myLocation);
                              }else{
                                APlatformAlertDialog(
                                  defaultActionText: "موافق",
                                  title: 'خارج مصر',
                                  content:"يجب ان يكون مكانك داخل مصر" ,
                                ).show(context);
                              }
                            }
                          },
                          color: googleColor,
                          iconData: Icons.done,
                        ),
                      ],
                    ),
                  )
                ),
              ],
            ),
          )
              :Center(
            child: CircularProgressIndicator(),
          ),
        ) ,
      ),
    );
  }
  MapType _currentMapType =MapType.normal;
  GoogleMapController _googleMapController;

  _onMapTypeButtonPressed(){
    setState(() {
      _currentMapType =_currentMapType == MapType.normal?
      MapType.hybrid:MapType.normal;
    });
  }
  _goToMyLocation(_cameraPosition){
    _googleMapController.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  void _showBottom(String name, String phone, String bloodType,double distance,String area,UserModel user) {
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
              ],
            )
    );
  }

}