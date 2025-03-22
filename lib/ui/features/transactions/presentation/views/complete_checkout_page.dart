import 'package:d818_mobile_app/app/models/cart/cart_details_model.dart';
import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/views/meal_details_page.dart';
import 'package:d818_mobile_app/ui/features/transactions/data/data.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_states.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

var log = getLogger('CheckoutCompletePage');

class CheckoutCompletePage extends StatefulWidget {
  const CheckoutCompletePage({super.key});

  @override
  State<CheckoutCompletePage> createState() => _CheckoutCompletePageState();
}

class _CheckoutCompletePageState extends State<CheckoutCompletePage> {
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
                    top: MediaQuery.of(context).viewPadding.top),
                color: AppColors.plainWhite.withOpacity(0.75),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.pop(),
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
                      "Checkout Completed",
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
                    _successCard(),
                    _orderCompleteSummaryCard(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _successCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 30),
      width: screenHeight(context),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppColors.lighterGrey,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            'assets/success.png',
            width: 69,
            height: 69,
          ),
          customVerticalSpacer(10),
          Text(
            "Checkout Completed",
            style: AppStyles.boldHeaderStyle(16),
          ),
          Text(
            "Your order is being processed.",
            style: AppStyles.normalStringStyle(12),
          ),
        ],
      ),
    );
  }

  Widget _orderCompleteSummaryCard() {
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
                  itemBuilder: (context, index) => OrderSummaryItemTile(
                    mealData: state.cartData!.products![index],
                  ),
                ),
              ),
              customVerticalSpacer(12),
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
              customVerticalSpacer(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery Address",
                    style: AppStyles.semiHeaderStyle(12.16, 1.2),
                    overflow: TextOverflow.ellipsis,
                  ),
                  customHorizontalSpacer(15),
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        selectedDelivery == deliveryList[0]
                            ? state.campuselected!.name!
                            : deliveryAddress!,
                        textAlign: TextAlign.end,
                        style: AppStyles.boldHeaderStyle(12.16),
                      ),
                    ),
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

class OrderSummaryItemTile extends StatefulWidget {
  final CartProduct mealData;
  const OrderSummaryItemTile({
    super.key,
    required this.mealData,
  });

  @override
  State<OrderSummaryItemTile> createState() => _OrderSummaryItemTileState();
}

class _OrderSummaryItemTileState extends State<OrderSummaryItemTile> {
  bool isSelected = false;
  int itemCount = 1;

  @override
  void initState() {
    super.initState();
    itemCount = widget.mealData.quantity ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        EachMealModel mealDetails = EachMealModel(
          id: widget.mealData.productData?.id,
          name: widget.mealData.productData?.name,
          description: widget.mealData.productData?.description,
          image: widget.mealData.productData?.image,
          price: widget.mealData.price,
          dateCreated: widget.mealData.productData?.dateCreated,
        );
        log.d("Pressed ${widget.mealData.productData?.name}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailsPage(
              fullMealData: mealDetails,
            ),
          ),
        );
      },
      child: Container(
        width: screenWidth(context),
        decoration: BoxDecoration(
          color: AppColors.lighterGrey,
          borderRadius: BorderRadius.circular(6.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8.51, top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidth(context) * 0.4,
                      child: Text(
                        "${widget.mealData.productData?.name}",
                        style: AppStyles.boldHeaderStyle(12.16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      "£${widget.mealData.price}",
                      style: AppStyles.headerStyle(16),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
