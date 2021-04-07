
import 'dart:convert';

List<Welcome> welcomeFromJson(String str) => List<Welcome>.from(json.decode(str).map((x) => Welcome.fromJson(x)));
//List<Welcome> welcomes =welcomeFromJson(x);
//welcomes.forEach((element) { return ......;});

String welcomeToJson(List<Welcome> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Welcome {
  Welcome({
    this.id,
    this.featured,
    this.title,
    this.url,
    this.imageUrl,
    this.newsSite,
    this.summary,
    this.publishedAt,
    this.launches,
    this.events,
  });

  String id;
  bool featured;
  String title;
  String url;
  String imageUrl;
  String newsSite;
  String summary;
  DateTime publishedAt;
  List<Event> launches;
  List<Event> events;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    id: json["id"],
    featured: json["featured"],
    title: json["title"],
    url: json["url"],
    imageUrl: json["imageUrl"],
    newsSite: json["newsSite"],
    summary: json["summary"],
    publishedAt:json["publishedAt"]!=null? DateTime.parse(json["publishedAt"]):null,
    launches: List<Event>.from(json["launches"].map((x) => Event.fromJson(x))),
    events: List<Event>.from(json["events"].map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "featured": featured,
    "title": title,
    "url": url,
    "imageUrl": imageUrl,
    "newsSite": newsSite,
    "summary": summary,
    "publishedAt": publishedAt.toIso8601String(),
    "launches": List<dynamic>.from(launches.map((x) => x.toJson())),
    "events": List<dynamic>.from(events.map((x) => x.toJson())),
  };
}

class Event {
  Event({
    this.id,
    this.provider,
  });

  String id;
  String provider;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json["id"],
    provider: json["provider"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "provider": provider,
  };
}
