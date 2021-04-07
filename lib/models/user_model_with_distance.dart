import 'package:map_app/models/user_model.dart';

class UserModelWithDistance{
  UserModelWithDistance({this.userModel,this.distance});
  UserModel userModel;
  double distance;

  factory UserModelWithDistance.fromJson(Map<String, dynamic> json , String documentId) {
    if (json == null) {
      return null;
    }
    return UserModelWithDistance(
        distance: json["distance"],
        userModel:UserModel.fromJson(json["userModel"],documentId)
    );
  }

  Map<String, dynamic> toJson() => {
    "distance":distance,
    "userModel":userModel.toJson()
  };

}
