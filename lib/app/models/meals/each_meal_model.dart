import 'dart:convert';

EachMealModel eachMealModelFromJson(String str) =>
    EachMealModel.fromJson(json.decode(str));

String eachMealModelToJson(EachMealModel data) => json.encode(data.toJson());

class EachMealModel {
  String? id;
  String? name;
  String? description;
  String? image;
  int? price;
  Category? category;
  DateTime? dateCreated;
  int? v;

  EachMealModel({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.category,
    this.dateCreated,
    this.v,
  });

  EachMealModel copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    int? price,
    Category? category,
    DateTime? dateCreated,
    int? v,
  }) =>
      EachMealModel(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        price: price ?? this.price,
        category: category ?? this.category,
        dateCreated: dateCreated ?? this.dateCreated,
        v: v ?? this.v,
      );

  factory EachMealModel.fromJson(Map<String, dynamic> json) => EachMealModel(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        price: json["price"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        dateCreated: json["dateCreated"] == null
            ? null
            : DateTime.parse(json["dateCreated"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "image": image,
        "price": price,
        "category": category?.toJson(),
        "dateCreated": dateCreated?.toIso8601String(),
        "__v": v,
      };
}

class Category {
  String? id;
  String? name;
  int? v;

  Category({
    this.id,
    this.name,
    this.v,
  });

  Category copyWith({
    String? id,
    String? name,
    int? v,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        v: v ?? this.v,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "__v": v,
      };
}
