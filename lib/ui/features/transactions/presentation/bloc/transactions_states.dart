// ignore_for_file: must_be_immutable

import 'package:d818_mobile_app/app/models/campuses/campus_model.dart';
import 'package:d818_mobile_app/app/models/cart/cart_details_model.dart';
import 'package:d818_mobile_app/app/models/location/location_model.dart';
import 'package:d818_mobile_app/app/models/transactions/outofbounds_orders_model.dart';
import 'package:d818_mobile_app/app/models/transactions/regular_orders_model.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:equatable/equatable.dart';

class TransactionsState extends Equatable {
  TransactionsState({
    this.errorFetchingOrders = false,
    this.loading = true,
    this.noCartItems,
    this.noRegOrdersItems,
    this.noOobOrdersItems,
    this.cartData,
    this.selectedPaymentOption,
    this.campuselected,
    this.myLocationData,
    this.regularOrdersData,
    this.outOfBoundOrdersData,
  });

  bool? errorFetchingOrders,
      loading,
      noCartItems,
      noRegOrdersItems,
      noOobOrdersItems;
  CartDetailsModel? cartData;
  PaymentOptions? selectedPaymentOption;
  CampusModel? campuselected;
  LocationModel? myLocationData;
  List<RegularOrdersModel>? regularOrdersData;
  List<OutOfBoundsOrdersModel>? outOfBoundOrdersData;

  TransactionsState copyWith({
    bool? errorFetchingOrders,
    bool? loading,
    bool? noCartItems,
    bool? noRegOrdersItems,
    bool? noOobOrdersItems,
    CartDetailsModel? cartData,
    PaymentOptions? selectedPaymentOption,
    CampusModel? campuselected,
    LocationModel? myLocationData,
    List<RegularOrdersModel>? regularOrdersData,
    List<OutOfBoundsOrdersModel>? outOfBoundOrdersData,
  }) =>
      TransactionsState(
        loading: loading ?? this.loading,
        noCartItems: noCartItems ?? this.noCartItems,
        noRegOrdersItems: noRegOrdersItems ?? this.noRegOrdersItems,
        noOobOrdersItems: noOobOrdersItems ?? this.noOobOrdersItems,
        cartData: cartData ?? this.cartData,
        selectedPaymentOption:
            selectedPaymentOption ?? this.selectedPaymentOption,
        campuselected: campuselected ?? this.campuselected,
        myLocationData: myLocationData ?? this.myLocationData,
        errorFetchingOrders: errorFetchingOrders ?? this.errorFetchingOrders,
        regularOrdersData: regularOrdersData ?? this.regularOrdersData,
        outOfBoundOrdersData: outOfBoundOrdersData ?? this.outOfBoundOrdersData,
      );

  @override
  List<Object?> get props => [
        errorFetchingOrders,
        loading,
        noCartItems,
        noRegOrdersItems,
        noOobOrdersItems,
        cartData,
        selectedPaymentOption,
        campuselected,
        myLocationData,
        regularOrdersData,
        outOfBoundOrdersData,
      ];
}
