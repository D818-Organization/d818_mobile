// ignore_for_file: avoid_print

import 'package:d818_mobile_app/app/models/cart/cart_details_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final log = getLogger('SharedPrefs');

Future<void> saveSharedPrefsStringValue(
    {required String stringKey, required String stringValue}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(stringKey, stringValue);
  log.d('Saved $stringKey as $stringValue');
}

Future<String> getSharedPrefsSavedString(String stringKey) async {
  final prefs = await SharedPreferences.getInstance();
  final String? readValue = prefs.getString(stringKey);
  log.d('Retrieved value for $stringKey is $readValue.');
  return readValue ?? '';
}

Future<void> updateLocalCart(String cartDataJson) async {
  await saveSharedPrefsStringValue(
    stringKey: "localcart",
    stringValue: cartDataJson,
  );
}

Future<CartDetailsModel?> getLocalCart() async {
  try {
    final localCartDataString = await getSharedPrefsSavedString("localcart");
    if (localCartDataString == '') {
      log.w("No local cart data");
      return null;
    } else {
      final localCartDetailsData =
          cartDetailsModelFromJson(localCartDataString);
      log.wtf("Fetched localCartDetailsData: ${localCartDetailsData.toJson()}");
      return localCartDetailsData;
    }
  } catch (e) {
    log.e("Error fetching local cart data: ${e.toString()}");
    return null;
  }
}

Future<void> clearLocalCart() async {
  await updateLocalCart('');
}

saveDeliveryPhoneNumber(String phoneNumber) {
  saveSharedPrefsStringValue(
    stringKey: "deliveryPhoneNumber",
    stringValue: phoneNumber,
  );
}

Future<String> getPreviousDeliveryPhoneNumber() async {
  return await getSharedPrefsSavedString("deliveryPhoneNumber");
}

saveDeliveryAddress(String address) {
  saveSharedPrefsStringValue(
    stringKey: "deliveryAdress",
    stringValue: address,
  );
}

Future<String> getPreviousDeliveryAddress() async {
  return await getSharedPrefsSavedString("deliveryAdress");
}

saveScreenToGoAfterLogin(String screenName) {
  saveSharedPrefsStringValue(
    stringKey: "screenToGoAfterLogin",
    stringValue: screenName,
  );
}

Future<String> getScreenToGoAfterLogin() async {
  return await getSharedPrefsSavedString("screenToGoAfterLogin");
}
