
//import 'dart:convert';
//
//List<User> userFromJson(String str) => List<User>.from(json.decode(str).map((x) => User.fromJson(x)));
//
//String userToJson(List<User> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//


import 'dart:core';
import 'package:flutter/foundation.dart';


class UserModel {
  UserModel({
  @required  this.uid,
    this.name,
    this.phone,
    this.bloodType,
    this.userLocation,
    this.available,
    this.area
  });

  String uid;
  String name;
  String phone;
  String bloodType;
  String area;
  bool available;
  UserLocation userLocation;
  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    if (json == null) {
      return null;
    }
    final String name = json['name'];
    if (name == null) {
      return null;
    }
   return UserModel(
       uid: documentId,
       name: name,
       phone: json["phone"],
       area: json["area"],
       available: json["available"],
       bloodType: json["bloodType"],
       userLocation: UserLocation.fromJson(json["userLocation"])
   );
  }

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "phone": phone,
    "area": area,
    "available": available,
    "bloodType":bloodType,
    "userLocation":userLocation.toJson()
  };
}

class UserLocation{
  UserLocation({
    this.latitude,
    this.longitude,
  });

  double latitude;
  double longitude;

  factory UserLocation.fromJson(Map<String, dynamic> json) => UserLocation(
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
  };
}

class UserSuggestion{
  UserSuggestion({
    this.suggestion,
  });

  String suggestion;

  factory UserSuggestion.fromJson(Map<String, dynamic> json) => UserSuggestion(
    suggestion: json["suggestion"],
  );

  Map<String, dynamic> toJson() => {
    "suggestion": suggestion,
  };
}


class UserLocationRange{
  UserLocationRange({
    this.lowerUserLocation,
    this.upperUserLocation,
  });

  UserLocation lowerUserLocation;
  UserLocation upperUserLocation;

  factory UserLocationRange.fromJson(Map<String, dynamic> json) => UserLocationRange(
    lowerUserLocation:UserLocation.fromJson(json["lowerUserLocation"]),
    upperUserLocation:UserLocation.fromJson(json["upperUserLocation"])
  );

  Map<String, dynamic> toJson() => {
    "lowerUserLocation":lowerUserLocation.toJson(),
    "upperUserLocation":upperUserLocation.toJson()
  };
}


//class BloodType {
//  BloodType({
//    this.letter,
//    this.sign,
//  });
//
//  String letter;
//  String sign;
//
//  factory BloodType.fromJson(Map<String, dynamic> json) => BloodType(
//    letter: json["letter"],
//    sign: json["sign"],
//  );
//
//  Map<String, dynamic> toJson() => {
//    "letter": letter,
//    "sign": sign,
//  };
//}

