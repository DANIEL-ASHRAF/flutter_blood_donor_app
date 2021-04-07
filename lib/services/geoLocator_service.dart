import 'dart:async';
import 'package:geolocator/geolocator.dart';
class GeoLocatorService{
  Future<Position> getLocation()async{
    //TODO try and catch
    return await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
