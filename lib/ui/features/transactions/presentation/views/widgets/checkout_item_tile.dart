import 'package:d818_mobile_app/app/models/cart/add_to_cart_model.dart';
import 'package:d818_mobile_app/app/models/cart/cart_details_model.dart';
import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/views/meal_details_page.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_events.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var log = getLogger('CheckoutItemTile');

class CheckoutItemTile extends StatefulWidget {
  final CartProduct mealData;
  final int indexOfMealProduct;
  const CheckoutItemTile({
    super.key,
    required this.mealData,
    required this.indexOfMealProduct,
  });

  @override
  State<CheckoutItemTile> createState() => _CheckoutItemTileState();
}

class _CheckoutItemTileState extends State<CheckoutItemTile> {
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
          // category: widget.mealData.category,
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: AppColors.transparent,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () => setState(() {
                              if (itemCount > 1) {
                                itemCount--;
                                CartProduct product = widget.mealData;
                                AddToCartModel updateCartData = AddToCartModel(
                                  productId: product.productData!.id,
                                  quantity: itemCount,
                                );
                                BlocProvider.of<TransactionsBloc>(context)
                                    .add(UpdateCart(
                                  updateCartData,
                                  widget.indexOfMealProduct,
                                ));
                              }
                            }),
                            child: const SizedBox(
                              height: 30,
                              width: 30,
                              child: Icon(
                                CupertinoIcons.minus_circle,
                                size: 15.4,
                              ),
                            ),
                          ),
                          SizedBox(
                            child: Text(
                              "$itemCount",
                              textAlign: TextAlign.center,
                              style: AppStyles.commonStringStyle(
                                14.5,
                                color: AppColors.fullBlack,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() {
                              itemCount++;
                              CartProduct product = widget.mealData;
                              AddToCartModel updateCartData = AddToCartModel(
                                productId: product.productData!.id,
                                quantity: itemCount,
                              );
                              BlocProvider.of<TransactionsBloc>(context)
                                  .add(UpdateCart(
                                updateCartData,
                                widget.indexOfMealProduct,
                              ));
                            }),
                            child: const SizedBox(
                              height: 30,
                              width: 30,
                              child: Icon(
                                CupertinoIcons.add_circled,
                                size: 15.4,
                              ),
                            ),
                          ),
                        ],
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
