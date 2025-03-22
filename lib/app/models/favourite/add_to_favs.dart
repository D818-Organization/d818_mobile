import 'dart:convert';

AddToFavouriteModel addToFavouriteModelFromJson(String str) =>
    AddToFavouriteModel.fromJson(json.decode(str));

String addToFavouriteModelToJson(AddToFavouriteModel data) =>
    json.encode(data.toJson());

class AddToFavouriteModel {
  final String? productId;

  AddToFavouriteModel({
    this.productId,
  });

  AddToFavouriteModel copyWith({
    String? productId,
  }) =>
      AddToFavouriteModel(
        productId: productId ?? this.productId,
      );

  factory AddToFavouriteModel.fromJson(Map<String, dynamic> json) =>
      AddToFavouriteModel(
        productId: json["productId"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
      };
}
