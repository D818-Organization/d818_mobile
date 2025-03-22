// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/models/payment/checkout_model.dart';
import 'package:d818_mobile_app/app/models/payment/create_order_resp_model.dart';
import 'package:d818_mobile_app/app/models/payment/stripe_payment_details_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/app/services/api_services/api_services.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

var log = getLogger('StripeHelper');

class StripeHelper {
  ApiServices apiServices = ApiServices();
  Map<String, dynamic>? paymentIntent;

  makePaymentWithStripe(
    BuildContext context,
    String checkoutDataString,
  ) async {
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

        String? address, phoneNumber;
        String amountToBePaid = '${createdOrderData.totalPrice}';

        if (checkoutDataString.toString().contains("campus")) {
          CampusCheckoutModel campusCheckoutData = campusCheckoutModelFromJson(
            checkoutDataString,
          );
          phoneNumber = campusCheckoutData.deliveryInfo?.phone;
          address = campusCheckoutData.deliveryInfo?.campus;
        } else {
          CityCheckoutModel cityCheckoutData = cityCheckoutModelFromJson(
            checkoutDataString,
          );
          phoneNumber = cityCheckoutData.deliveryInfo?.phone;
          address = cityCheckoutData.deliveryInfo?.addr1;
        }

        PayStripeModel payData = PayStripeModel(
          amount: amountToBePaid,
          currency: "GBP",
        );
        BillingDetails billingDetails = BillingDetails(
          email: Globals.email,
          phone: phoneNumber,
          name: Globals.fullname,
          address: Address(
            city: "city",
            country: "country",
            line1: address,
            line2: "line2",
            postalCode: "postalcode",
            state: "state",
          ),
        );

        paymentIntent = await createPaymentIntent(payData);

        log.wtf(
            "paymentIntent Response: ${paymentIntent.toString()}\n${paymentIntent!['client_secret']}");
        await Stripe.instance
            .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            billingDetails: billingDetails,
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            style: ThemeMode.light,
            merchantDisplayName: 'D818 Restaurant',
          ),
        )
            .then((value) {
          log.wtf("Stripe Initialization done");
        });

        displayPaymentSheet(
          context,
          orderId: createdOrderData.orderId!,
          paymentId: paymentIntent!['id'],
        );
      } else {
        Fluttertoast.showToast(msg: "Error creating your order");
        return PaymentValidator.failed;
      }
    } catch (e) {
      log.w("Init: ${e.toString()}");
      Fluttertoast.showToast(msg: "Error initiating payment");
      return PaymentValidator.failed;
    }
  }

  displayPaymentSheet(
    BuildContext context, {
    required String orderId,
    required String paymentId,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {});

      Fluttertoast.showToast(msg: 'Payment succesfully completed');

      // UPDATE order payment details
      log.wtf("Send confirmation data to backend here");

      BlocProvider.of<TransactionsBloc>(context).add(
        UpdateOrderPayment(
          orderId,
          paymentId,
        ),
      );

      return PaymentValidator.success;
    } on Exception catch (e) {
      if (e is StripeException) {
        log.w("Error from Stripe: ${e.toJson()}'");
        if (e.error.localizedMessage
            .toString()
            .contains("payment has been canceled")) {
          Fluttertoast.showToast(msg: 'Cancelled');
          return PaymentValidator.cancelled;
        } else {
          Fluttertoast.showToast(msg: 'Error processing Stripe');
          return PaymentValidator.failed;
        }
      } else {
        Fluttertoast.showToast(msg: 'Error Occured');
        log.w("Unforeseen error: $e");
        return PaymentValidator.failed;
      }
    }
  }

  //create Payment
  createPaymentIntent(PayStripeModel payStripeData) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(payStripeData.amount.toString()),
        'currency': "GBP",
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET_KEY']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      log.wtf("Intent Response: ${response.body.toString()}");
      return json.decode(response.body);
    } catch (err) {
      log.w(err.toString());
      return 'error';
    }
  }

  //calculate Amount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
