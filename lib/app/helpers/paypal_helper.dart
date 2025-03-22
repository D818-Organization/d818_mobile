// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:d818_mobile_app/app/models/payment/create_order_resp_model.dart';
import 'package:d818_mobile_app/app/models/payment/paypal_resp_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/app/services/api_services/api_services.dart';
import 'package:d818_mobile_app/app/services/navigation_service.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:fluttertoast/fluttertoast.dart';

var log = getLogger('Cart_bloc');

class PaypalHelper {
  ApiServices apiServices = ApiServices();

  payWithPaypal(checkoutDataString) async {
    try {
      var createOrderResponse =
          await apiServices.createRegularOrder(checkoutDataString);

      if (createOrderResponse.toString() != "error") {
        log.wtf(
          "Successfully created order: ${createOrderResponse.toString()}",
        );
        CreateOrderResponseModel createdOrderData =
            createOrderResponseModelFromJson(
          jsonEncode(
            createOrderResponse,
          ),
        );
        log.wtf("createdOrderData: ${createdOrderData.toJson()}");
        String amountToBePaid = '${createdOrderData.totalPrice}';

        await Navigator.push(
          NavigationService.navigatorKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => UsePaypal(
              sandboxMode: false,
              clientId: dotenv.env['PAYPAL_CLIENT_ID']!,
              secretKey: dotenv.env['PAYPAL_CLIENT_SECRET']!,
              returnURL: "https://samplesite.com/return",
              cancelURL: "https://samplesite.com/cancel",
              // returnURL: "www.d818.com",
              // cancelURL: "www.d818buka.com",
              transactions: [
                {
                  "amount": {
                    "total": amountToBePaid,
                    "currency": "GBP",
                    "details": {
                      "subtotal": amountToBePaid,
                    }
                  },
                  "description": "Purchasing meals from D818 Buka restaurant.",
                  "item_list": {
                    "items": [
                      {
                        "name": "food",
                        "quantity": 1,
                        "price": amountToBePaid,
                        "currency": "GBP"
                      }
                    ],
                  }
                }
              ],
              note: "Purchasing meals from D818 Buka restaurant.",
              onSuccess: (Map response) async {
                log.wtf("onSuccess: $response");
                PaypalResponseModel paypalResponse = PaypalResponseModel();
                try {
                  paypalResponse = paypalResponseModelFromJson(
                    json.encode(response),
                  );
                  log.w("************ Status: ${paypalResponse.status}");
                } catch (e) {
                  log.w("////////// error converting data: $e");
                }
                Fluttertoast.showToast(msg: "Order placed successfully");

                // UPDATE order payment details
                log.wtf("Send confirmation data to backend here");
                BlocProvider.of<TransactionsBloc>(context).add(
                  UpdateOrderPayment(
                    createdOrderData.orderId!,
                    paypalResponse.paymentId!,
                  ),
                );

                return PaymentValidator.success;
              },
              onError: (error) {
                log.w("----------- error: $error");
                Fluttertoast.showToast(msg: "Error purchasing meals.");
                return PaymentValidator.failed;
              },
              onCancel: (response) {
                log.w(">>>>>>>>>>>>>>>>>> cancelled: $response");
                Fluttertoast.showToast(msg: "Error purchasing meals.");
                return PaymentValidator.cancelled;
              },
            ),
          ),
        );
      } else {
        log.w("Error creating Order ?????????");
        Fluttertoast.showToast(msg: "Error creating order.");
        return PaymentValidator.failed;
      }
    } catch (e) {
      log.w("Error creating Order ++++++++++: ${e.toString()}");
      Fluttertoast.showToast(msg: "Error creating order.");
      return PaymentValidator.failed;
    }
  }
}
