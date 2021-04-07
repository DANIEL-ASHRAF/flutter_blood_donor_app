import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_app/common_widgets/custom_button.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
/// Permission widget which displays a permission and allows users to request
/// the permissions.
class PermissionWidget extends StatefulWidget {
  /// Constructs a [PermissionWidget] for the supplied [Permission].
  const PermissionWidget(this._permission );
  final Permission _permission;
  @override
  _PermissionState createState() => _PermissionState(_permission);
}

class _PermissionState extends State<PermissionWidget> {
  _PermissionState(this._permission);

  final Permission _permission;
  PermissionStatus _permissionStatus = PermissionStatus.undetermined;

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
    _listenForPermissionStatus();
  }

  void _listenForPermissionStatus() async {
    final status = await _permission.status;
    setState(() => _permissionStatus = status);
  }

  bool service=false;
  void _listenForGpsStatus() async {
    if(!(await isLocationServiceEnabled())){
      if(mounted){
        setState(() => service = false);
      }
    }else{
      if(mounted){
        setState(() => service = true);
      }
    }
  }

  Color getPermissionColor() {
    switch (_permissionStatus) {
      case PermissionStatus.denied:
        return Colors.red;
      case PermissionStatus.granted:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    _listenForPermissionStatus();
  if(service){  _listenForGpsStatus();}
    return  SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,width: MediaQuery.of(context).size.width,
        child: data==null?Center(child: CircularProgressIndicator(),):  Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "خدمة تحديد الموقع",maxLines: 1,textScaleFactor: 1,
                style: TextStyle(fontSize: screenWidth(context)*.09, color:facebookColor,fontWeight: FontWeight.bold),
              ),
              Text(
                "يجب السماح للتطبيق للوصول الى خدمة الموقع",maxLines: 1,textScaleFactor: 1,
                style: TextStyle(fontSize: screenWidth(context)*.055, color: enableBorderColor,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              _permissionStatus ==PermissionStatus.granted ?
           Container(
//                child: Text("من فضلك قم بتشغل خدمة تحديد الموقع", maxLines: 1,textScaleFactor: 1, style: TextStyle(fontSize: screenWidth(context)*.064, color: Colors.red,fontWeight: FontWeight.bold),),):
             child:   Row(
               children: [
                 Expanded(
                   child: Container(
                     padding: EdgeInsets.all(12),
                     child: CustomButton(
//                      onTap:(){
//                        AppSettings.openLocationSettings();},
                       onTap: ()=> AppSettings.openLocationSettings(),
//                    onTap: ()=>widget.onTap,
                       text: "تشغيل خدمة الموقع",
                     ),
                   ),
                 ),
               ],
             ),):
           _permissionStatus ==PermissionStatus.denied?
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: CustomButton(
//                      onTap:(){
//                        AppSettings.openLocationSettings();},
                        onTap: ()=> requestPermission(_permission),
//                    onTap: ()=>widget.onTap,
                        text: "الوصول لخدمة الموقع",
                      ),
                    ),
                  ),
                ],
              )
                  :Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(12),
                      child: CustomButton(
                        onTap:()=> AppSettings.openAppSettings(),
                        text: "الوصول لخدمة الموقع",
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ) ;



//      ListTile(
//      title: Text(_permission.toString()),
//      subtitle: Text(
//        _permissionStatus.toString(),
//        style: TextStyle(color: getPermissionColor()),
//      ),
//      trailing: IconButton(
//          icon: const Icon(Icons.info),
//          onPressed: () {
//            checkServiceStatus(context, _permission);
//          }),
//      onTap: () {
//        requestPermission(_permission);
//      },
//    );
  }

  void checkServiceStatus(BuildContext context, Permission permission) async {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text((await permission.status).toString()),
    ));
  }

  Future<void> requestPermission(Permission permission) async {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }
}