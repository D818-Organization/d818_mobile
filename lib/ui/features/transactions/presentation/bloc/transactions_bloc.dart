// ignore_for_file: invalid_use_of_visible_for_testing_member, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';

import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/helpers/location_helper.dart';
import 'package:d818_mobile_app/app/helpers/paypal_helper.dart';
import 'package:d818_mobile_app/app/helpers/sharedprefs_helper.dart';
import 'package:d818_mobile_app/app/helpers/stripe_helper.dart';
import 'package:d818_mobile_app/app/models/campuses/campus_model.dart';
import 'package:d818_mobile_app/app/models/cart/add_to_cart_model.dart';
import 'package:d818_mobile_app/app/models/cart/cart_details_model.dart';
import 'package:d818_mobile_app/app/models/location/location_model.dart';
import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';
import 'package:d818_mobile_app/app/models/payment/checkout_model.dart';
import 'package:d818_mobile_app/app/models/payment/create_order_resp_model.dart';
import 'package:d818_mobile_app/app/models/payment/update_order_payment_model.dart';
import 'package:d818_mobile_app/app/models/transactions/outofbounds_orders_model.dart';
import 'package:d818_mobile_app/app/models/transactions/regular_orders_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/app/services/api_services/api_services.dart';
import 'package:d818_mobile_app/app/services/navigation_service.dart';
import 'package:d818_mobile_app/app/services/snackbar_service.dart';
import 'package:d818_mobile_app/ui/features/nav_bar/data/page_index_class.dart';
import 'package:d818_mobile_app/ui/features/transactions/data/data.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_events.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_states.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/views/checkout_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

var log = getLogger('Cart_bloc');

enum PaymentOptions { stripe, paypal }

enum PaymentValidator { success, failed, cancelled }

class TransactionsBloc extends Bloc<TransactionsBlocEvent, TransactionsState> {
  ApiServices apiServices = ApiServices();
  String deliveryPhoneNumber = '';

  /// Range limit: 7 miles == 11.26 km
  double deliveryDistanceLimit = 11250.0;
  TransactionsBloc() : super(TransactionsState()) {
    on<GetCartData>((event, emit) async {
      if (Globals.token == '') {
        await getLocalCartData(true);
      } else {
        await getOnlineCartData();
      }
    });

    on<AddToCart>((event, emit) async {
      if (Globals.token == '') {
        addToLocalCart(event.mealData, event.productItemCount);
      } else {
        final addToCartData = AddToCartModel(
          productId: event.mealData.id,
          quantity: event.productItemCount,
        );
        await addToOnlineCart(addToCartData);
      }
    });

    on<UpdateCart>((event, emit) async {
      if (Globals.token == '') {
        await updateLocalCartData(
          event.updateCartData.quantity ?? 1,
          event.productIndex,
        );
      } else {
        await updateOnlineCartData(event.updateCartData);
      }
    });

    on<DeleteItemFromCart>((event, emit) async {
      if (Globals.token == '') {
        await deleteItemFromLocalCart(event.productIndex);
      } else {
        await deleteItemFromOnlineCart(event.productId);
      }
    });

    on<BuyNow>((event, emit) async {
      if (Globals.token == '') {
        await buyNowForGuest(
          event.context,
          event.feedData,
          event.productItemCount,
        );
      } else {
        final addToCartData = AddToCartModel(
          productId: event.feedData.id,
          quantity: 1,
        );
        await buyNowForLoggedInUser(event.context, addToCartData);
      }
    });

    on<SelectCampus>((event, emit) async {
      await selectCampus(event.campus);
    });

    on<SelectPaymentOption>((event, emit) async {
      await selectPaymentOption(event.paymentOption);
    });

    on<SetDeliveryPhoneNumber>((event, emit) async {
      await setDeliveryPhoneNumber(event.phoneNumber);
    });

    on<CheckoutOrder>((event, emit) async {
      // Check if deliveryDistance is not out of range
      bool distanceCheck = deliveryDistance! <= deliveryDistanceLimit;
      distanceCheck == true 
          ? await checkoutRegularOrder(event.context)
          : await checkoutOutOfBoundOrder(event.context);
    });

    on<UpdateOrderPayment>((event, emit) async {
      await updateOrderPayment(
        orderID: event.orderId,
        paymentID: event.paymentId,
      );
    });

    on<FetchAllOrdersData>((event, emit) async {
      await fetchAllOrdersData();
    });
  }

