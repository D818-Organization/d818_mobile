import 'package:cached_network_image/cached_network_image.dart';
import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/views/meal_details_page.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_events.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:flutter/material.dart';

var log = getLogger('MealItemTile');

class MealItemTile extends StatefulWidget {
  final EachMealModel mealData;
  const MealItemTile({
    super.key,
    required this.mealData,
  });

  @override
  State<MealItemTile> createState() => _MealItemTileState();
}

class _MealItemTileState extends State<MealItemTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log.d("Pressed ${widget.mealData.name}");

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MealDetailsPage(
              fullMealData: widget.mealData,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(
          8.51,
        ),
        height: 274,
        width: 190,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.blueGray,
          ),
          color: AppColors.lighterGrey,
          borderRadius: BorderRadius.circular(6.1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 130,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.blueGray,
                ),
                borderRadius: BorderRadius.circular(6.1),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    widget.mealData.image ?? '',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            customVerticalSpacer(6.5),
            Text(
              widget.mealData.name ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppStyles.boldHeaderStyle(12.16),
            ),
            customVerticalSpacer(6.5),
            SizedBox(
              height: 42,
              child: Text(
                widget.mealData.description ?? '',
                softWrap: true,
                textAlign: TextAlign.center,
                style: AppStyles.normalStringStyle(8.52),
              ),
            ),
            customVerticalSpacer(6.5),
            Text(
              "£${widget.mealData.price ?? ''}",
              style: AppStyles.headerStyle(14.6),
            ),
            customVerticalSpacer(3.5),
            InkWell(
              onTap: () {
                TransactionsBloc transactionsBloc = TransactionsBloc();
                transactionsBloc.add(AddToCart(widget.mealData, 1));
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.blueGray,
                    ),
                    borderRadius: BorderRadius.circular(13.3),
                    color: AppColors.kPrimaryColor),
                height: 16.42,
                width: 72,
                child: Center(
                  child: Text(
                    "Add to Cart",
                    style: AppStyles.headerStyle(
                      6.6,
                      color: AppColors.plainWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
