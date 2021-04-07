//import 'package:device_preview/device_preview.dart'as devicePreview;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/services/auth.dart';
import 'package:map_app/services/database_firebase.dart';
import 'package:map_app/services/geoLocator_service.dart';
import 'package:provider/provider.dart';
//import 'common_widgets/portrait_mode_mixin.dart';
import 'helper/constants/route_names.dart';
import 'landing_page.dart';
import 'models/search_model.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown]);
  runApp(MyApp());
//  runApp(
//     devicePreview.DevicePreview(
//    enabled: false,
//    builder: (context) => MyApp(),
//  ));
}
class MyApp extends StatelessWidget  {
  @override
  Widget build(BuildContext context) {
//    super.build(context);
    return MultiProvider(
        providers: [
          Provider<AuthBase>(
            create: (context) => Auth(),),
          ChangeNotifierProvider<SearchSettings>(
            create: (_)=>SearchSettings(),
          ),
          Provider<DatabaseFirebase>(
            create: (context) => FirestoreDatabase(),),
          FutureProvider<Position>(
            create: (context)=>GeoLocatorService().getLocation(),
          )
        ],
        child: MaterialApp(
//            locale:devicePreview.DevicePreview.of(context).locale, // <--- /!\ Add the locale
//            builder:devicePreview.DevicePreview.appBuilder,
            debugShowCheckedModeBanner: false,
            title: 'دمك ينقذ حياة',
            theme: ThemeData(
              primaryColor: googleColor,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: LandingPageRoute,
            routes: {
              LandingPageRoute:(context)=>LandingPage()
            }
        )
    );
  }
}
