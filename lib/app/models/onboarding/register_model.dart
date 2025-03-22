import 'dart:convert';

RegisterNewUserModel registerNewUserModelFromJson(String str) =>
    RegisterNewUserModel.fromJson(json.decode(str));

String registerNewUserModelToJson(RegisterNewUserModel data) =>
    json.encode(data.toJson());

class RegisterNewUserModel {
  String? fullName;
  String? phone;
  String? address;
  String? email;
  String? password;
  String? plan;
  String? role;

  RegisterNewUserModel({
    this.fullName,
    this.phone,
    this.address,
    this.email,
    this.password,
    this.plan,
    this.role,
  });

  RegisterNewUserModel copyWith({
    String? fullName,
    String? phone,
    String? address,
    String? email,
    String? password,
    String? plan,
    String? role,
  }) =>
      RegisterNewUserModel(
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        email: email ?? this.email,
        password: password ?? this.password,
        plan: plan ?? this.plan,
        role: role ?? this.role,
      );

  factory RegisterNewUserModel.fromJson(Map<String, dynamic> json) =>
      RegisterNewUserModel(
        fullName: json["fullName"],
        phone: json["phone"],
        address: json["address"],
        email: json["email"],
        password: json["password"],
        plan: json["plan"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "phone": phone,
        "address": address,
        "email": email,
        "password": password,
        "plan": plan,
        "role": role,
      };
}

RegisterNewUserNoPlanModel registerNewUserNoPlanModelFromJson(String str) =>
    RegisterNewUserNoPlanModel.fromJson(json.decode(str));

String registerNewUserNoPlanModelToJson(RegisterNewUserNoPlanModel data) =>
    json.encode(data.toJson());

class RegisterNewUserNoPlanModel {
  String? fullName;
  String? phone;
  String? address;
  String? email;
  String? password;
  String? role;

  RegisterNewUserNoPlanModel({
    this.fullName,
    this.phone,
    this.address,
    this.email,
    this.password,
    this.role,
  });

  RegisterNewUserNoPlanModel copyWith({
    String? fullName,
    String? phone,
    String? address,
    String? email,
    String? password,
    String? role,
  }) =>
      RegisterNewUserNoPlanModel(
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        address: address ?? this.address,
        email: email ?? this.email,
        password: password ?? this.password,
        role: role ?? this.role,
      );

  factory RegisterNewUserNoPlanModel.fromJson(Map<String, dynamic> json) =>
      RegisterNewUserNoPlanModel(
        fullName: json["fullName"],
        phone: json["phone"],
        address: json["address"],
        email: json["email"],
        password: json["password"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "phone": phone,
        "address": address,
        "email": email,
        "password": password,
        "role": role,
      };
}
