import 'dart:convert';

import 'package:d818_mobile_app/app/models/location/geocode_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/app/services/api_services/api_services.dart';
import 'package:d818_mobile_app/ui/features/transactions/data/data.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/custom_textfield.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

var log = getLogger('GeoLocationPage');

class GeoLocationPage extends StatefulWidget {
  const GeoLocationPage({super.key});

  @override
  State<GeoLocationPage> createState() => _GeoLocationPageState();
}

class _GeoLocationPageState extends State<GeoLocationPage> {
  late TextEditingController addressController;

  String? fetchedLocation;
  double? fetchedDistance;
  bool fetchLocationLoading = false, errorOccured = false;

  @override
  void initState() {
    super.initState();
    addressController = TextEditingController();
  }

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  fetchDeliveryAddress(String enteredLocation) async {
    setState(() {
      fetchLocationLoading = true;
    });
    try {
      // Getting user location suggestion
      var fetchUserLocationResponse = await ApiServices().fetchUserLocation(
        enteredLocation,
      );

      if (fetchUserLocationResponse.toString() == "error") {
        log.w("Error fetching suggested locations");
        errorOccured = true;
        fetchedLocation = "";
      } else {
        errorOccured = false;
        GeocodeModel geoDetailsData = geocodeModelFromJson(
          jsonEncode(
            fetchUserLocationResponse,
          ),
        );
        log.wtf("Fetched suggested locations: ${geoDetailsData.toJson()} ");
        if (geoDetailsData.rows[0].elements[0].status.toUpperCase() != "OK") {
          fetchedLocation = "";
        } else {
          fetchedLocation = geoDetailsData.destinationAddresses[0];
          fetchedDistance =
              geoDetailsData.rows[0].elements[0].distance.value.toDouble();
          deliveryDistance = fetchedDistance;
        }
      }
    } catch (e) {
      log.w("An error occured: ${e.toString()}");
      fetchedLocation = "";
    }
    setState(() {
      fetchLocationLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.kPrimaryColor,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: const EdgeInsets.only(left: 8, right: 0),
            height: 60,
            child: Icon(
              Icons.close_sharp,
              color: AppColors.plainWhite,
              size: 30,
            ),
          ),
        ),
        title: Text(
          "Enter delivery address",
          style: AppStyles.boldHeaderStyle(18, color: AppColors.plainWhite),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.plainWhite,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            customVerticalSpacer(12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: CustomTextField(
                textEditingController: addressController,
                mainFillColor: AppColors.plainWhite,
                borderColor: AppColors.blueGray,
                autofocus: false,
                height: 40,
                hintText: "Enter delivery address",
                hintStyle: AppStyles.normalStringStyle(16),
                inputStringStyle: AppStyles.semiHeaderStyle(16, 1.0),
              ),
            ),
            customVerticalSpacer(8),
            fetchLocationLoading == true
                ? const CircularProgressIndicator(
                    strokeWidth: 3,
                  )
                : CustomButton(
                    width: 160,
                    borderRadius: 16,
                    height: 40,
                    color: AppColors.lighterGrey,
                    child: Text(
                      "Check For Address",
                      style: TextStyle(
                        color: AppColors.coolRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      if (addressController.text.trim().isEmpty == true) {
                        Fluttertoast.showToast(msg: "Enter address first");
                      } else {
                        String enteredLoc = addressController.text.trim();
                        fetchDeliveryAddress("$enteredLoc Akure");
                      }
                    },
                  ),
            customVerticalSpacer(10),
            fetchLocationLoading == true
                ? const SizedBox.shrink()
                : fetchedLocation == null
                    ? const SizedBox.shrink()
                    : fetchedLocation == ""
                        ? Text(
                            "No location found",
                            style: AppStyles.lightStringStyleColored(
                              12,
                              AppColors.kPrimaryColor,
                            ),
                          )
                        : Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.location_pin,
                                  color: AppColors.kPrimaryColor,
                                ),
                                title: Text(
                                  fetchedLocation ?? "",
                                  style: AppStyles.semiHeaderStyle(16, 1.5),
                                ),
                                subtitle: Text(
                                  "${fetchedDistance! / 1000} km",
                                  style: AppStyles.lightStringStyleColored(
                                    13,
                                    AppColors.fullBlack,
                                  ),
                                ),
                                onTap: () {},
                              ),
                              CustomButton(
                                width: 160,
                                borderRadius: 16,
                                height: 40,
                                color: AppColors.kPrimaryColor,
                                child: Text(
                                  "Confirm Address",
                                  style: TextStyle(
                                    color: AppColors.plainWhite,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onPressed: () {
                                  deliveryAddress = fetchedLocation;
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
          ],
        ),
      ),
    );
  }
}