  fetchAllOrdersData() async {
    emit(state.copyWith(
      loading: true,
    ));

    try {
      // Get all regular orders
      List<RegularOrdersModel> regularOrderDetailsData = [];
      var fetchAllRegularOrdersResponse =
          await apiServices.fetchAllRegularOrders();

      if (fetchAllRegularOrdersResponse.toString() == "error") {
        log.w("Error fetching regular orders");
        emit(state.copyWith(
          loading: false,
          errorFetchingOrders: true,
        ));
      } else if (fetchAllRegularOrdersResponse.toString() == "[]") {
        log.w("No order items yet");
        emit(state.copyWith(
          loading: false,
          noRegOrdersItems: true,
          errorFetchingOrders: true,
        ));
      } else {
        log.wtf(
          "Successfully fetched Regular orders: ${fetchAllRegularOrdersResponse.toString()}",
        );
        var dataBody = fetchAllRegularOrdersResponse;
        if (dataBody != null) {
          regularOrderDetailsData = (dataBody)
              .map((i) => RegularOrdersModel.fromJson(i))
              .toList()
              .cast<RegularOrdersModel>();
        }
        log.wtf("No of Regular Orders: ${regularOrderDetailsData.length}");

        emit(state.copyWith(
          errorFetchingOrders: false,
          noRegOrdersItems: false,
          regularOrdersData: regularOrderDetailsData,
        ));
      }
      log.w("Done: Regular Orders = ${state.regularOrdersData?.length}");

      // Get all out of bound orders
      List<OutOfBoundsOrdersModel> outOfBoundOrderDetailsData = [];
      var fetchAllOutOfBoundOrdersResponse =
          await apiServices.fetchAllOutOfBoundOrders();

      if (fetchAllOutOfBoundOrdersResponse.toString() == "error") {
        log.w("Error fetching regular orders");
        emit(state.copyWith(
          loading: false,
          errorFetchingOrders: true,
        ));
      } else if (fetchAllOutOfBoundOrdersResponse.toString() == "[]") {
        log.w("No order items yet");
        emit(state.copyWith(
          loading: false,
          noOobOrdersItems: true,
          errorFetchingOrders: true,
        ));
      } else {
        log.wtf(
          "Successfully fetched OOB orders: ${fetchAllOutOfBoundOrdersResponse.toString()}",
        );

        var dataBody = fetchAllOutOfBoundOrdersResponse;
        if (dataBody != null) {
          outOfBoundOrderDetailsData = (dataBody)
              .map((i) => OutOfBoundsOrdersModel.fromJson(i))
              .toList()
              .cast<OutOfBoundsOrdersModel>();
        }
        log.wtf("No of OOB Orders: ${outOfBoundOrderDetailsData.length}");

        emit(state.copyWith(
          errorFetchingOrders: false,
          noOobOrdersItems: false,
          outOfBoundOrdersData: outOfBoundOrderDetailsData,
          loading: false,
        ));
      }
      log.w("Done: OOB Orders = ${state.outOfBoundOrdersData?.length}");
    } catch (e) {
      log.wtf("Error occured: ${e.toString()}");
      emit(state.copyWith(
        errorFetchingOrders: true,
        loading: false,
      ));
    }
  }

