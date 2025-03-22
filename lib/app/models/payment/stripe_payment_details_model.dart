import 'dart:convert';

PayStripeModel payStripeModelFromJson(String str) =>
    PayStripeModel.fromJson(json.decode(str));

String payStripeModelToJson(PayStripeModel data) => json.encode(data.toJson());

class PayStripeModel {
  final String? amount;
  final String? currency;

  PayStripeModel({
    this.amount,
    this.currency,
  });

  factory PayStripeModel.fromJson(Map<String, dynamic> json) => PayStripeModel(
        amount: json["amount"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "currency": currency,
      };
}
