import 'package:d818_mobile_app/app/models/campuses/campus_model.dart';
import 'package:d818_mobile_app/app/models/cart/add_to_cart_model.dart';
import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TransactionsBlocEvent extends Equatable {}

class GetCartData extends TransactionsBlocEvent {
  @override
  List<Object?> get props => [];
}

class AddToCart extends TransactionsBlocEvent {
  final EachMealModel mealData;
  final int productItemCount;

  AddToCart(this.mealData, this.productItemCount);

  @override
  List<Object?> get props => [mealData, productItemCount];
}

class UpdateCart extends TransactionsBlocEvent {
  final AddToCartModel updateCartData;
  final int productIndex;

  UpdateCart(this.updateCartData, this.productIndex);

  @override
  List<Object?> get props => [updateCartData, productIndex];
}

class DeleteItemFromCart extends TransactionsBlocEvent {
  final String productId;
  final int productIndex;

  DeleteItemFromCart(this.productId, this.productIndex);

  @override
  List<Object?> get props => [productId, productIndex];
}

class BuyNow extends TransactionsBlocEvent {
  final BuildContext context;
  final EachMealModel feedData;
  final int productItemCount;

  BuyNow(this.context, this.feedData, this.productItemCount);

  @override
  List<Object?> get props => [context, feedData, productItemCount];
}

class SelectCampus extends TransactionsBlocEvent {
  final CampusModel campus;

  SelectCampus(this.campus);

  @override
  List<Object?> get props => [campus];
}

class SelectPaymentOption extends TransactionsBlocEvent {
  final PaymentOptions paymentOption;

  SelectPaymentOption(this.paymentOption);

  @override
  List<Object?> get props => [paymentOption];
}

class CheckoutOrder extends TransactionsBlocEvent {
  final BuildContext context;

  CheckoutOrder(this.context);

  @override
  List<Object?> get props => [context];
}

class UpdateOrderPayment extends TransactionsBlocEvent {
  final String orderId, paymentId;

  UpdateOrderPayment(this.orderId, this.paymentId);

  @override
  List<Object?> get props => [orderId, paymentId];
}

class SetDeliveryPhoneNumber extends TransactionsBlocEvent {
  final String phoneNumber;

  SetDeliveryPhoneNumber(this.phoneNumber);

  @override
  List<Object?> get props => [phoneNumber];
}

class FetchAllOrdersData extends TransactionsBlocEvent {
  @override
  List<Object?> get props => [];
}

class ClearCart extends TransactionsBlocEvent {
  @override
  List<Object?> get props => [];
}
