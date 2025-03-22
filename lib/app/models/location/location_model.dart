class LocationModel {
  final String? city, country, postalCode, name, street;
  final double? longitude;
  final double? latitude;

  LocationModel({
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.postalCode,
    this.name,
    this.street,
  });

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
        "postalCode": postalCode,
        "name": name,
        "street": street,
        "city": city,
        "country": country,
      };
}
