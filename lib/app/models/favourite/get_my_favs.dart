import 'dart:convert';

GetMyFavouriteModel getMyFavouriteModelFromJson(String str) =>
    GetMyFavouriteModel.fromJson(json.decode(str));

String getMyFavouriteModelToJson(GetMyFavouriteModel data) =>
    json.encode(data.toJson());

class GetMyFavouriteModel {
  final String? id;
  final Customer? customer;
  final List<FavProduct>? products;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  GetMyFavouriteModel({
    this.id,
    this.customer,
    this.products,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  GetMyFavouriteModel copyWith({
    String? id,
    Customer? customer,
    List<FavProduct>? products,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) =>
      GetMyFavouriteModel(
        id: id ?? this.id,
        customer: customer ?? this.customer,
        products: products ?? this.products,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        v: v ?? this.v,
      );

  factory GetMyFavouriteModel.fromJson(Map<String, dynamic> json) =>
      GetMyFavouriteModel(
        id: json["_id"],
        customer: json["customer"] == null
            ? null
            : Customer.fromJson(json["customer"]),
        products: json["products"] == null
            ? []
            : List<FavProduct>.from(
                json["products"]!.map((x) => FavProduct.fromJson(x))),
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
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
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

class FavProduct {
  final ProductId? productId;
  final String? id;

  FavProduct({
    this.productId,
    this.id,
  });

  FavProduct copyWith({
    ProductId? productId,
    String? id,
  }) =>
      FavProduct(
        productId: productId ?? this.productId,
        id: id ?? this.id,
      );

  factory FavProduct.fromJson(Map<String, dynamic> json) => FavProduct(
        productId: json["productId"] == null
            ? null
            : ProductId.fromJson(json["productId"]),
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId?.toJson(),
        "_id": id,
      };
}

class ProductId {
  final String? id;
  final String? name;
  final String? description;
  final String? image;
  final int? price;
  final Category? category;
  final DateTime? dateCreated;
  final int? v;

  ProductId({
    this.id,
    this.name,
    this.description,
    this.image,
    this.price,
    this.category,
    this.dateCreated,
    this.v,
  });

  ProductId copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    int? price,
    Category? category,
    DateTime? dateCreated,
    int? v,
  }) =>
      ProductId(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        image: image ?? this.image,
        price: price ?? this.price,
        category: category ?? this.category,
        dateCreated: dateCreated ?? this.dateCreated,
        v: v ?? this.v,
      );

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        price: json["price"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
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
        "category": category?.toJson(),
        "dateCreated": dateCreated?.toIso8601String(),
        "__v": v,
      };
}

class Category {
  final String? id;
  final String? name;
  final int? v;

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
