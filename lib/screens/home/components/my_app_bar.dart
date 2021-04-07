import 'package:flutter/material.dart';
import 'package:map_app/common_widgets/search_platform_alert.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/models/search_model.dart';
import 'package:map_app/services/auth.dart';
import 'package:provider/provider.dart';

class MYAppBar extends StatefulWidget {

  @override
  _MYAppBarState createState() => _MYAppBarState();
}

class _MYAppBarState extends State<MYAppBar> {
  SearchModel _searchModel ;

  void _showSearchPickerDialog() async {
    // <-- note the async keyword here
    final searchSetting = Provider.of<SearchSettings>(context,listen: false);

    // this will contain the result from Navigator.pop(context, result)
    SearchModel selectFromSearch = await showDialog<SearchModel>(
    context: context,
      builder: (context) => SearchDataPickerDialog(searchModel: searchSetting.filter,),
    );

    // execution of this code continues when the dialog was closed (popped)

    // note that the result can also be null, so check it
    // (back button or pressed outside of the dialog)
    if (selectFromSearch != null) {
      searchSetting.setFilter(selectFromSearch);
    }
  }
@override
Widget build(BuildContext context) {
  final auth = Provider.of<AuthBase>(context,listen:false);
  var _currents=["A+","A-", "B+","B-", "AB+", "AB-", 'O+', 'O-',"الكل"];
  final searchSetting = Provider.of<SearchSettings>(context);
double distance=5;
  return Container(
    height: screenWidth(context)*.2,
    child: AppBar(
      leading: InkWell(
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Icon(Icons.menu,size: screenWidth(context)*.082,)),
      actions: [
        InkWell(
          onTap: _showSearchPickerDialog,
          child: Container(
              padding: EdgeInsets.only(left: 10),
              child: Icon(Icons.search, color: Colors.white, size: screenWidth(context)*.082,)),
        ),

      ],
      centerTitle: true,
      title: Text("دمك ينقذ حياة", maxLines: 1,textScaleFactor: 1,
        style: TextStyle(fontSize: screenWidth(context)*.066,
            fontWeight: FontWeight.bold,
            color: Colors.white),),
    ),
  );
}
}
