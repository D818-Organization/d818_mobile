import 'dart:convert';

SendFeedbackModel sendFeedbackModelFromJson(String str) =>
    SendFeedbackModel.fromJson(json.decode(str));

String sendFeedbackModelToJson(SendFeedbackModel data) =>
    json.encode(data.toJson());

class SendFeedbackModel {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? message;

  SendFeedbackModel({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.message,
  });

  SendFeedbackModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? message,
  }) =>
      SendFeedbackModel(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        message: message ?? this.message,
      );

  factory SendFeedbackModel.fromJson(Map<String, dynamic> json) =>
      SendFeedbackModel(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "message": message,
      };
}
