import 'dart:convert';

CustomerReviewModel customerReviewModelFromJson(String str) =>
    CustomerReviewModel.fromJson(json.decode(str));

String customerReviewModelToJson(CustomerReviewModel data) =>
    json.encode(data.toJson());

class CustomerReviewModel {
  final String? id;
  final Customer? customer;
  final Product? product;
  final int? rating;
  final String? comment;
  final bool? isPublished;
  final DateTime? dateCreated;
  final int? v;

  CustomerReviewModel({
    this.id,
    this.customer,
    this.product,
    this.rating,
    this.comment,
    this.isPublished,
    this.dateCreated,
    this.v,
  });

  CustomerReviewModel copyWith({
    String? id,
    Customer? customer,
    Product? product,
    int? rating,
    String? comment,
    bool? isPublished,
    DateTime? dateCreated,
    int? v,
  }) =>
      CustomerReviewModel(
        id: id ?? this.id,
        customer: customer ?? this.customer,
        product: product ?? this.product,
        rating: rating ?? this.rating,
        comment: comment ?? this.comment,
        isPublished: isPublished ?? this.isPublished,
        dateCreated: dateCreated ?? this.dateCreated,
        v: v ?? this.v,
      );

  factory CustomerReviewModel.fromJson(Map<String, dynamic> json) =>
      CustomerReviewModel(
        id: json["_id"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        rating: json["rating"],
        comment: json["comment"],
        isPublished: json["isPublished"],
        dateCreated: json["dateCreated"] == null
            ? null
            : DateTime.parse(json["dateCreated"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "customer": customer?.toJson(),
        "product": product?.toJson(),
        "rating": rating,
        "comment": comment,
        "isPublished": isPublished,
        "dateCreated": dateCreated?.toIso8601String(),
        "__v": v,
      };
}

class Customer {
  final String? id;
  final String? fullName;
  final String? customerId;

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

class Product {
  final String? id;
  final String? name;
  final String? description;
  final String? image;
  final int? price;
  final String? category;
  final DateTime? dateCreated;
  final int? v;

  Product({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.category,
    this.dateCreated,
    this.v,
  });

  Product copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    int? price,
    String? category,
    DateTime? dateCreated,
    int? v,
  }) =>
      Product(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        price: price ?? this.price,
        category: category ?? this.category,
        dateCreated: dateCreated ?? this.dateCreated,
        v: v ?? this.v,
      );

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        price: json["price"],
        category: json["category"],
        dateCreated: json["dateCreated"] == null
            ? null
            : DateTime.parse(json["dateCreated"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "image": image,
        "price": price,
        "category": category,
        "dateCreated": dateCreated?.toIso8601String(),
        "__v": v,
      };
}
