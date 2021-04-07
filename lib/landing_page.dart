import 'package:flutter/material.dart';
import 'package:map_app/screens/home/home_page.dart';
import 'package:map_app/screens/sign_in/sign_in_page.dart';
import 'package:map_app/services/auth.dart';
import 'package:map_app/services/database_firebase.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final database = Provider.of<DatabaseFirebase>(context, listen: false);


    return StreamBuilder<UserFromFirebase>(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            UserFromFirebase user = snapshot.data;
            if (user == null) {
              return SignInPage.create(context);
            }
          return Provider<UserFromFirebase>.value(
            value: user,
            //TODO ask remove it and make your reference userFromFirebase علشان ده عك
              //TODO ممكن اضيف ال stream builder <list<userModel>> وابعته لل home ومنها لل map and list
//            child:StreamProvider<UserModel>.value(
//              value:database.userStream(user),
                child: HomePage());
//          );
          } else {
            return Scaffold(
              body: Center(
                child: Container(),
//                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
