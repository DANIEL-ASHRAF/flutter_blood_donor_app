import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:map_app/models/user_model_with_distance.dart';
import 'package:map_app/screens/home/utilties/calculate_distance.dart';
import 'package:provider/provider.dart';
import 'empty_content.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;


  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return  _buildList(items) ;
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return ListView.builder(
      padding: EdgeInsets.only(left: 10,right: 10,top: 0,  bottom: 15),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
    );
  }
}

class ListItemsBuilderWithDistance<T> extends StatelessWidget with MYDistance {
  const ListItemsBuilderWithDistance({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder, this.distanceFilter:1000,
  }) : super(key: key);
  final List<T> snapshot;
  final ItemWidgetBuilder itemBuilder;
final double distanceFilter;
  @override
  Widget build(BuildContext context) {
    final currentPosition = Provider.of<Position>(context);

    return _buildList(snapshot,currentPosition);

  }


  Widget _buildList(List items,currentPosition) {
    UserModelWithDistance userModelWithDistance;
    List distanceList=[];
    items.forEach((element) {
      double lat=element.userLocation.latitude;
      double lng=element.userLocation.longitude;
      double distance = calculateDistance(currentPosition.latitude,currentPosition.longitude, lat,lng);
       distance=double.parse((distance).toStringAsFixed(1));
      if(distance<=distanceFilter){
        userModelWithDistance=UserModelWithDistance(userModel: element,distance: distance);
        distanceList.add(userModelWithDistance);
      }
    });
distanceList.sort((a,b)=>a.distance.compareTo(b.distance));

    return ListView.builder(
      padding: EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 15),
      itemCount: distanceList ==null?0: distanceList.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, distanceList[index]);
      },
    );
  }
}

class GridItemsBuilder<T> extends StatelessWidget {
  const GridItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
//    this.childAspectRatio:0.8,
    this.crossAxisCount:2,
    this.crossAxisSpacing:2,
    this.mainAxisSpacing:2,
    this.padding:const EdgeInsets.all(5.0),
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
//  final double childAspectRatio;
  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return  _buildList(items) ;
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return GridView.builder(
      padding:padding ,
      itemCount: items.length ,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: mainAxisSpacing,
//        childAspectRatio: childAspectRatio,
        crossAxisCount: crossAxisCount

      ) ,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
    );
  }
}

//class MapItemsBuilder<T> extends StatelessWidget {
//  const MapItemsBuilder({
//    Key key,
//    @required this.snapshot,
//    @required this.itemBuilder,
//    @required this.currentUid,
//  }) : super(key: key);
//  final AsyncSnapshot<List<T>> snapshot;
//  final ItemWidgetBuilder<T> itemBuilder;
//  final String currentUid;
//
//
//  @override
//  Widget build(BuildContext context) {
//    print(snapshot);
//    if (snapshot.hasData) {
//      final List<T> items = snapshot.data;
//      if (items.isNotEmpty) {
//        return _addMarkerToList(items, currentUid);
//
//      } else {
//        return EmptyContent();
//      }
//    } else if (snapshot.hasError) {
//      return EmptyContent(
//        title: 'Something went wrong',
//        message: 'Can\'t load items right now',
//      );
//    }
//    return Center(child: CircularProgressIndicator());
//  }
//
//  _addMarkerToList(items,newMarkers,currentUid)async{
//    var bitmapData;
//    await Future.forEach(items, (element) async {
//      element.uid == currentUid??"" ? bitmapData = await _createAvatar(
//          110, 110, element.bloodType,color: darkYellow):
//      bitmapData = await _createAvatar(
//          110, 110, element.bloodType) ;
//      var bitmapDescriptor = BitmapDescriptor.fromBytes(bitmapData);
//      var marker = Marker(
//          onTap: () =>
//              _showBottom(element.name, element.phone,
//                  element.bloodType),
//          markerId: MarkerId(element.uid),
//          position: LatLng(
//            element.userLocation.latitude, element.userLocation.longitude,),
//          icon: bitmapDescriptor
//      );
//      newMarkers.add(marker);
//    });
//   return newMarkers;
//  }
//
//  Future<Uint8List> _createAvatar(int width, int height, String name,
//      {Color color : Colors.red}) async {
//    final PictureRecorder pictureRecorder = PictureRecorder();
//    final Canvas canvas = Canvas(pictureRecorder);
//    final Paint paint = Paint()
//      ..color = color;
//
//    final double radius = width / 2;
//    canvas.drawOval(
//      Rect.fromCircle(
//          center: Offset(radius, radius), radius: radius),
//      paint,
//    );
//
//    final TextPainter painter = TextPainter(textDirection: TextDirection.ltr,);
//    painter.text = TextSpan(
//      text: name,
//      style: TextStyle(
//        fontSize: radius - 5,
//        fontWeight: FontWeight.bold,
//        color: Colors.white,
//      ),
//    );
//    painter.layout();
//    painter.paint(canvas, Offset((width * .5) - painter.width * .5,
//        (height * .5) - painter.height * .5));
//
//    final image = await pictureRecorder.endRecording().toImage(width, height);
//
//    final data = await image.toByteData(format: ImageByteFormat.png);
//
//    return data.buffer.asUint8List();
//  }
//
//
//
//  Widget _buildList(List<T> items) {
//    return ListView.builder(
//      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
//      itemCount: items.length,
//      itemBuilder: (context, index) {
////        if(index==items.length){
////          return Container(height: 30,);
////        }
//        return itemBuilder(context, items[index]);
//      },
//    );
//  }
//}

