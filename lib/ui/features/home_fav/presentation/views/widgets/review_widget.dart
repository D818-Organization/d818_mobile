// ignore_for_file: depend_on_referenced_packages

import 'package:d818_mobile_app/app/models/review/customer_review_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

var log = getLogger('MealDetailsPage');

class ReviewWidget extends StatefulWidget {
  final CustomerReviewModel reviewData;
  const ReviewWidget({super.key, required this.reviewData});

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context) * 0.9,
      padding: const EdgeInsets.all(13),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.lighterGrey,
        borderRadius: BorderRadius.circular(7.31),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.reviewData.customer?.fullName ?? '',
                style: AppStyles.coloredSemiHeaderStyle(
                  16,
                  AppColors.fullBlack,
                ),
              ),
              RatingBar.builder(
                initialRating:
                    widget.reviewData.rating?.toDouble() ?? 1.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 18,
                itemBuilder: (context, _) => Icon(
                  Icons.star_rounded,
                  color: AppColors.amber,
                  size: 17.85,
                ),
                onRatingUpdate: (rating) {
                  log.w("Rating: $rating");
                },
              ),
            ],
          ),
          customVerticalSpacer(4),
          Text(
            widget.reviewData.comment ?? '',
            style: AppStyles.normalStringStyle(
              10.9,
              lineHeight: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}
