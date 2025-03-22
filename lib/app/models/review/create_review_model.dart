import 'dart:convert';

CreateReviewModel createReviewModelFromJson(String str) =>
    CreateReviewModel.fromJson(json.decode(str));

String createReviewModelToJson(CreateReviewModel data) =>
    json.encode(data.toJson());

class CreateReviewModel {
  final String? product;
  final int? rating;
  final String? comment;

  CreateReviewModel({
    this.product,
    this.rating,
    this.comment,
  });

  CreateReviewModel copyWith({
    String? product,
    int? rating,
    String? comment,
  }) =>
      CreateReviewModel(
        product: product ?? this.product,
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
      );

  factory CreateReviewModel.fromJson(Map<String, dynamic> json) =>
      CreateReviewModel(
        product: json["product"],
        rating: json["rating"],
        comment: json["comment"],
      );

  Map<String, dynamic> toJson() => {
        "product": product,
        "rating": rating,
        "comment": comment,
      };
}
