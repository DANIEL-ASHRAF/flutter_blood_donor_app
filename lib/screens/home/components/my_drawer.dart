import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:map_app/common_widgets/platform_alert_dialog.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/screen_navigation.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/models/user_model.dart';
import 'package:map_app/screens/sign_in/user_data.dart';
import 'package:map_app/screens/suggestion_page.dart';
import 'package:map_app/services/auth.dart';
import 'package:map_app/services/database_firebase.dart';
import 'package:provider/provider.dart';

import '../../blood_donation_campaigns.dart';

class MYDrawer extends StatelessWidget {
//  const MYDrawer({Key key,@required this.userModel}) : super(key: key);

//  final UserModel userModel;
  bool isLoading=true;

  @override
  Widget build(BuildContext context) {
    final userFromFirebase = Provider.of<UserFromFirebase>(context,listen: false);
    final database = Provider.of<DatabaseFirebase>(context, listen: false);
    final auth=Provider.of<AuthBase>(context,listen: false);
    return StreamBuilder<UserModel>(
        stream: database.userStream(userFromFirebase),
        builder: (context, snapshot) {
          // TODO refactor and use items builder
          final user = snapshot?.data;
          final userName=user?.name??"";
        return ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
          child: Container(
            width: MediaQuery.of(context).size.width *.66,
            child: Drawer(
              child: ListView(
                children: [
                  Container(
                    color: googleColor,
                    height: screenWidth(context)*.35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20,),
                        Text("  اهلا بك", textScaleFactor: 1.0, style: TextStyle(fontSize: screenWidth(context)*.067,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),),
                        Text(user?.name == null ?"":"        "+user?.name,maxLines: 1, textScaleFactor: 1.0,overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: screenWidth(context)*.055,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),)
                      ],
                    )
                  ),
                  SizedBox(height: 10,),
                  InkWell(
                    onTap: (){
                      changeScreen(context, UserData.create(context: context,userModel: user),true);
                    },
                    child: Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Row(
                      children: [
                        Icon(Icons.person,color: facebookColor,size: screenWidth(context)*.08,),
                        SizedBox(width: 5,),
                        Text(user?.name != null?"تعديل البيانات":"تسجيل البيانات",maxLines: 1,textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: screenWidth(context)*.066,
                            fontWeight: FontWeight.bold,color: facebookColor),),
                      ],),),

                  ),
                  SizedBox(height: 10,),
                  Container(
                    padding: EdgeInsets.only(right: 5),
                    child: GestureDetector(
                      onTap: (){
                        changeScreen(context, SuggestionPage(userFromFirebase: userFromFirebase,),true);
                      },
                      child: Row(children: [
                      Icon(Icons.insert_emoticon,color: facebookColor,size:screenWidth(context)*.08),
                      SizedBox(width: 5,),
                      Text("ارسال الاقتراحات",maxLines: 1, textScaleFactor: 1.0, style: TextStyle(
                          fontSize: screenWidth(context)*.066,
                          fontWeight: FontWeight.bold,color: facebookColor),),
                      ],),
                    ),
                  ),
                  SizedBox(height: 10,),
//              GestureDetector(
//                onTap: (){},
//                child: Container(
//                  child: Row(children: [
//                    Icon(Icons.description),
//                    Expanded(
//                      child: AutoSizeText("اجراءات هامة يجب معرفتها قبل التبرع بالدم",maxLines: 1, style: TextStyle(
//                          fontSize: 20,
//                          fontWeight: FontWeight.bold,
//                          color: Colors.black),),
//                    ),
//                  ],),),
//              ),
                  Container(
                      padding: EdgeInsets.only(right: 5),
                    child: GestureDetector(
                      onTap: (){
                        changeScreen(context, BloodDonationCampaigns(),true);
                      },
                      child: Row(children: [
                      Icon(Icons.people,color: facebookColor,size:screenWidth(context)*.08),
                      SizedBox(width: 5,),
                      Text("حملات التبرع بالدم",maxLines: 1,textScaleFactor: 1.0,  style: TextStyle(
                          fontSize: screenWidth(context)*.066,
                          fontWeight: FontWeight.bold,color: facebookColor),),
                      ],),
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){},
                    child: Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Row(children: [
                      Icon(Icons.share,color: facebookColor,size: screenWidth(context)*.08),
                      SizedBox(width: 5,),
                      Text("مشاركة البرنامج",maxLines: 1,textScaleFactor: 1.0,  style: TextStyle(
                          fontSize: screenWidth(context)*.066,
                          fontWeight: FontWeight.bold,color: facebookColor),),
                    ],),),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                  ),
                  SizedBox(height: 15 ,),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          children: [
                            IconButton(
                              iconSize: 35,
                              icon:Icon(Icons.phone,color: facebookColor,),
                              onPressed: (){},
                            ),
                            Positioned(
                              left:0,top:-3,
                              child: Center(child: Text("+99",style: TextStyle(color: facebookColor),)),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            IconButton(
                              iconSize: 35,
                              icon:Icon(Icons.sms,color: facebookColor,),
                              onPressed: (){},
                            ),
                            Positioned(
                              left:0,top:-3,
                              child: Center(child: Text("+99",style: TextStyle(color: facebookColor),)),
                            )
                          ],
                        ),
                        Stack(
                          children: [
                            IconButton(
                              iconSize: 35,
                              icon:Icon(Icons.favorite,color: googleColor,),
                              onPressed: (){},
                            ),
                            Positioned(
                              left:0,top:-3,
                              child: Center(child: Text("+99",style: TextStyle(color: facebookColor),)),
                            )
                          ],
                        ),
                        SizedBox(width: 10,)
                      ],),),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Divider(
                      color: Colors.grey,
                      thickness: 2,
                    ),
                  ),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap:  isLoading?  (){
                   APlatformAlertDialog(
                        defaultActionText: "نعم",
                        title: "تسجيل الخروج",
                        content: "هل تريد تأكيد تسجيل الخروج ؟"
                            "سوف يتم مسح بياناتك.",
                        cancelActionText: "لا",
                      ).show(context).then((value){
                        if(value==true)
                          {
                            isLoading=false;
                            try {
                              database.deleteUser(
                                  userFromFirebase: userFromFirebase);
                              auth.signOut();
                            }catch(e){
                              isLoading=true;
                              APlatformAlertDialog(
                                defaultActionText: "موافق",
                                title: "فشل تسجيل الخروج",
                                content:"حدث مشكلة من فضلك حاول ثانية.",
                              ).show(context);
                            }
                          }
                         }
                       );
                     } :(){},
                    child: Container(
                      padding: EdgeInsets.only(right: 5),
                      child: Row(children: [
                      Icon(Icons.exit_to_app,color: facebookColor,size: screenWidth(context)*.08),
                      SizedBox(width: 5,),
                      Expanded(
                        child: Text("تسجيل الخروج",maxLines: 1,textScaleFactor: 1,  style: TextStyle(
                            fontSize: screenWidth(context)*.066,
                            fontWeight: FontWeight.bold,
                            color: facebookColor),),
                      ),
                    ],),),
                  ),

                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