  checkoutRegularOrder(BuildContext context) async {
    emit(state.copyWith(loading: true));
    List<CheckoutCartModel> checkoutCartList = [];
    for (var cartMeal in state.cartData!.products!) {
      CheckoutCartModel checkoutCart = CheckoutCartModel(
        productId: cartMeal.productData!.id,
        quantity: cartMeal.quantity,
      );
      checkoutCartList.add(checkoutCart);
      log.wtf("${checkoutCart.toJson()}");
    }
    log.w("${checkoutCartList.length}");

    String checkoutData;
    if (selectedDelivery == deliveryList[0]) {
      CampusCheckoutModel campusCheckoutData = CampusCheckoutModel(
        cart: checkoutCartList,
        deliveryInfo: CampusDeliveryInfo(
          firstName: Globals.fullname.split(" ")[0],
          lastName: Globals.fullname.split(" ")[1],
          email: Globals.email,
          phone: deliveryPhoneNumber,
          rate: selectedDelivery == deliveryList[0] ? false : true,
          campus: state.campuselected?.id,
        ),
      );
      checkoutData = campusCheckoutModelToJson(campusCheckoutData);
    } else {
      CityCheckoutModel cityCheckoutData = CityCheckoutModel(
        cart: checkoutCartList,
        deliveryInfo: CityDeliveryInfo(
          firstName: Globals.fullname.split(" ")[0],
          lastName: Globals.fullname.split(" ")[1],
          email: Globals.email,
          phone: deliveryPhoneNumber,
          rate: selectedDelivery == deliveryList[0] ? false : true,
          addr1: deliveryAddress,
        ),
      );
      checkoutData = cityCheckoutModelToJson(cityCheckoutData);
    }

    log.w("Checkout Data: $checkoutData");

    if (state.selectedPaymentOption == PaymentOptions.paypal) {
      log.w("Checking out order with Paypal");
      var result = await PaypalHelper().payWithPaypal(
        checkoutData,
      );
      if (result == PaymentValidator.success) {
        log.wtf("Transaction completed ''''''''''");
        // NavigationService.navigatorKey.currentContext?.pop();
        // clearCart();
      } else if (result == PaymentValidator.cancelled) {
        log.wtf("Transaction cancelled ???????????");
        NavigationService.navigatorKey.currentContext?.pop();
      } else {
        log.w("^^^^^^^^^^");
      }
    } else {
      log.w("Checking out order with Stripe");
      var result =
          await StripeHelper().makePaymentWithStripe(context, checkoutData);
      if (result == PaymentValidator.success) {
        log.wtf("Transaction completed \\\\\\\\\\");
        // clearCart();
        // NavigationService.navigatorKey.currentContext?.pop();
      } else if (result == PaymentValidator.cancelled) {
        log.wtf("Transaction cancelled |||||||||||");
        NavigationService.navigatorKey.currentContext?.pop();
      } else {
        log.w("/////////////");
      }
    }
    emit(state.copyWith(loading: false));
  }

