import 'dart:convert';

OtpResponseModel otpResponseModelFromJson(String str) =>
    OtpResponseModel.fromJson(json.decode(str));

String otpResponseModelToJson(OtpResponseModel data) =>
    json.encode(data.toJson());

class OtpResponseModel {
  final bool? success;
  final String? message;
  final String? otp;

  OtpResponseModel({
    this.success,
    this.message,
    this.otp,
  });

  OtpResponseModel copyWith({
    bool? success,
    String? message,
    String? otp,
  }) =>
      OtpResponseModel(
        success: success ?? this.success,
        message: message ?? this.message,
        otp: otp ?? this.otp,
      );

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) =>
      OtpResponseModel(
        success: json["success"],
        message: json["message"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "otp": otp,
      };
}
