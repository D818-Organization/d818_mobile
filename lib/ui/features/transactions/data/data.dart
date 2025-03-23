import 'package:d818_mobile_app/app/models/campuses/campus_model.dart';

List<String> deliveryList = [
  'Campus',
  'Address',
];

String? deliveryAddress;

double? deliveryDistance;

String? selectedDelivery = deliveryList[0];

List<CampusModel> campusList = [CampusModel(name: "Select Campus")];

String? selectedCampusName = campusList[0].name;
