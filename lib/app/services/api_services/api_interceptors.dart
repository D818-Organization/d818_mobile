// ignore_for_file: prefer_interpolation_to_compose_strings, deprecated_member_use

import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:dio/dio.dart';

class DioInterceptor extends Interceptor {
  final log = getLogger('DioInterceptor');

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    log.i('ENDPOINT: ' + err.requestOptions.uri.toString());
    log.i('STATUSCODE: ' + err.error.toString());
    log.i('MESSAGE: ' + (err.response?.data ?? err.message).toString());
    // if (err.response?.statusCode == 401) {
    //   NavigationService.navigatorKey.currentContext?.go('/loggedOutScreen');
    // }
    // handler.next(err);
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log.i('METHOD: ' + options.method);
    log.i('ENDPOINT: ' + options.uri.toString());
    log.i('HEADERS: ' + options.headers.toString());
    log.i('DATA: ' + (options.data ?? options.queryParameters).toString());
    // handler.next(options);
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log.i('ENDPOINT: ' + response.requestOptions.uri.toString());
    log.i('STATUSCODE: ' + response.statusCode.toString());
    log.i('DATA: ' + response.data.toString());
    // if (response.statusCode == 401) {
    //   NavigationService.navigatorKey.currentContext?.go('/loggedOutScreen');
    // }
    // handler.next(response);
    super.onResponse(response, handler);
  }
}
