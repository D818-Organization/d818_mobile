import 'dart:convert';

OutOfBoundsOrdersModel outOfBoundsOrdersModelFromJson(String str) =>
    OutOfBoundsOrdersModel.fromJson(json.decode(str));

String outOfBoundsOrdersModelToJson(OutOfBoundsOrdersModel data) =>
    json.encode(data.toJson());

class OutOfBoundsOrdersModel {
  final String id;
  final String orderId;
  final List<OrderItem> orderItems;
  final String? addr1;
  final String phone;
  final int totalPrice;
  final String customer;
  final DateTime dateOrdered;
  final int v;
  final String outOfBoundsOrdersModelId;

  OutOfBoundsOrdersModel({
    required this.id,
    required this.orderId,
    required this.orderItems,
    required this.addr1,
    required this.phone,
    required this.totalPrice,
    required this.customer,
    required this.dateOrdered,
    required this.v,
    required this.outOfBoundsOrdersModelId,
  });

  factory OutOfBoundsOrdersModel.fromJson(Map<String, dynamic> json) =>
      OutOfBoundsOrdersModel(
        id: json["_id"],
        orderId: json["orderId"],
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
        addr1: json["addr1"],
        phone: json["phone"],
        totalPrice: json["totalPrice"],
        customer: json["customer"],
        dateOrdered: DateTime.parse(json["dateOrdered"]),
        v: json["__v"],
        outOfBoundsOrdersModelId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "orderId": orderId,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "addr1": addr1,
        "phone": phone,
        "totalPrice": totalPrice,
        "customer": customer,
        "dateOrdered": dateOrdered.toIso8601String(),
        "__v": v,
        "id": outOfBoundsOrdersModelId,
      };
}

class OrderItem {
  final String id;
  final int quantity;
  final Product product;
  final int v;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.product,
    required this.v,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["_id"],
        quantity: json["quantity"],
        product: Product.fromJson(json["product"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "quantity": quantity,
        "product": product.toJson(),
        "__v": v,
      };
}

class Product {
  final String id;
  final String name;
  final String description;
  final String image;
  final int price;
  final Category category;
  final DateTime dateCreated;
  final int v;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.price,
    required this.category,
    required this.dateCreated,
    required this.v,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        image: json["image"],
        price: json["price"],
        category: Category.fromJson(json["category"]),
        dateCreated: DateTime.parse(json["dateCreated"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "image": image,
        "price": price,
        "category": category.toJson(),
        "dateCreated": dateCreated.toIso8601String(),
        "__v": v,
      };
}

class Category {
  final String id;
  final String name;
  final int v;

  Category({
    required this.id,
    required this.name,
    required this.v,
  });

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
