import 'dart:async';
import 'package:map_app/models/user_model.dart';
import 'package:map_app/services/api_path.dart';
import 'package:map_app/services/auth.dart';
import 'firestore_service.dart';
abstract class DatabaseFirebase {
  Future<void> setUser({UserModel user,UserFromFirebase userFromFirebase});
  Future<void> deleteUser({UserFromFirebase userFromFirebase});
  Stream<List<UserModel>> usersStream({String bloodType});
  Stream<UserModel> userStream(UserFromFirebase userFromFirebase);

  Future<void> setSuggestion({UserSuggestion userSuggestion,UserFromFirebase userFromFirebase});

}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();
// TODO remember setData and userStream ......
class FirestoreDatabase implements DatabaseFirebase {
//  FirestoreDatabase({ this.uid}) : assert(uid != null);
//  FirestoreDatabase({ this.uid}) ;
//
//  final String uid;
  final _service = FirestoreService.instance;
  @override
  Future<void> setSuggestion({UserSuggestion userSuggestion,UserFromFirebase userFromFirebase})async=> await _service.setData(
    //TODO change path to uid userFromFirebase
    path: APIPath.suggestion(userFromFirebase.uid),
    data: userSuggestion.toJson(),
  );


  @override
  Future<void> setUser({UserModel user,UserFromFirebase userFromFirebase}) async => await _service.setData(
    //TODO change path to uid userFromFirebase
        path: APIPath.user(userFromFirebase.uid),
        data: user.toJson(),
      );

  @override
  Future<void> deleteUser({UserFromFirebase userFromFirebase}) async {
    await _service.deleteData(path: APIPath.user(userFromFirebase.uid));
  }

  @override
  Stream<UserModel> userStream(UserFromFirebase userFromFirebase) => _service.documentStream(
        path: APIPath.user(userFromFirebase.uid),
        builder: (data, documentId) => UserModel.fromJson(data,documentId),
      );

  @override
  Stream<List<UserModel>> usersStream({String bloodType}) =>
      _service.collectionStream(
        path: APIPath.users(),
        queryBuilder:bloodType == null?
            (query) => query.where('available',isEqualTo: true)
        :(query) => query.where('bloodType', isEqualTo: bloodType).where('available',isEqualTo: true),

//        queryBuilder: bloodType != null ||userAvailable!=null
//            ? bloodType != null && userAvailable!=null?
//            (query) => query.where('bloodType', isEqualTo: bloodType).where('available',isEqualTo: userAvailable)
//              :bloodType != null?(query) => query.where('bloodType', isEqualTo: bloodType):
//            (query) => query.where('available',isEqualTo: userAvailable)
//            : null,
        builder: (data, documentId) => UserModel.fromJson(data,documentId),
//        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

}
