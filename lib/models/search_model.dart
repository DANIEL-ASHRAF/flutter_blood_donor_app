import 'package:flutter/cupertino.dart';

class SearchSettings extends ChangeNotifier {
  SearchModel filter=SearchModel(bloodType:null ,distance:10.0 ) ;

  setFilter(SearchModel x){
    filter.distance=x?.distance??10.0;
    filter.bloodType=x?.bloodType??null;
    if(filter.bloodType=="الكل"){
      filter.bloodType=null;
    }
  }
//  get myFilter =>_filter;
  notifyListeners();
}

class SearchModel{
  SearchModel({
    this.bloodType,
    this.distance
  });

  String bloodType;
  double distance;

  factory SearchModel.fromJson(Map<String, dynamic> json) => SearchModel(
    bloodType: json["bloodType"],
    distance: json["distance"],
  );

  Map<String, dynamic> toJson() => {
    "bloodType": bloodType,
    "distance": distance,
  };
}
