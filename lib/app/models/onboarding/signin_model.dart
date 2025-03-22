import 'dart:convert';

SigninModel signinModelFromJson(String str) =>
    SigninModel.fromJson(json.decode(str));

String signinModelToJson(SigninModel data) => json.encode(data.toJson());

class SigninModel {
  final String? email;
  final String? password;

  SigninModel({
    this.email,
    this.password,
  });

  SigninModel copyWith({
    String? email,
    String? password,
  }) =>
      SigninModel(
        email: email ?? this.email,
        password: password ?? this.password,
      );

  factory SigninModel.fromJson(Map<String, dynamic> json) => SigninModel(
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
      };
}

SignInResponseModel signInResponseModelFromJson(String str) =>
    SignInResponseModel.fromJson(json.decode(str));

String signInResponseModelToJson(SignInResponseModel data) =>
    json.encode(data.toJson());

class SignInResponseModel {
  String? id;
  String? fullName;
  String? email;
  String? address;
  String? phone;
  String? plan;
  String? role;
  String? signInResponseModelId;
  String? token;

  SignInResponseModel({
    this.id,
    this.fullName,
    this.email,
    this.address,
    this.phone,
    this.plan,
    this.role,
    this.signInResponseModelId,
    this.token,
  });

  SignInResponseModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? address,
    String? phone,
    String? plan,
    String? role,
    String? signInResponseModelId,
    String? token,
  }) =>
      SignInResponseModel(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        plan: plan ?? this.plan,
        role: role ?? this.role,
        signInResponseModelId:
            signInResponseModelId ?? this.signInResponseModelId,
        token: token ?? this.token,
      );

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) =>
      SignInResponseModel(
        id: json["_id"],
        fullName: json["fullName"],
        email: json["email"],
        address: json["address"],
        phone: json["phone"],
        plan: json["plan"],
        role: json["role"],
        signInResponseModelId: json["id"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "email": email,
        "address": address,
        "phone": phone,
        "plan": plan,
        "role": role,
        "id": signInResponseModelId,
        "token": token,
      };
}
