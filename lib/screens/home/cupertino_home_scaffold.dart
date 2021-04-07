import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/screens/home/tab_item.dart';

class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key key,
    @required this.currentTab,
    @required this.onSelectTab,
    @required this.widgetBuilders,
    @required this.navigatorKeys,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _buildItem(TabItem.map,context),
          _buildItem(TabItem.list,context),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilders[item](context),
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem,BuildContext context) {
    final itemData = TabItemData.allTabs[tabItem];
    final color = currentTab == tabItem ? googleColor : Colors.grey;
    return BottomNavigationBarItem(
      icon: itemData.title=="القائمة"?
      Container(
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              itemData.title,textScaleFactor: 1,
              style: TextStyle(color: color,fontSize: screenWidth(context)*.066,fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5,),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Icon(
                itemData.icon,
                color: color,
                size: screenWidth(context)*.082,
              ),
            ),
          ],
        ),
      ):
      Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: Colors.grey))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              itemData.title,textScaleFactor: 1,
              style: TextStyle(color: color,fontSize:screenWidth(context)*.066,fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 5,),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Icon(
                itemData.icon,
                color: color,
                size: screenWidth(context)*.082,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
