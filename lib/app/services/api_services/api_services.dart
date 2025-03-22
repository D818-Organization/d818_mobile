import 'dart:io';

import 'package:d818_mobile_app/app/helpers/connectivity_helper.dart';
import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/models/feedback/send_feedback_model.dart';
import 'package:d818_mobile_app/app/models/onboarding/signin_model.dart';
import 'package:d818_mobile_app/app/models/users/update_user_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/app/services/api_services/api_endpoints.dart';
import 'package:d818_mobile_app/app/services/api_services/api_interceptors.dart';
import 'package:d818_mobile_app/app/services/navigation_service.dart';
import 'package:d818_mobile_app/app/services/snackbar_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

var log = getLogger('ApiServices');

// const String _baseUrl = 'https://d818-backend.onrender.com/api';
const String _baseUrl = 'https://d818-backend-a3bb3967e45d.herokuapp.com/api';

var options = BaseOptions(
  baseUrl: _baseUrl,
  connectTimeout: const Duration(seconds: 60),
  receiveTimeout: const Duration(seconds: 60),
);
Dio _dio = Dio(options);

Dio init() {
  Dio dio = _dio;
  dio.interceptors.add(DioInterceptor());
  dio.options.baseUrl = _baseUrl;
  return dio;
}

class ApiServices {
  ApiServices() {
    init();
  }

  Future post(
    String endPoint, {
    required String data,
    String? token,
  }) async {
    bool? internetAvailable =
        await ConnectivityHelper.checkInternetConnectivity();

    if (internetAvailable == true) {
      try {
        Response response = await _dio.post(
          endPoint,
          options: Options(
            headers: {
              if (token != null) 'Authorization': 'Bearer $token',
            },
            validateStatus: (_) => true,
          ),
          data: data,
        );
        log.d("response.statusCode : ${response.statusCode}");
        log.wtf('POST response.data >>>> ${response.data}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          return response.data;
        } else {
          return "error";
        }
      } on DioException {
        log.w("DioException");
        return "error";
      } catch (e) {
        log.w("Error:-> $e");
        return "error";
      }
    } else {
      showNetworkErrorSnackbar();
    }
  }

  Future put(
    String endPoint, {
    required var data,
    String? token,
  }) async {
    bool? internetAvailable =
        await ConnectivityHelper.checkInternetConnectivity();

    if (internetAvailable == true) {
      try {
        Response response = await _dio.put(
          endPoint,
          options: Options(
            headers: {
              if (token != null) 'Authorization': 'Bearer $token',
            },
            validateStatus: (_) => true,
          ),
          data: data,
        );
        log.d("response.statusCode : ${response.statusCode}");
        log.wtf('POST response.data >>>> ${response.data}');
        if (response.statusCode == 200 || response.statusCode == 201) {
          return response.data;
        } else {
          return "error";
        }
      } on DioException {
        log.w("DioException");
        return "error";
      } catch (e) {
        log.w("Error:-> $e");
        return "error";
      }
    } else {
      showNetworkErrorSnackbar();
    }
  }

  Future get(
    String endPoint, {
    Map<String, String>? queryParameters,
    String? token,
  }) async {
    bool? internetAvailable =
        await ConnectivityHelper.checkInternetConnectivity();

    if (internetAvailable == true) {
      try {
        Response response = await _dio.get(
          endPoint,
          queryParameters: queryParameters,
          options: Options(
            headers: {
              if (token != null) 'Authorization': 'Bearer $token',
            },
            validateStatus: (_) => true,
          ),
        );
        log.d("response.statusCode : ${response.statusCode}");
        log.wtf('GET response.data >>>> ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          return response.data;
        } else {
          return "error";
        }
      } on DioException {
        log.w("DioException");
        return "error";
      } catch (e) {
        log.w("Error:-> $e");
        return "error";
      }
    } else {
      showNetworkErrorSnackbar();
    }
  }

  Future patch(
    String endPoint, {
    required String data,
    String? token,
  }) async {
    bool? internetAvailable =
        await ConnectivityHelper.checkInternetConnectivity();

    if (internetAvailable == true) {
      try {
        Response response = await _dio.patch(
          endPoint,
          options: Options(
            headers: {
              if (token != null) 'Authorization': 'Bearer $token',
            },
            validateStatus: (_) => true,
          ),
          data: data,
        );
        log.d("response.statusCode : ${response.statusCode}");
        log.wtf('POST response.data >>>> ${response.data}');
        return response.data;
      } on DioException {
        log.w("DioException");
        return "error";
      } catch (e) {
        log.w("Error:-> $e");
        return "error";
      }
    } else {
      showNetworkErrorSnackbar();
    }
  }

