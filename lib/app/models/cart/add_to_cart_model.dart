import 'dart:convert';

AddToCartModel addToCartModelFromJson(String str) =>
    AddToCartModel.fromJson(json.decode(str));

String addToCartModelToJson(AddToCartModel data) => json.encode(data.toJson());

class AddToCartModel {
  final String? productId;
  final int? quantity;

  AddToCartModel({
    this.productId,
    this.quantity,
  });

  AddToCartModel copyWith({
    String? productId,
    int? quantity,
  }) =>
      AddToCartModel(
        productId: productId ?? this.productId,
        quantity: quantity ?? this.quantity,
      );

  factory AddToCartModel.fromJson(Map<String, dynamic> json) => AddToCartModel(
        productId: json["productId"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "quantity": quantity,
      };
}
