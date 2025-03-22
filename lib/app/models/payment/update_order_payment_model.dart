import 'dart:convert';

UpdateOrderPaymentModel updateOrderPaymentModelFromJson(String str) =>
    UpdateOrderPaymentModel.fromJson(json.decode(str));

String updateOrderPaymentModelToJson(UpdateOrderPaymentModel data) =>
    json.encode(data.toJson());

class UpdateOrderPaymentModel {
  final String paymentId;

  UpdateOrderPaymentModel({
    required this.paymentId,
  });

  factory UpdateOrderPaymentModel.fromJson(Map<String, dynamic> json) =>
      UpdateOrderPaymentModel(
        paymentId: json["paymentId"],
      );

  Map<String, dynamic> toJson() => {
        "paymentId": paymentId,
      };
}