  checkoutOutOfBoundOrder(BuildContext context) async {
    emit(state.copyWith(loading: true));
    List<CheckoutCartModel> checkoutCartList = [];
    for (var cartMeal in state.cartData!.products!) {
      CheckoutCartModel checkoutCart = CheckoutCartModel(
        productId: cartMeal.productData!.id,
        quantity: cartMeal.quantity,
      );
      checkoutCartList.add(checkoutCart);
    }

    String checkoutData;
    OutOfBoundCheckoutModel outOfBoundCheckoutData = OutOfBoundCheckoutModel(
      cart: checkoutCartList,
      deliveryInfo: OutOfBoundDeliveryInfo(
        firstName: Globals.fullname.split(" ")[0],
        lastName: Globals.fullname.split(" ")[1],
        email: Globals.email,
        phone: deliveryPhoneNumber,
        addr1: deliveryAddress!,
      ),
    );
    checkoutData = outOfBoundCheckoutModelToJson(outOfBoundCheckoutData);

    log.w("Out of Bound Checkout Data: $checkoutData");
    try {
      var createOrderResponse =
          await apiServices.createOutOfBoundOrder(checkoutData);

      if (createOrderResponse.toString() != "error") {
        log.wtf(
          "Successfully created OutOfBound order: ${createOrderResponse.toString()}",
        );
        OutOfBoundOrderResponseModel createdOrderData =
            outOfBoundOrderResponseModelFromJson(
          jsonEncode(
            createOrderResponse,
          ),
        );
        emit(state.copyWith(loading: false));

        log.wtf("createdOrderData: ${createdOrderData.toJson()}");
        await showOutOfBoundBottomSheet(
          context,
          orderId: createdOrderData.orderId.toUpperCase(),
          amount: createdOrderData.totalPrice.toDouble().toString(),
        );
        clearCart();
      } else {
        Fluttertoast.showToast(msg: "Errror creating order. Try again");
      }
    } catch (e) {
      log.w("Error: ${e.toString()}");
    }
    emit(state.copyWith(loading: false));
  }

  clearCart() async {
    var emptyCartResponse = await apiServices.emptyCart();

    if (emptyCartResponse.toString() == 'error') {
      log.w("Error emptying from cart");
    } else {
      log.wtf("Emptied cart");
      emit(state.copyWith(
        cartData: null,
        noCartItems: true,
      ));
    }
  }

  updateOrderPayment({
    required String orderID,
    required String paymentID,
  }) async {
    NavigationService.navigatorKey.currentContext
        ?.replace("/checkoutCompletePage");
    UpdateOrderPaymentModel updateOrderPaymentData = UpdateOrderPaymentModel(
      paymentId: paymentID,
    );

    var updateOrderPaymentResponse = await ApiServices().updateOrderPayment(
      orderId: orderID,
      paymentData: updateOrderPaymentModelToJson(updateOrderPaymentData),
    );
    if (updateOrderPaymentResponse.toString() == "error") {
      log.w("Unable to update order");
    } else {
      log.w("Updated order");
      clearCart();
    }
  }

  setDeliveryPhoneNumber(String phoneNumber) {
    deliveryPhoneNumber = phoneNumber;
    log.w("Set Delivery Phone Number: $deliveryPhoneNumber");
    saveDeliveryPhoneNumber(phoneNumber);
  }

  selectPaymentOption(PaymentOptions paymentOption) {
    emit(state.copyWith(selectedPaymentOption: paymentOption));
    log.wtf("Changed Payment Option: ${state.selectedPaymentOption?.name}");
  }

  selectCampus(CampusModel campus) {
    emit(state.copyWith(campuselected: campus));
    deliveryDistance = 0.0;
    log.wtf("Changed campus: ${state.campuselected?.name}");
  }

  bool shouldAddNewProduct(
      List<CartProduct>? existingProductItems, CartProduct newProductItem) {
    return !existingProductItems!.any(
      (existingMeal) =>
          existingMeal.productData?.id == newProductItem.productData?.id,
    );
  }

