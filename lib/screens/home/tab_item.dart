import 'package:flutter/material.dart';

enum TabItem { map, list }

class TabItemData {
  const TabItemData({@required this.title, @required this.icon});

  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.map: TabItemData(title: 'الخريطة', icon: Icons.map),
    TabItem.list: TabItemData(title: 'القائمة', icon: Icons.list),
//    TabItem.account: TabItemData(title: 'Account', icon: Icons.person),
  };
}