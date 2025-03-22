import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? fullName;
  String? phone;
  String? address;
  String? email;
  String? role;
  String? img;
  String? gender;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  Plan? plan;
  String? userModelId;
  String? token;
  DateTime? dob;

  UserModel({
    this.id,
    this.fullName,
    this.phone,
    this.address,
    this.email,
    this.role,
    this.img,
    this.gender,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.plan,
    this.userModelId,
    this.token,
    this.dob,
  });

  UserModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? address,
    String? email,
    String? role,
    String? img,
    String? gender,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
    Plan? plan,
    String? userModelId,
    String? token,
    DateTime? dob,
  }) =>
      UserModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        email: email ?? this.email,
        role: role ?? this.role,
        img: img ?? this.img,
        gender: gender ?? this.gender,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
        plan: plan ?? this.plan,
        userModelId: userModelId ?? this.userModelId,
        token: token ?? this.token,
        dob: dob ?? this.dob,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        fullName: json["fullName"],
        phone: json["phone"],
        address: json["address"],
        gender: json["gender"],
        email: json["email"],
        role: json["role"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        img: json["img"],
        v: json["__v"],
        plan: json["plan"] == null
            ? null
            : json["plan"] is String
                ? Plan(id: json["plan"])
                : Plan.fromJson(json["plan"]),
        userModelId: json["id"],
        token: json["token"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "phone": phone,
        "address": address,
        "email": email,
        "role": role,
        "img": img,
        "gender": gender,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "plan": plan?.toJson(),
        "id": userModelId,
        "token": token,
        "dob": dob?.toIso8601String(),
      };
}

class Plan {
  String? id;
  String? plan;
  double? discount;
  List<String>? description;
  int? v;
  String? planId;

  Plan({
    this.id,
    this.plan,
    this.discount,
    this.description,
    this.v,
    this.planId,
  });

  Plan copyWith({
    String? id,
    String? plan,
    double? discount,
    List<String>? description,
    int? v,
    String? planId,
  }) =>
      Plan(
        id: id ?? this.id,
        plan: plan ?? this.plan,
        discount: discount ?? this.discount,
        description: description ?? this.description,
        v: v ?? this.v,
        planId: planId ?? this.planId,
      );

  factory Plan.fromJson(Map<String, dynamic> json) => Plan(
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
