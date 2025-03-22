import 'dart:convert';

class CheckoutCartModel {
  final String? productId;
  final int? quantity;

  CheckoutCartModel({
    this.productId,
    this.quantity,
  });

  factory CheckoutCartModel.fromJson(Map<String, dynamic> json) =>
      CheckoutCartModel(
        productId: json["productId"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "quantity": quantity,
      };
}

// CITY CHECKOUT MODEL
CityCheckoutModel cityCheckoutModelFromJson(String str) =>
    CityCheckoutModel.fromJson(json.decode(str));

String cityCheckoutModelToJson(CityCheckoutModel data) =>
    json.encode(data.toJson());

class CityCheckoutModel {
  final List<CheckoutCartModel>? cart;
  final CityDeliveryInfo? deliveryInfo;

  CityCheckoutModel({
    this.cart,
    this.deliveryInfo,
  });

  factory CityCheckoutModel.fromJson(Map<String, dynamic> json) =>
      CityCheckoutModel(
        cart: json["cart"] == null
            ? []
            : List<CheckoutCartModel>.from(
                json["cart"]!.map((x) => CheckoutCartModel.fromJson(x))),
        deliveryInfo: json["deliveryInfo"] == null
            ? null
            : CityDeliveryInfo.fromJson(json["deliveryInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "cart": cart == null
            ? []
            : List<dynamic>.from(cart!.map((x) => x.toJson())),
        "deliveryInfo": deliveryInfo?.toJson(),
      };
}

class CityDeliveryInfo {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final bool? rate;
  final String? addr1;

  CityDeliveryInfo({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.rate,
    this.addr1,
  });

  factory CityDeliveryInfo.fromJson(Map<String, dynamic> json) =>
      CityDeliveryInfo(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        rate: json["rate"],
        addr1: json["addr1"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "rate": rate,
        "addr1": addr1,
      };
}

// CAMPUS CHECKOUT MODEL
CampusCheckoutModel campusCheckoutModelFromJson(String str) =>
    CampusCheckoutModel.fromJson(json.decode(str));

String campusCheckoutModelToJson(CampusCheckoutModel data) =>
    json.encode(data.toJson());

class CampusCheckoutModel {
  final List<CheckoutCartModel>? cart;
  final CampusDeliveryInfo? deliveryInfo;

  CampusCheckoutModel({
    this.cart,
    this.deliveryInfo,
  });

  factory CampusCheckoutModel.fromJson(Map<String, dynamic> json) =>
      CampusCheckoutModel(
        cart: json["cart"] == null
            ? []
            : List<CheckoutCartModel>.from(
                json["cart"]!.map((x) => CheckoutCartModel.fromJson(x))),
        deliveryInfo: json["deliveryInfo"] == null
            ? null
            : CampusDeliveryInfo.fromJson(json["deliveryInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "cart": cart == null
            ? []
            : List<dynamic>.from(cart!.map((x) => x.toJson())),
        "deliveryInfo": deliveryInfo?.toJson(),
      };
}

class CampusDeliveryInfo {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final bool? rate;
  final String? campus;

  CampusDeliveryInfo({
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.rate,
    this.campus,
  });

  factory CampusDeliveryInfo.fromJson(Map<String, dynamic> json) =>
      CampusDeliveryInfo(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        rate: json["rate"],
        campus: json["campus"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "rate": rate,
        "campus": campus,
      };
}

// OUT OF BOUND CHECKOUT MODEL
OutOfBoundCheckoutModel outOfBoundCheckoutModelFromJson(String str) =>
    OutOfBoundCheckoutModel.fromJson(json.decode(str));

String outOfBoundCheckoutModelToJson(OutOfBoundCheckoutModel data) =>
    json.encode(data.toJson());

class OutOfBoundCheckoutModel {
  final List<CheckoutCartModel> cart;
  final OutOfBoundDeliveryInfo deliveryInfo;

  OutOfBoundCheckoutModel({
    required this.cart,
    required this.deliveryInfo,
  });

  factory OutOfBoundCheckoutModel.fromJson(Map<String, dynamic> json) =>
      OutOfBoundCheckoutModel(
        cart: List<CheckoutCartModel>.from(
            json["cart"].map((x) => CheckoutCartModel.fromJson(x))),
        deliveryInfo: OutOfBoundDeliveryInfo.fromJson(json["deliveryInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "cart": List<dynamic>.from(cart.map((x) => x.toJson())),
        "deliveryInfo": deliveryInfo.toJson(),
      };
}

class OutOfBoundDeliveryInfo {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String addr1;

  OutOfBoundDeliveryInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.addr1,
  });

  factory OutOfBoundDeliveryInfo.fromJson(Map<String, dynamic> json) =>
      OutOfBoundDeliveryInfo(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        addr1: json["addr1"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "addr1": addr1,
      };
}
