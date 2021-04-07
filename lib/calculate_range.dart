//const getGeohashRange = (
//    latitude: number,
//    longitude: number,
//    distance: number, // miles
//) => {
//const double lat = 0.0144927536231884; // degrees latitude per mile
//const lon = 0.0181818181818182; // degrees longitude per mile
//
//const lowerLat = latitude - lat * distance;
//const lowerLon = longitude - lon * distance;
//
//const upperLat = latitude + lat * distance;
//const upperLon = longitude + lon * distance;
//
//const lower = geohash.encode(lowerLat, lowerLon);
//const upper = geohash.encode(greaterLat, greaterLon);
//
//return {
//lower,
//upper
//};
//};
//class GetRange{
//  GetRange({this.latitude, this.longitude, this.distance}); // degrees longitude per mile
//
//  final double latitude;
// final double longitude;
// final double distance;
//
//   double lat = 0.0144927536231884; // degrees latitude per mile
//   double lon = 0.0181818181818182;
//
//
////  double lower = geohash.encode(lowerLat, lowerLon);
////  double upper = geohash.encode(greaterLat, greaterLon);
//
//
//
//  double lowerLat = latitude - lat * distance;
//  double lowerLon = longitude - lon * distance;
//  double upperLat = latitude + lat * distance;
//  double upperLon = longitude + lon * distance;
//
//
//}