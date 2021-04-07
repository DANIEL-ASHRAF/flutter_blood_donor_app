import 'package:flutter/material.dart';
import 'package:map_app/helper/ui_helpers.dart';

class ItemList extends StatelessWidget {
  ItemList(
      {Key key,
        @required  this.userName,
        @required  this.phoneOnTap,
        @required this.smsOnTap,
        @required this.nameTap,
        @required this.bloodType,
        @required this.color,
        this.distance,
        this.topRadius:20, this.bottomRadius:20, this.area,
      });
  final String userName;
  final String bloodType;
  final double distance;
  final String area;
  final VoidCallback phoneOnTap;
  final VoidCallback smsOnTap;
  final VoidCallback nameTap;
  final Color color;
  final double topRadius;
  final double bottomRadius;


  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(topRight:Radius.circular(topRadius) ,
              topLeft:Radius.circular(topRadius) ,
              bottomLeft:Radius.circular(bottomRadius) ,
              bottomRight:Radius.circular(bottomRadius) )
        ),
        height: screenWidth(context)*.5,
        margin: EdgeInsets.only(top: 10),
//        padding: EdgeInsets.only(left: 10,right: 20),
         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             SizedBox(height: 10,),
             Expanded(
               child: Container(
//                 padding: EdgeInsets.only(left: 10,right: 20),
                   child: Text(bloodType, maxLines: 1,textScaleFactor: 1,
                     textDirection: TextDirection.ltr,
                     style: TextStyle(color: Colors.white,
                         fontWeight: FontWeight.bold,
                         fontSize: screenWidth(context)*.068),)),
             ),
             Expanded(
             child: Container(
                 child: Row(
                   children: [
                     SizedBox(width: 10,),
                     Expanded(
                       child: Container(
                         child: InkWell(
                           onTap: nameTap,
                           child: Text(userName, maxLines: 1,textScaleFactor: 1,
                             style: TextStyle(color: Colors.white,
                                 fontWeight: FontWeight.bold,
                                 fontSize: screenWidth(context)*.066),),
                         ),
                       ),
                     ),
                     SizedBox(width: 10,),
                     InkWell(
                         onTap: smsOnTap,
                         child: Icon(Icons.sms, size: screenWidth(context)*.08, color: Colors.white,)),
                     SizedBox(width: 10,),
                     InkWell(
                         onTap: phoneOnTap,
                         child: Icon(Icons.phone, size: screenWidth(context)*.08, color: Colors.white,)),
                     SizedBox(width: 10,),
                   ],),
               ),
             ),
             Expanded(
             child: Container(
                 child: Text( distance>=1000? "المسافة: "+ (distance/1000).toString()+" كيلومتر": "المسافة: "+ distance.toString()+" متر",textScaleFactor: 1, maxLines: 1,
                   style: TextStyle(color: Colors.white,
                       fontWeight: FontWeight.bold,
                       fontSize: screenWidth(context)*.066),),
               ),
             ),
             Expanded(
             child: Container(
                 child: Text("المنطقة: " +area  , maxLines: 1,textScaleFactor: 1,
                   style: TextStyle(color: Colors.white,
                       fontWeight: FontWeight.bold,
                       fontSize: screenWidth(context)*.066),),
               ),
             ),
           ],
         ),
      );


//  return Container(
//    decoration: BoxDecoration(
//        color: color,
//        borderRadius: BorderRadius.only(topRight:Radius.circular(topRadius) ,
//            topLeft:Radius.circular(topRadius) ,
//            bottomLeft:Radius.circular(bottomRadius) ,
//            bottomRight:Radius.circular(bottomRadius) )
//    ),
//    height: screenWidth(context)*.5,
//    margin: EdgeInsets.only(top: 10),
//    child: ListTile(
//      title:Text(userName, maxLines: 1,textScaleFactor: 1,
//         style: TextStyle(color: Colors.white,
//         fontWeight: FontWeight.bold,
//         fontSize: screenWidth(context)*.066),),
//      leading: CircleAvatar(radius: 30,child:Text(bloodType, maxLines: 1,textScaleFactor: 1,
//                       textDirection: TextDirection.ltr,
//                       style: TextStyle(color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: screenWidth(context)*.068),)),
//      subtitle: Text( distance>=1000? "المسافة: "+ (distance/1000).toString()+" كيلومتر": "المسافة: "+ distance.toString()+" متر",textScaleFactor: 1, maxLines: 1,
//                 style: TextStyle(color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: screenWidth(context)*.066),),
//      trailing: Row(children: [
//        InkWell(
//                           onTap: smsOnTap,
//                           child: Icon(Icons.sms, size: screenWidth(context)*.08, color: Colors.white,)),
//                       SizedBox(width: 10,),
//                       InkWell(
//                           onTap: phoneOnTap,
//                           child: Icon(Icons.phone, size: screenWidth(context)*.08, color: Colors.white,)),
//                       SizedBox(width: 10,),
//      ],),
//    ),
//  );
  }
}
