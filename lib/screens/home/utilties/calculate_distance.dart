import 'dart:math';

import 'package:map_app/models/user_model.dart';
class MYDistance{
  double calculateDistance (double lat1,double lng1,double lat2,double lng2){
    double radEarth =6.3781*( pow(10.0,6.0));
    double phi1= lat1*(pi/180);
    double phi2 = lat2*(pi/180);

    double delta1=(lat2-lat1)*(pi/180);
    double delta2=(lng2-lng1)*(pi/180);

    double cal1 = sin(delta1/2)*sin(delta1/2)+(cos(phi1)*cos(phi2)*sin(delta2/2)*sin(delta2/2));

    double cal2= 2 * atan2((sqrt(cal1)), (sqrt(1-cal1)));
    double distance =radEarth*cal2;
    distance = double.parse((distance).toStringAsFixed(1));
    return (distance);

  }

  UserLocationRange filterByDistance(double currentLatitude,double currentLongitude,double distance){
    const lat = 0.0144927536231884; // degrees latitude per mile
    const lon = 0.0181818181818182; // degrees longitude per mile
    double lowerLat = currentLatitude - lat * distance;
    double lowerLon = currentLongitude - lon * distance;

    double upperLat = currentLatitude + lat * distance;
    double upperLon = currentLongitude + lon * distance;
    UserLocation lowerUserLocation=UserLocation(latitude:lowerLat ,longitude: lowerLon);
    UserLocation upperUserLocation=UserLocation(latitude:upperLat ,longitude: upperLon);
UserLocationRange userLocationRange=UserLocationRange(lowerUserLocation: lowerUserLocation,upperUserLocation: upperUserLocation);

    return userLocationRange;
  }



}

