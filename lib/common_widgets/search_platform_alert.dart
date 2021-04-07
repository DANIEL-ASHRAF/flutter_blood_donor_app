import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:map_app/common_widgets/platform_widget.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/ui_helpers.dart';
import 'package:map_app/models/search_model.dart';
import 'package:provider/provider.dart';

// move the dialog into it's own stateful widget.
// It's completely independent from your page
// this is good practice
class SearchDataPickerDialog extends StatefulWidget {
  /// initial selection for the slider
  final SearchModel searchModel;
  const SearchDataPickerDialog({Key key, this.searchModel}) : super(key: key);

  @override
  _SearchDataPickerDialogState createState() => _SearchDataPickerDialogState();
}

class _SearchDataPickerDialogState extends State<SearchDataPickerDialog> {
  /// current selection of the slider
  @override
  void initState() {
    super.initState();
//    _searchModel = widget.searchModel;
     _distance=widget.searchModel?.distance??10.0;
     _bloodType=widget.searchModel?.bloodType??"الكل";
  }
  //if U change string in _donorsAvailbale list must change in searchSettings (SearchModel)
//  bool _donorAvailable;
  double _distance;
  String _bloodType;
  @override
  Widget build(BuildContext context) {

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
//        title: Container(
//            height: 35,
//            child: Text('بحث')),
        shape: RoundedRectangleBorder(borderRadius:
        BorderRadius.all(
            Radius.circular(10.0)),),
        content: Container(
          height: screenWidth(context)*.5,
          width: screenWidth(context)*.9,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                width: screenWidth(context)*.4,
                    child: Text("اختر فصيلة الدم:",textScaleFactor: 1, maxLines: 1, style: TextStyle(fontSize: screenWidth(context)*.055,color: facebookColor,fontWeight:FontWeight.bold),)),
              ),
              Expanded(
                child: CustomRadioButton(
                  defaultSelected: _bloodType,
                  width:MediaQuery.of(context).size.width/4.4 ,
//                  height: screenWidth(context)/2,
                  enableShape: true,
                  customShape: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: googleColor, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                  unSelectedColor: Colors.white,
                  buttonLables: [
                    'الكل',  '+A', '-A',
                    '+B', '-B',
                    '+AB', '-AB',
                    '+O', '-O',
                  ],
                  buttonValues: [
                    'الكل',  'A+', 'A-',
                    'B+', 'B-',
                    'AB+', 'AB-',
                    'O+', 'O-',
                  ],
                  buttonTextStyle: ButtonTextStyle(
                      selectedColor: Colors.white,
                      unSelectedColor: googleColor,
                      textStyle: TextStyle(fontSize:  screenWidth(context)*.05, color: googleColor,)),
                  radioButtonValue: (value) {
                     _bloodType=value;
                  },
                  selectedColor: googleColor,
                ),
              ),
              Expanded(child: SizedBox(height: 10,)),
              Expanded(child: Text("اقصى مسافة: ${double.parse((_distance).toStringAsFixed(1))} كيلومتر ", maxLines: 1, textScaleFactor: 1.0, style: TextStyle(fontSize:  screenWidth(context)*.055,color: facebookColor,fontWeight: FontWeight.bold),)),
              Expanded(
                child: Container(
                  height: 15,
                  child: Slider(
                    value: _distance,
                    min: 10,
                    max: 300,
                    divisions: 29,
                    onChanged: (value) {
                      setState(() {
                        _distance = value;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          //TODO when click out of dialog
          FlatButton(
            onPressed: () {
              SearchModel _searchModel=SearchModel(distance:_distance ,bloodType: _bloodType );
              Navigator.pop(context,_searchModel);
            },
            child: Text('بحث',textScaleFactor: 1, style: TextStyle(fontSize: screenWidth(context)*.062, color: facebookColor,fontWeight: FontWeight.bold),),
          )
        ],
      ),
    );
  }
}

////////
//Column(
//children: [
//Text("اختر فصيلة الدم",),
//CustomRadioButton(
////                defaultSelected: _bloodTypeLetter,
//width:70,
//enableShape: true,
//customShape: OutlineInputBorder(
//borderSide: BorderSide(
//color: darkYellow, width: 2),
//borderRadius: BorderRadius.circular(10),
//),
//elevation: 0,
//unSelectedColor: Colors.white,
//buttonLables: [
//'+A','-A',
//'+B','-B',
//'+AB','-AB',
//'+O','-O','الكل'
//],
//buttonValues: [
//'A+','A-',
//'B+','B-',
//'AB+','AB-',
//'O+','O-','الكل'
//],
//buttonTextStyle: ButtonTextStyle(
//selectedColor: Colors.white,
//unSelectedColor: darkYellow,
//textStyle: TextStyle(fontSize: 20,color: darkYellow)),
//radioButtonValue: (value) {
////                  _bloodTypeLetter=value;
//},
//selectedColor: darkYellow,
//),
//Text("All .... only true ... only false",style: TextStyle(fontSize: 22),),
//Text("slider for distance",style: TextStyle(fontSize: 22),),
//Container(
//height: 10,
//child: Slider(
//min: 1,max: 10,
//value:widget.valueForSlider ,
//onChanged:widget.onChangedSlider,
//divisions: 10,
//),
//)
//],
//)
//////




