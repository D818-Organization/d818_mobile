import 'dart:convert';

UploadProfilePictureModel uploadProfilePictureModelFromJson(String str) =>
    UploadProfilePictureModel.fromJson(json.decode(str));

String uploadProfilePictureModelToJson(UploadProfilePictureModel data) =>
    json.encode(data.toJson());

class UploadProfilePictureModel {
  final String? profileImage;

  UploadProfilePictureModel({
    required this.profileImage,
  });

  UploadProfilePictureModel copyWith({
    String? profileImage,
  }) =>
      UploadProfilePictureModel(
        profileImage: profileImage ?? this.profileImage,
      );

  factory UploadProfilePictureModel.fromJson(Map<String, dynamic> json) =>
      UploadProfilePictureModel(
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "profile_image": profileImage,
      };
}
