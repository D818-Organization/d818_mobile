import 'dart:convert';

EmailTakenModel emailTakenModelFromJson(String str) =>
    EmailTakenModel.fromJson(json.decode(str));

String emailTakenModelToJson(EmailTakenModel data) =>
    json.encode(data.toJson());

class EmailTakenModel {
  final List<String>? email;

  EmailTakenModel({
    this.email,
  });

  factory EmailTakenModel.fromJson(Map<String, dynamic> json) =>
      EmailTakenModel(
        email: json["email"] == null
            ? []
            : List<String>.from(json["email"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "email": email == null ? [] : List<dynamic>.from(email!.map((x) => x)),
      };
}
