import 'dart:convert';

CampusModel campusModelFromJson(String str) =>
    CampusModel.fromJson(json.decode(str));

String campusModelToJson(CampusModel data) => json.encode(data.toJson());

class CampusModel {
  final String? id;
  final String? name;
  final String? description;
  final bool? isVisible;
  final int? v;

  CampusModel({
    this.id,
    this.name,
    this.description,
    this.isVisible,
    this.v,
  });

  CampusModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isVisible,
    int? v,
  }) =>
      CampusModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        isVisible: isVisible ?? this.isVisible,
        v: v ?? this.v,
      );

  factory CampusModel.fromJson(Map<String, dynamic> json) => CampusModel(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        isVisible: json["isVisible"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "isVisible": isVisible,
        "__v": v,
      };
}
