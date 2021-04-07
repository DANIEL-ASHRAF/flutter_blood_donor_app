
import 'package:flutter/material.dart';
import 'package:map_app/models/user_model.dart';

void changeScreen(BuildContext context,Widget widget ,bool rootNavigator){
Navigator.of(context,rootNavigator:rootNavigator ).push(MaterialPageRoute(builder: (context)=>widget));
}

void changeScreenWithoutAnimation(BuildContext context,Widget widget ){
  Navigator.push(
    context,
    PageRouteBuilder(pageBuilder: (_, __, ___) => widget),
  );
}

void previousScreen(BuildContext context ){
  Navigator.pop(context);
}

void changeScreenReplacement(BuildContext context,Widget widget ){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>widget));
}

void beginScreen(BuildContext context,Widget widget )async{
  Route route = MaterialPageRoute(builder: (context)=>widget);
  await Navigator.pushAndRemoveUntil(context,route, (Route<dynamic> route) => true);
}

//updateInformation(dynamic information) {
//  return information;
//}

//when use it remember use async and await
dynamic moveToSecondPage(BuildContext context,Widget widget) async {
  final information = await Navigator.push(context,
    MaterialPageRoute(
        builder: (context) => widget),
  );
//  updateInformation(information);
return information;
}