  addToLocalCart(EachMealModel feedData, int itemCount) async {
    try {
      final newBillTotal = (feedData.price ?? 0) * itemCount;
      CartDetailsModel? localCartData = await getLocalCart();
      final newProductToAdd = CartProduct(
        id: feedData.id,
        quantity: itemCount,
        price: feedData.price,
        productData: feedData,
      );
      if (localCartData == null || localCartData.products?.isEmpty == true) {
        localCartData = CartDetailsModel(
          id: '',
          customer: Customer(id: '', fullName: '', customerId: ''),
          bill: newBillTotal,
          products: [newProductToAdd],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      } else {
        List<CartProduct> cartProducts = localCartData.products ?? [];

        // If the item already exists in the cart, update the quantity. Else, add to list of products in cart
        if (cartProducts
            .any((existingItem) => existingItem.id == newProductToAdd.id)) {
          int indexOfExistingItem =
              cartProducts.indexWhere((obj) => obj.id == newProductToAdd.id);
          cartProducts[indexOfExistingItem] =
              cartProducts[indexOfExistingItem].copyWith(
            quantity: (cartProducts[indexOfExistingItem].quantity ?? 0) +
                (newProductToAdd.quantity ?? 0),
          );
        } else {
          cartProducts.add(newProductToAdd);
        }
        localCartData = localCartData.copyWith(products: cartProducts);
      }

      // Calculate and update total bill
      int totalBill = 0;
      for (int i = 0; i < (localCartData.products?.length ?? 0); i++) {
        totalBill += ((localCartData.products?[i].price ?? 0) *
            (localCartData.products?[i].quantity ?? 1));
      }
      log.w("Bill > new: $newBillTotal, total: $totalBill");

      localCartData.bill = totalBill;
      log.wtf("Updated localCartData: ${localCartData.toJson()}");
      updateLocalCart(cartDetailsModelToJson(localCartData));
      Fluttertoast.showToast(msg: "Added to cart");
    } catch (e) {
      log.e("Error adding to cart: ${e.toString()}");
      Fluttertoast.showToast(msg: "Error adding to cart.");
    }
  }

  addToOnlineCart(AddToCartModel feedData) async {
    var addToCartResponse = await apiServices.addToCart(
      addToCartModelToJson(feedData),
    );
    emit(state.copyWith(
      loading: false,
    ));

    if (addToCartResponse.toString() == 'error') {
      log.w("Error adding to cart");
      Fluttertoast.showToast(msg: "Error adding to cart.");
    } else {
      Fluttertoast.showToast(msg: "Added to cart");
      log.wtf("Added ${feedData.productId} to cart");
    }
  }

  updateLocalCartData(int newProductcount, int indexOfProductItem) async {
    try {
      emit(state.copyWith(loading: true, noCartItems: false));
      CartDetailsModel? localCartData = await getLocalCart();

      List<CartProduct> cartProducts = localCartData?.products ?? [];

      // Locate the item in local data and remove it with its index
      cartProducts[indexOfProductItem].quantity = newProductcount;
      final updatedCartData = localCartData?.copyWith(products: cartProducts);

      // Calculate and update total bill
      int totalBill = 0;
      for (int i = 0; i < (updatedCartData?.products?.length ?? 0); i++) {
        totalBill += ((updatedCartData?.products?[i].price ?? 0) *
            (updatedCartData?.products?[i].quantity ?? 1));
      }

      updatedCartData?.bill = totalBill;
      log.w("Total Bill: $totalBill  = ${updatedCartData?.bill}");

      emit(state.copyWith(loading: false, cartData: updatedCartData));
      updateLocalCart(cartDetailsModelToJson(updatedCartData!));
      await getLocalCartData(false);
    } catch (e) {
      log.e("Error updating item in cart: ${e.toString()}");
      Fluttertoast.showToast(msg: "Error updating item in cart.");
    }
  }

  updateOnlineCartData(AddToCartModel updatedCartData) async {
    await apiServices.addToCart(
      addToCartModelToJson(updatedCartData),
    );
    var getMyCartResponse = await apiServices.getMyCart();

    if (getMyCartResponse.toString() == "error") {
      log.w("Error fetching cart");
      emit(state.copyWith(loading: false));
    } else {
      log.wtf(
        "Successfully fetched cart: ${getMyCartResponse.toString()}",
      );
      var dataBody = getMyCartResponse;

      CartDetailsModel cartDetailsData = cartDetailsModelFromJson(
        jsonEncode(dataBody),
      );
      log.wtf("Total Cart Bill: ${cartDetailsData.bill}");

      emit(state.copyWith(
        noCartItems: false,
        cartData: cartDetailsData,
      ));
    }
  }

  deleteItemFromLocalCart(int indexOfProductItem) async {
    try {
      CartDetailsModel? currentCartData = await getLocalCart();

      List<CartProduct> cartProducts = currentCartData?.products ?? [];
      log.w("cartProducts: ${cartProducts.length}, index: $indexOfProductItem");

      // Locate the item in local data and remove it with its index
      final removedItem = cartProducts.removeAt(indexOfProductItem);
      log.w("Rem: ${removedItem.productData?.name} - ${cartProducts.length}");

      final updatedCartData = currentCartData?.copyWith(products: cartProducts);

      // Calculate and update total bill
      int totalBill = 0;
      for (int i = 0; i < (updatedCartData?.products?.length ?? 0); i++) {
        totalBill += ((updatedCartData?.products?[i].price ?? 0) *
            (updatedCartData?.products?[i].quantity ?? 1));
      }

      updatedCartData?.bill = totalBill;
      log.w("Total Bill: $totalBill  = ${updatedCartData?.bill}");
      emit(state.copyWith(
        cartData: updatedCartData,
        noCartItems: currentCartData?.products?.isEmpty == true,
      ));
      await updateLocalCart(cartDetailsModelToJson(updatedCartData!));
      await getLocalCartData(false);
    } catch (e) {
      log.e("Error removing item from cart: ${e.toString()}");
      Fluttertoast.showToast(msg: "Error removing item from cart.");
    }
  }

  deleteItemFromOnlineCart(String productId) async {
    var deleteFromCartResponse = await apiServices.removeFromCart(
      {"productId": productId},
    );

    if (deleteFromCartResponse.toString() == 'error') {
      log.w("Error removing from cart");
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        icon: Icons.error_outline,
        content: "Error removing from cart.",
      );
    } else {
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        icon: CupertinoIcons.check_mark_circled,
        content: "Removed from cart",
      );
      log.wtf("Removed $productId from cart");
      getOnlineCartData();
    }
  }

  buyNowForLoggedInUser(BuildContext context, AddToCartModel feedData) async {
    // Add to Cart, then go to Cart Page
    var addToCartResponse = await apiServices.addToCart(
      addToCartModelToJson(feedData),
    );
    emit(state.copyWith(loading: false));

    if (addToCartResponse.toString() == 'error') {
      log.w("Error adding to cart");
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        icon: Icons.error_outline,
        content: "Error adding to cart.",
      );
    } else {
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        icon: CupertinoIcons.check_mark_circled,
        content: "Added to cart",
      );
      log.wtf("Added ${feedData.productId} to cart");
      Provider.of<CurrentPage>(context, listen: false).setCurrentPageIndex(2);
      context.push('/cartPage');
    }
  }

  buyNowForGuest(
      BuildContext context, EachMealModel feedData, int count) async {
    await addToLocalCart(feedData, count);
    log.wtf("Added ${feedData.name} to local cart");

    Provider.of<CurrentPage>(context, listen: false).setCurrentPageIndex(2);
    context.push('/cartPage');
  }

  getLocalCartData(bool showLoadingScreen) async {
    emit(state.copyWith(
      loading: showLoadingScreen,
      noCartItems: true,
      cartData: null,
    ));
    try {
      CartDetailsModel? localCartData = await getLocalCart();
      await Future.delayed(const Duration(milliseconds: 200));
      log.w("localCartData: ${localCartData?.toJson()}");
      if (localCartData == null || localCartData.products?.isEmpty == true) {
        emit(state.copyWith(
          loading: false,
          noCartItems: true,
        ));
      } else {
        emit(state.copyWith(
          loading: false,
          noCartItems: false,
          cartData: localCartData,
        ));
      }
      log.wtf("state.cartData: ${state.cartData?.toJson()}");
    } catch (e) {
      log.e("Error getting local cart: ${e.toString()}");
      emit(state.copyWith(loading: false, cartData: null));
    }
    if (showLoadingScreen == true) {
      await getCampusList();
      getMyLocation();
    }
  }

  uploadLocalCartData() async {
    try {
      CartDetailsModel? localCartData = await getLocalCart();
      await Future.delayed(const Duration(milliseconds: 200));
      log.w("localCartData: ${localCartData?.toJson()}");
      if (localCartData == null || localCartData.products?.isEmpty == true) {
        log.w("No products in local cart");
      } else {
        final productsInLocalCart = localCartData.products ?? [];
        log.wtf("Found products in local cart: ${productsInLocalCart.length}");
        Fluttertoast.showToast(msg: 'Syncing carts');

        for (int i = 0; i < productsInLocalCart.length; i++) {
          AddToCartModel addToCartItem = AddToCartModel(
            productId: productsInLocalCart[i].id,
            quantity: productsInLocalCart[i].quantity,
          );
          await apiServices.addToCart(addToCartModelToJson(addToCartItem));
        }
        log.wtf('Successfully synced carts');
        Fluttertoast.showToast(msg: 'Successfully synced carts');
        clearLocalCart();
      }
    } catch (e) {
      log.e("Error uploading local cart: ${e.toString()}");
      Fluttertoast.showToast(msg: 'Unable to sync carts');
    }
  }

  getOnlineCartData() async {
    selectedCampusName = campusList[0].name;
    emit(state.copyWith(loading: true));

    // Check if items exist in local cart and sync with online cart
    await uploadLocalCartData();
    // Getting all cart
    var getMyCartResponse = await apiServices.getMyCart();

    if (getMyCartResponse.toString() == "error") {
      log.w("Error fetching cart");
      emit(state.copyWith(loading: false));
    } else if (getMyCartResponse.toString() == "[]") {
      log.w("No cart items yet");
      emit(state.copyWith(
        loading: false,
        noCartItems: true,
      ));
    } else {
      log.wtf(
        "Successfully fetched cart: ${getMyCartResponse.toString()}",
      );
      var dataBody = getMyCartResponse;

      CartDetailsModel cartDetailsData = cartDetailsModelFromJson(
        jsonEncode(dataBody),
      );
      log.wtf("Total Cart Bill: ${cartDetailsData.bill}");

      emit(state.copyWith(
        noCartItems: false,
        cartData: cartDetailsData,
      ));
    }
    log.w("Done: Cart Meals = ${state.cartData?.products?.length}");
    await getCampusList();
    getMyLocation();
  }

  getCampusList() async {
    emit(state.copyWith(loading: true));
    if (Globals.token == '') {
      Globals.token = await getSharedPrefsSavedString("savedToken");
    }
    // Getting campuses list
    var getCampusListResponse = await apiServices.getCampusList();

    List<CampusModel> campuses = [];

    if (getCampusListResponse.toString() == "error") {
      log.w("Error getting campuses");
      emit(state.copyWith(
        loading: false,
      ));
    } else {
      log.wtf(
        "Successfully fetched campuses: ${getCampusListResponse.toString()}",
      );
      var dataBody = getCampusListResponse;
      if (dataBody != null) {
        campuses = (dataBody)
            .map((i) => CampusModel.fromJson(i))
            .toList()
            .cast<CampusModel>();
      }
      log.wtf("Last campus: ${campuses.last.toJson()}");
    }

    emit(state.copyWith(
      loading: false,
    ));
    if (campusList.length <= 1) {
      campusList.addAll(campuses);
    }
    log.w("Done: Campuses = ${campuses.length}");
  }

  getMyLocation() async {
    LocationModel locationData;
    // Get my location data
    locationData = await LocationHelper().getCurrentLocation();
    Globals.myPostcode = locationData.postalCode ?? "";
    Globals.myCity = locationData.city ?? "";
    Globals.myCountry = locationData.country ?? "";
    emit(state.copyWith(myLocationData: locationData));
    log.wtf("My City: ${Globals.myCity}");
  }
}
