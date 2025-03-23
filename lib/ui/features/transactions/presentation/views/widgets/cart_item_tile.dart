import 'package:cached_network_image/cached_network_image.dart';
import 'package:d818_mobile_app/app/models/cart/add_to_cart_model.dart';
import 'package:d818_mobile_app/app/models/cart/cart_details_model.dart';
import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/views/meal_details_page.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_events.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var log = getLogger('CartItemTile');

class CartItemTile extends StatefulWidget {
  final CartProduct mealData;
  final int indexOfMealProduct;
  final int currentQuantity;

  const CartItemTile({
    super.key,
    required this.mealData,
    required this.indexOfMealProduct,
    required this.currentQuantity,
  });

  @override
  State<CartItemTile> createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  bool isSelected = false;
  int itemCount = 1;

  @override
  void initState() {
    super.initState();
    itemCount = widget.currentQuantity;
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
        height: 103,
        width: screenWidth(context),
        margin: const EdgeInsets.symmetric(vertical: 3),
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.blueGray,
          ),
          color: AppColors.lighterGrey,
          borderRadius: BorderRadius.circular(6.1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              width: 78,
              height: 78,
              margin: const EdgeInsets.symmetric(horizontal: 8.51, vertical: 8),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.mealData.productData?.image ?? '',
                  ),
                  fit: BoxFit.cover,
                ),
                color: AppColors.lighterGrey,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Expanded(
              child: Container(
                height: 78,
                margin: const EdgeInsets.only(right: 8.51, top: 8, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.mealData.productData?.name ?? '',
                      softWrap: true,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.boldHeaderStyle(12.16),
                    ),
                    customVerticalSpacer(2),
                    Text(
                      widget.mealData.productData?.description ?? '',
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppStyles.normalStringStyle(10),
                    ),
                    customVerticalSpacer(4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "£${widget.mealData.price ?? ''}",
                          style: AppStyles.headerStyle(16),
                        ),
                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.plainWhite,
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => setState(() {
                                        if (itemCount > 1) {
                                          itemCount--;
                                          CartProduct product = widget.mealData;
                                          AddToCartModel updateCartData =
                                              AddToCartModel(
                                            productId: product.productData!.id,
                                            quantity: itemCount,
                                          );
                                          BlocProvider.of<TransactionsBloc>(
                                                  context)
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
                                        AddToCartModel updateCartData =
                                            AddToCartModel(
                                          productId: product.productData!.id,
                                          quantity: itemCount,
                                        );
                                        BlocProvider.of<TransactionsBloc>(
                                                context)
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
                              customHorizontalSpacer(3),
                              InkWell(
                                onTap: () {
                                  BlocProvider.of<TransactionsBloc>(context)
                                      .add(
                                    DeleteItemFromCart(
                                      widget.mealData.productData!.id!,
                                      widget.indexOfMealProduct,
                                    ),
                                  );
                                },
                                child: const SizedBox(
                                  height: 30,
                                  width: 60,
                                  child: Icon(
                                    CupertinoIcons.delete_simple,
                                    size: 15.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
