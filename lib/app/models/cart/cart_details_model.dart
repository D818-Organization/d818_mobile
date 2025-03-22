import 'dart:convert';

import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';

CartDetailsModel cartDetailsModelFromJson(String str) =>
    CartDetailsModel.fromJson(json.decode(str));

String cartDetailsModelToJson(CartDetailsModel data) =>
    json.encode(data.toJson());

class CartDetailsModel {
  String? id;
  Customer? customer;
  List<CartProduct>? products;
  int? bill;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  CartDetailsModel({
    this.id,
    this.customer,
    this.products,
    this.bill,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  CartDetailsModel copyWith({
    String? id,
    Customer? customer,
    List<CartProduct>? products,
    int? bill,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      CartDetailsModel(
        id: id ?? this.id,
        customer: customer ?? this.customer,
        products: products ?? this.products,
        bill: bill ?? this.bill,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory CartDetailsModel.fromJson(Map<String, dynamic> json) =>
      CartDetailsModel(
        id: json["_id"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        products: json["products"] == null
            ? []
            : List<CartProduct>.from(
                json["products"]!.map((x) => CartProduct.fromJson(x))),
        bill: json["bill"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "customer": customer?.toJson(),
        "products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "bill": bill,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class Customer {
  String? id;
  String? fullName;
  String? customerId;

  Customer({
    this.id,
    this.fullName,
    this.customerId,
  });

  Customer copyWith({
    String? id,
    String? fullName,
    String? customerId,
  }) =>
      Customer(
        id: id ?? this.id,
        fullName: fullName ?? this.fullName,
        customerId: customerId ?? this.customerId,
      );

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["_id"],
        fullName: json["fullName"],
        customerId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "id": customerId,
      };
}

class CartProduct {
  EachMealModel? productData;
  int? quantity;
  int? price;
  String? id;

  CartProduct({
    this.productData,
    this.quantity,
    this.price,
    this.id,
  });

  CartProduct copyWith({
    EachMealModel? productData,
    int? quantity,
    int? price,
    String? id,
  }) =>
      CartProduct(
        productData: productData ?? this.productData,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        id: id ?? this.id,
      );

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        productData: json["productId"] == null
            ? null
            : EachMealModel.fromJson(json["productId"]),
        quantity: json["quantity"],
        price: json["price"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productData?.toJson(),
        "quantity": quantity,
        "price": price,
        "_id": id,
      };
}

class Category {
  String? id;
  String? name;
  int? v;

  Category({
    this.id,
    this.name,
    this.v,
  });

  Category copyWith({
    String? id,
    String? name,
    int? v,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        v: v ?? this.v,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "__v": v,
      };
}
