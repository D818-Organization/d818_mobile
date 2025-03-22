import 'dart:convert';

GeocodeModel geocodeModelFromJson(String str) =>
    GeocodeModel.fromJson(json.decode(str));

String geocodeModelToJson(GeocodeModel data) => json.encode(data.toJson());

class GeocodeModel {
  final List<String> destinationAddresses;
  final List<String> originAddresses;
  final List<GeoRow> rows;
  final String status;

  GeocodeModel({
    required this.destinationAddresses,
    required this.originAddresses,
    required this.rows,
    required this.status,
  });

  factory GeocodeModel.fromJson(Map<String, dynamic> json) => GeocodeModel(
        destinationAddresses:
            List<String>.from(json["destination_addresses"].map((x) => x)),
        originAddresses:
            List<String>.from(json["origin_addresses"].map((x) => x)),
        rows: List<GeoRow>.from(json["rows"].map((x) => GeoRow.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "destination_addresses":
            List<dynamic>.from(destinationAddresses.map((x) => x)),
        "origin_addresses": List<dynamic>.from(originAddresses.map((x) => x)),
        "rows": List<dynamic>.from(rows.map((x) => x.toJson())),
        "status": status,
      };
}

class GeoRow {
  final List<Element> elements;

  GeoRow({
    required this.elements,
  });

  factory GeoRow.fromJson(Map<String, dynamic> json) => GeoRow(
        elements: List<Element>.from(
            json["elements"].map((x) => Element.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "elements": List<dynamic>.from(elements.map((x) => x.toJson())),
      };
}

class Element {
  final Distance distance;
  final Distance duration;
  final String status;

  Element({
    required this.distance,
    required this.duration,
    required this.status,
  });

  factory Element.fromJson(Map<String, dynamic> json) => Element(
        distance: Distance.fromJson(json["distance"]),
        duration: Distance.fromJson(json["duration"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "distance": distance.toJson(),
        "duration": duration.toJson(),
        "status": status,
      };
}

class Distance {
  final String text;
  final int value;

  Distance({
    required this.text,
    required this.value,
  });

  factory Distance.fromJson(Map<String, dynamic> json) => Distance(
        text: json["text"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
      };
}
