import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

part 'annot_user_model.g.dart';

AnnotatedUserModel annotatedUserModelFromJson(String str) =>
    AnnotatedUserModel.fromJson(json.decode(str));

String annotatedUserModelToJson(AnnotatedUserModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 0)
class AnnotatedUserModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? fullName;
  @HiveField(2)
  String? phone;
  @HiveField(3)
  String? address;
  @HiveField(4)
  String? email;
  @HiveField(5)
  String? role;
  @HiveField(6)
  DateTime? createdAt;
  @HiveField(7)
  DateTime? updatedAt;
  @HiveField(8)
  int? v;
  @HiveField(9)
  AnnotatedPlan? plan;
  @HiveField(10)
  String? userModelId;
  @HiveField(11)
  String? token;

  AnnotatedUserModel({
    this.id,
    this.fullName,
    this.phone,
    this.address,
    this.email,
    this.role,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.plan,
    this.userModelId,
    this.token,
  });

  AnnotatedUserModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? address,
    String? email,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    AnnotatedPlan? plan,
    String? userModelId,
    String? token,
  }) =>
      AnnotatedUserModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        email: email ?? this.email,
        role: role ?? this.role,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        plan: plan ?? this.plan,
        userModelId: userModelId ?? this.userModelId,
        token: token ?? this.token,
      );

  factory AnnotatedUserModel.fromJson(Map<String, dynamic> json) =>
      AnnotatedUserModel(
        id: json["_id"],
        fullName: json["fullName"],
        phone: json["phone"],
        address: json["address"],
        email: json["email"],
        role: json["role"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        plan:
            json["plan"] == null ? null : AnnotatedPlan.fromJson(json["plan"]),
        userModelId: json["id"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "phone": phone,
        "address": address,
        "email": email,
        "role": role,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "plan": plan?.toJson(),
        "id": userModelId,
        "token": token,
      };
}

@HiveType(typeId: 1)
class AnnotatedPlan {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? plan;
  @HiveField(2)
  double? discount;
  @HiveField(3)
  List<String>? description;
  @HiveField(4)
  int? v;
  @HiveField(5)
  String? planId;

  AnnotatedPlan({
    this.id,
    this.plan,
    this.discount,
    this.description,
    this.v,
    this.planId,
  });

  AnnotatedPlan copyWith({
    String? id,
    String? plan,
    double? discount,
    List<String>? description,
    int? v,
    String? planId,
  }) =>
      AnnotatedPlan(
        id: id ?? this.id,
        plan: plan ?? this.plan,
        discount: discount ?? this.discount,
        description: description ?? this.description,
        v: v ?? this.v,
        planId: planId ?? this.planId,
      );

  factory AnnotatedPlan.fromJson(Map<String, dynamic> json) => AnnotatedPlan(
        id: json["_id"],
        plan: json["plan"],
        discount: json["discount"]?.toDouble(),
        description: json["description"] == null
            ? []
            : List<String>.from(json["description"]!.map((x) => x)),
        v: json["__v"],
        planId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "plan": plan,
        "discount": discount,
        "description": description == null
            ? []
            : List<dynamic>.from(description!.map((x) => x)),
        "__v": v,
        "id": planId,
      };
}
