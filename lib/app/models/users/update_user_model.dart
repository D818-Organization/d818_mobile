import 'dart:convert';

UpdateAccountModel updateAccountModelFromJson(String str) =>
    UpdateAccountModel.fromJson(json.decode(str));

String updateAccountModelToJson(UpdateAccountModel data) =>
    json.encode(data.toJson());

class UpdateAccountModel {
  final String? fullName;
  final String? phone;
  final String? gender;
  final String? email;
  final String? dob;
  final String? address;

  UpdateAccountModel({
    this.fullName,
    this.phone,
    this.gender,
    this.email,
    this.dob,
    this.address,
  });

  UpdateAccountModel copyWith({
    String? fullName,
    String? phone,
    String? gender,
    String? email,
    String? dob,
    String? address,
  }) =>
      UpdateAccountModel(
        fullName: fullName ?? this.fullName,
        phone: phone ?? this.phone,
        gender: gender ?? this.gender,
        email: email ?? this.email,
        dob: dob ?? this.dob,
        address: address ?? this.address,
      );

  factory UpdateAccountModel.fromJson(Map<String, dynamic> json) =>
      UpdateAccountModel(
        fullName: json["fullName"],
        phone: json["phone"],
        gender: json["gender"],
        email: json["email"],
        dob: json["dob"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
        "phone": phone,
        "gender": gender,
        "email": email,
        "dob": dob,
        "address": address,
      };
}

UploadProfilePictureModel uploadProfilePictureModelFromJson(String str) =>
    UploadProfilePictureModel.fromJson(json.decode(str));

String uploadProfilePictureModelToJson(UploadProfilePictureModel data) =>
    json.encode(data.toJson());

class UploadProfilePictureModel {
  final String? img;

  UploadProfilePictureModel({
    this.img,
  });

  UploadProfilePictureModel copyWith({
    String? img,
  }) =>
      UploadProfilePictureModel(
        img: img ?? this.img,
      );

  factory UploadProfilePictureModel.fromJson(Map<String, dynamic> json) =>
      UploadProfilePictureModel(
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "img": img,
      };
}