  Future delete(
    String endPoint, {
    // required
    Map<String, dynamic>? query,
    String? token,
  }) async {
    bool? internetAvailable =
        await ConnectivityHelper.checkInternetConnectivity();

    if (internetAvailable == true) {
      try {
        Response response = await _dio.delete(
          endPoint,
          options: Options(
            headers: {
              if (token != null) 'Authorization': 'Bearer $token',
            },
            validateStatus: (_) => true,
          ),
          // data: data,
          queryParameters: query,
        );
        log.d("response.statusCode : ${response.statusCode}");
        log.wtf('POST response.data >>>> ${response.data}');
        return response.data;
      } on DioException {
        log.w("DioException");
        return "error";
      } catch (e) {
        log.w("Error:-> $e");
        return "error";
      }
    } else {
      showNetworkErrorSnackbar();
    }
  }

  showNetworkErrorSnackbar() {
    showCustomSnackBar(
      NavigationService.navigatorKey.currentContext!,
      icon: Icons.network_check_sharp,
      content: "Kindly check your internet.",
      duration: 2,
    );
  }

  /// Main API Functions
  Future getPlans() async {
    log.wtf("Getting all plans");
    return await get(
      getPlansEndpoint,
    );
  }

  Future register(String newUserDataJson) async {
    return await post(
      registerEndpoint,
      data: newUserDataJson,
    );
  }

  Future requestOtp(String email) async {
    return await post(
      requestOtpEndpoint,
      data: '{"email": "$email"}',
    );
  }

  Future signin(SigninModel signinData) async {
    return await post(
      signinEndpoint,
      data: signinModelToJson(signinData),
    );
  }

  Future getMeals() async {
    log.wtf("Getting all meals");
    return await get(
      getMealsEndpoint,
    );
  }

  Future getProductReviews(String productId) async {
    log.wtf("Getting all reviews for product with id: $productId");
    return await get(
      "/reviews/$productId/reviews",
    );
  }

  Future createReview(String newReviewData) async {
    return await post(
      createReviewEndpoint,
      data: newReviewData,
      token: Globals.token,
    );
  }

  Future addToCart(String cartData) async {
    return await post(
      cartsEndpoint,
      data: cartData,
      token: Globals.token,
    );
  }

  Future getMyCart() async {
    return await get(
      cartsEndpoint,
      token: Globals.token,
    );
  }

  Future removeFromCart(Map<String, dynamic> query) async {
    return await delete(
      cartsEndpoint,
      query: query,
      token: Globals.token,
    );
  }

  Future emptyCart() async {
    return await delete(
      emptyCartEndpoint,
      token: Globals.token,
    );
  }

  Future addToFavourites(String cartData) async {
    return await post(
      favouritesEndpoint,
      data: cartData,
      token: Globals.token,
    );
  }

  Future getMyFavourites() async {
    return await get(
      favouritesEndpoint,
      token: Globals.token,
    );
  }

  Future removeFromFavourites(Map<String, dynamic> query) async {
    return await delete(
      favouritesEndpoint,
      query: query,
      token: Globals.token,
    );
  }

  Future getCampusList() async {
    return await get(
      campusEndpoint,
      token: Globals.token,
    );
  }

  Future getMyProfile() async {
    return await get(
      myProfileEndpoint,
      token: Globals.token,
    );
  }

  Future updateMyProfile(UpdateAccountModel updateAccountData) async {
    return await put(
      updateMyProfileEndpoint,
      data: updateAccountModelToJson(updateAccountData),
      token: Globals.token,
    );
  }

  Future updateMyProfileImage(File imageFile) async {
    String fileName = imageFile.path.split('/').last;
    log.d('fileName: fileName');

    FormData profileImageFormData = FormData.fromMap({
      "img": await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
      ),
    });

    log.d('Uploading contest cover image . . . .');

    return await put(
      updateMyProfileImageEndpoint,
      data: profileImageFormData,
      token: Globals.token,
    );
  }

  Future sendFeedbackMessage(SendFeedbackModel feedbackData) async {
    return await post(
      feedbackEndpoint,
      data: sendFeedbackModelToJson(feedbackData),
      token: Globals.token,
    );
  }

  Future createRegularOrder(String checkoutData) async {
    return await post(
      createRegularOrderEndpoint,
      data: checkoutData,
      token: Globals.token,
    );
  }

  Future createOutOfBoundOrder(String checkoutData) async {
    return await post(
      createOutOfBoundOrderEndpoint,
      data: checkoutData,
      token: Globals.token,
    );
  }

  fetchUserLocation(String userLocationEntered) async {
    Map<String, String> queryParams = {
      'destination': userLocationEntered,
    };
    return await get(
      getLocationDetailsEndpoint,
      queryParameters: queryParams,
      token: Globals.token,
    );
  }

  Future updateOrderPayment({
    required String orderId,
    required String paymentData,
  }) async {
    return await put(
      "/orders/$orderId/update-payment",
      data: paymentData,
      token: Globals.token,
    );
  }

  Future fetchAllRegularOrders() async {
    return await get(
      getAllRegularOrdersEndpoint,
      token: Globals.token,
    );
  }

  Future fetchAllOutOfBoundOrders() async {
    return await get(
      getAllOutOfBoundOrdersEndpoint,
      token: Globals.token,
    );
  }
}
