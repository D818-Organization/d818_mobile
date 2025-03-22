import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_events.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_states.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/views/widgets/checkout_item_tile.dart';
import 'package:d818_mobile_app/ui/shared/shared_res/extensions/string_ext.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/app_constants/constants.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

var log = getLogger('CheckoutPage');

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<String> iconsImages = [
    'assets/stripe.png',
    'assets/paypal.png',
    // 'assets/google.png',
    // 'assets/apple.png',
  ];

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TransactionsBloc transactionsBloc =
        BlocProvider.of<TransactionsBloc>(context);

    return BlocBuilder<TransactionsBloc, TransactionsState>(
      bloc: transactionsBloc,
      builder: (context, state) {
        return GestureDetector(
          onTap: () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
          child: Scaffold(
            backgroundColor: AppColors.plainWhite,
            appBar: PreferredSize(
              preferredSize: Size(screenWidth(context), 40),
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).viewPadding.top,
                ),
                color: AppColors.plainWhite.withOpacity(0.75),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.only(left: 8, right: 10),
                        height: 40,
                        child: Icon(
                          Icons.chevron_left_rounded,
                          color: AppColors.fullBlack,
                          size: 30,
                        ),
                      ),
                    ),
                    Text(
                      "Checkout",
                      style: AppStyles.boldHeaderStyle(16),
                    ),
                  ],
                ),
              ),
            ),
            body: SizedBox(
              width: screenWidth(context),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    customVerticalSpacer(8),
                    _paymentOptionsCard(),
                    customVerticalSpacer(20),
                    _orderSummaryCard(),
                  ],
                ),
              ),
            ),
            floatingActionButton:
                state.noCartItems == true || state.selectedPaymentOption == null
                    ? const SizedBox.shrink()
                    : state.loading == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.coolRed,
                              strokeWidth: 3,
                            ),
                          )
                        : InkWell(
                            onTap: () {
                              // Check out
                              log.w("Checking out order");
                              transactionsBloc.add(CheckoutOrder(context));
                            },
                            child: Container(
                              width: screenWidth(context) * 0.6,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.kPrimaryColor,
                                borderRadius: BorderRadius.circular(38),
                              ),
                              child: Text(
                                "Order",
                                textAlign: TextAlign.center,
                                style: AppStyles.coloredSemiHeaderStyle(
                                  18,
                                  AppColors.plainWhite,
                                ),
                              ),
                            ),
                          ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          ),
        );
      },
    );
  }

  Widget _paymentOptionsCard() {
    final TransactionsBloc transactionsBloc =
        BlocProvider.of<TransactionsBloc>(context);
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      bloc: transactionsBloc,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColors.lighterGrey,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment",
                style: AppStyles.headerStyle(16),
              ),
              customVerticalSpacer(8),
              Text(
                "Choose payment option",
                style:
                    AppStyles.normalStringStyle(14, color: AppColors.fullBlack),
              ),
              customVerticalSpacer(20),
              SizedBox(
                height: 46,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    mainAxisExtent: 46,
                  ),
                  itemCount: PaymentOptions.values.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        transactionsBloc.add(SelectPaymentOption(
                          PaymentOptions.values[index],
                        ));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.plainWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: state.selectedPaymentOption?.index == index
                                ? AppColors.kPrimaryColor
                                : AppColors.lighterGrey,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: 20,
                              child: Image.asset(
                                iconsImages[index],
                              ),
                            ),
                            Text(
                              PaymentOptions.values[index].name.toSentenceCase(),
                              style: AppStyles.semiHeaderStyle(
                                16,
                                1,
                              ),
                            ),
                            CircleAvatar(
                              radius: 6,
                              backgroundColor:
                                  state.selectedPaymentOption?.index == index
                                      ? AppColors.kPrimaryColor
                                      : AppColors.lighterGrey,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _orderSummaryCard() {
    final TransactionsBloc transactionsBloc =
        BlocProvider.of<TransactionsBloc>(context);
    return BlocBuilder<TransactionsBloc, TransactionsState>(
      bloc: transactionsBloc,
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: AppColors.lighterGrey,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Order",
                style: AppStyles.headerStyle(16),
              ),
              customVerticalSpacer(20),
              SizedBox(
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: state.cartData?.products?.length,
                  itemBuilder: (context, index) => CheckoutItemTile(
                    mealData: state.cartData!.products![index],
                    indexOfMealProduct: index,
                  ),
                ),
              ),
              customVerticalSpacer(30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total: ",
                    style: AppStyles.boldHeaderStyle(20),
                  ),
                  Text(
                    " £${state.cartData?.bill}",
                    style: AppStyles.boldHeaderStyle(20),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

showOutOfBoundBottomSheet(
  BuildContext context, {
  required String orderId,
  required String amount,
}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.amber,
    isDismissible: false,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(26),
    ),
    builder: (context) {
      return Material(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 390,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26),
              topRight: Radius.circular(26),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You are out of our delivery range.",
                style: AppStyles.boldHeaderStyle(16),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                decoration: BoxDecoration(
                  color: AppColors.lighterGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "Call this number to complete your order:",
                      style: AppStyles.semiHeaderStyle(12.26, 1.2),
                    ),
                    customVerticalSpacer(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.blueGray,
                          child: IconButton(
                            onPressed: () async {
                              final Uri phoneUri =
                                  Uri(scheme: 'tel', path: orderPhoneNumber);
                              if (await canLaunchUrl(phoneUri)) {
                                await launchUrl(phoneUri);
                              } else {
                                // Handle the error - perhaps the user doesn't have a dialer app
                                throw 'Could not launch $phoneUri';
                              }
                            },
                            icon: const Icon(
                              CupertinoIcons.phone,
                            ),
                          ),
                        ),
                        customHorizontalSpacer(10),
                        SelectableText(
                          orderPhoneNumber,
                          style: AppStyles.boldHeaderStyle(20),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Your order ID is:  ",
                    style: AppStyles.semiHeaderStyle(12.26, 1.2),
                  ),
                  SelectableText(
                    orderId,
                    style: AppStyles.boldHeaderStyle(16),
                  ),
                ],
              ),
              customVerticalSpacer(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Total amount:  ",
                    style: AppStyles.semiHeaderStyle(12.26, 1.2),
                  ),
                  SelectableText(
                    "£$amount",
                    style: AppStyles.boldHeaderStyle(16),
                  ),
                ],
              ),
              customVerticalSpacer(30),
              CustomButton(
                color: AppColors.plainWhite,
                borderColor: AppColors.lightGrey,
                borderRadius: 20,
                width: screenWidth(context) * 0.3,
                height: 50,
                child: Text(
                  "OK",
                  style: AppStyles.headerStyle(
                    20,
                    color: AppColors.coolRed,
                  ),
                ),
                onPressed: () {
                  context.pop();
                  if (context.canPop() == true) {
                    context.pop();
                  }
                },
              ),
              customVerticalSpacer(8),
            ],
          ),
        ),
      );
    },
  ).whenComplete(
    () => log.w(" &&&&&&&&&&&&&& closed bottom sheet "),
  );
}
