import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';

var log = getLogger('ConnectivityHelper');

class ConnectivityHelper {
  static Future<bool?> checkInternetConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.isEmpty == true) {
      log.wtf("No internet connection");
      return false;
    } else {
      log.wtf("Connected to a mobile network");
      return true;
    }
  }
}
