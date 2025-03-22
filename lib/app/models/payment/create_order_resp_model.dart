import 'dart:convert';

CreateOrderResponseModel createOrderResponseModelFromJson(String str) =>
    CreateOrderResponseModel.fromJson(json.decode(str));

String createOrderResponseModelToJson(CreateOrderResponseModel data) =>
    json.encode(data.toJson());

class CreateOrderResponseModel {
  final String? orderId;
  final int? totalPrice;

  CreateOrderResponseModel({
    this.orderId,
    this.totalPrice,
  });

  CreateOrderResponseModel copyWith({
    String? orderId,
    int? totalPrice,
  }) =>
      CreateOrderResponseModel(
        orderId: orderId ?? this.orderId,
        totalPrice: totalPrice ?? this.totalPrice,
      );

  factory CreateOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateOrderResponseModel(
        orderId: json["orderId"],
        totalPrice: json["totalPrice"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "totalPrice": totalPrice,
      };
}

OutOfBoundOrderResponseModel outOfBoundOrderResponseModelFromJson(String str) =>
    OutOfBoundOrderResponseModel.fromJson(json.decode(str));

String outOfBoundOrderResponseModelToJson(OutOfBoundOrderResponseModel data) =>
    json.encode(data.toJson());

class OutOfBoundOrderResponseModel {
  final String orderId;
  final List<String> orderItems;
  final String addr1;
  final String phone;
  final int totalPrice;
  final String customer;
  final String id;
  final DateTime dateOrdered;
  final int v;
  final String outOfBoundOrderResponseModelId;

  OutOfBoundOrderResponseModel({
    required this.orderId,
    required this.orderItems,
    required this.addr1,
    required this.phone,
    required this.totalPrice,
    required this.customer,
    required this.id,
    required this.dateOrdered,
    required this.v,
    required this.outOfBoundOrderResponseModelId,
  });

  factory OutOfBoundOrderResponseModel.fromJson(Map<String, dynamic> json) =>
      OutOfBoundOrderResponseModel(
        orderId: json["orderId"],
        orderItems: List<String>.from(json["orderItems"].map((x) => x)),
        addr1: json["addr1"],
        phone: json["phone"],
        totalPrice: json["totalPrice"],
        customer: json["customer"],
        id: json["_id"],
        dateOrdered: DateTime.parse(json["dateOrdered"]),
        v: json["__v"],
        outOfBoundOrderResponseModelId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x)),
        "addr1": addr1,
        "phone": phone,
        "totalPrice": totalPrice,
        "customer": customer,
        "_id": id,
        "dateOrdered": dateOrdered.toIso8601String(),
        "__v": v,
        "id": outOfBoundOrderResponseModelId,
      };
}
