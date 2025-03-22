import 'dart:convert';

MatchDataModel matchDataModelFromJson(String str) =>
    MatchDataModel.fromJson(json.decode(str));

String matchDataModelToJson(MatchDataModel data) => json.encode(data.toJson());

class MatchDataModel {
  String? name;
  String? imageUrl;
  String? age;
  String? location;
  String? distance;
  String? religion;

  MatchDataModel({
    this.name,
    this.imageUrl,
    this.age,
    this.location,
    this.distance,
    this.religion,
  });

  MatchDataModel copyWith({
    String? name,
    String? imageUrl,
    String? age,
    String? location,
    String? distance,
    String? religion,
  }) =>
      MatchDataModel(
        name: name ?? this.name,
        imageUrl: imageUrl ?? this.imageUrl,
        age: age ?? this.age,
        location: location ?? this.location,
        distance: distance ?? this.distance,
        religion: religion ?? this.religion,
      );

  factory MatchDataModel.fromJson(Map<String, dynamic> json) => MatchDataModel(
        name: json["name"],
        imageUrl: json["imageUrl"],
        age: json["age"],
        location: json["location"],
        distance: json["distance"],
        religion: json["religion"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "imageUrl": imageUrl,
        "age": age,
        "location": location,
        "distance": distance,
        "religion": religion,
      };
}
