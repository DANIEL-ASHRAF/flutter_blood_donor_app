
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_app/common_widgets/custom_button.dart';
import 'package:map_app/common_widgets/empty_content.dart';
import 'package:map_app/screens/home/components/my_list_page.dart';
import 'package:map_app/screens/home/components/my_map_page.dart';
import 'package:map_app/screens/home/tab_item.dart';
import 'package:map_app/services/permission.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'components/my_app_bar.dart';
import 'components/my_drawer.dart';
import 'cupertino_home_scaffold.dart';
class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.map;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.map: GlobalKey<NavigatorState>(),
    TabItem.list: GlobalKey<NavigatorState>(),
  };
  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.map: (context) => MYMapPage.create(context: context),
      TabItem.list: (context) => MYListPage.create(context: context),
    };
  }
  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  String data;
  Future getData() async {
    String dataIn="test";
    return dataIn;
  }
  callMe() async {
    await Future.delayed(Duration(milliseconds: 1000));
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
//    _listenForStatus();
  }

  PermissionStatus _permissionStatus;
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

  void _listenForPermissionStatus() async {
    final status = await Permission.location.status;
    if(mounted){
      setState(() => _permissionStatus = status);
    }
  }

  @override
  Widget build(BuildContext context) {
    _listenForPermissionStatus();
    if(!service){_listenForGpsStatus();}
    return SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
              appBar: data!=null? PreferredSize(
                  preferredSize: const Size.fromHeight(55),
                  child: MYAppBar()):null,
              drawer: MYDrawer(),
          body:data !=null? Directionality(
            textDirection: TextDirection.ltr,
           child: OfflineBuilder(
                  connectivityBuilder: ( BuildContext context,ConnectivityResult connectivity,
                      Widget child,  ){
                    final bool connected = connectivity != ConnectivityResult.none;
                    return connected?
                    _permissionStatus== PermissionStatus.granted?
                    service?
                    Provider.of<Position>(context)!= null?
                    WillPopScope(
                        onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
                      child: CupertinoHomeScaffold(
                        currentTab: _currentTab,
                        onSelectTab: _select,
                        widgetBuilders: widgetBuilders,
                        navigatorKeys: navigatorKeys,
                      ),
                    )
                        : EmptyContent(title: "تحديد الموقع",message: "لا يمكن الوصول الى موقعك الحالى",)
                        :PermissionWidget( Permission.location)
                        :PermissionWidget( Permission.location)
                        : EmptyContent(title: "لا يوجد انترنت",message: "من فضلك قم بتشغيل الانترنت",);
                  },
                  child:Container()
              )
          ): Center(child: CircularProgressIndicator(),) ,
        ),
      ),
    );
  }
}
