// ignore_for_file: depend_on_referenced_packages

import 'package:cached_network_image/cached_network_image.dart';
import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/models/favourite/add_to_favs.dart';
import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';
import 'package:d818_mobile_app/app/models/review/create_review_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/app/services/snackbar_service.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_bloc.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_events.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_states.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/views/widgets/review_widget.dart';
import 'package:d818_mobile_app/ui/features/nav_bar/data/page_index_class.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_bloc.dart';
import 'package:d818_mobile_app/ui/features/transactions/presentation/bloc/transactions_events.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

var log = getLogger('MealDetailsPage');

class MealDetailsPage extends StatefulWidget {
  final EachMealModel fullMealData;
  const MealDetailsPage({
    super.key,
    required this.fullMealData,
  });

  @override
  State<MealDetailsPage> createState() => _MealDetailsPageState();
}

class _MealDetailsPageState extends State<MealDetailsPage> {
  int productItemCount = 1;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomepageBloc>(context).add(
      FetchReviewsForMeals(widget.fullMealData.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    final HomepageBloc homeBloc = BlocProvider.of<HomepageBloc>(context);

    return Scaffold(
      backgroundColor: AppColors.plainWhite,
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size(screenWidth(context), 40),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          color: AppColors.plainWhite.withValues(alpha: 0.75),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Provider.of<CurrentPage>(context, listen: false)
                      .setCurrentPageIndex(0);
                  Navigator.pop(context);
                },
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
                "Details",
                style: AppStyles.boldHeaderStyle(16),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<HomepageBloc, HomepageState>(
          bloc: homeBloc,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  customVerticalSpacer(50),
                  Container(
                    width: screenHeight(context),
                    height: 299,
                    decoration: BoxDecoration(
                      color: AppColors.amber,
                      borderRadius: BorderRadius.circular(6.15),
                      image: DecorationImage(
                        image: CachedNetworkImageProvider(
                          widget.fullMealData.image ?? '',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  customVerticalSpacer(15),
                  Text(
                    widget.fullMealData.name ?? '',
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: "FrederickatheGreat",
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  customVerticalSpacer(8.5),
                  SizedBox(
                    child: Text(
                      widget.fullMealData.description ?? '',
                      softWrap: true,
                      textAlign: TextAlign.start,
                      style: AppStyles.normalStringStyle(14),
                    ),
                  ),
                  customVerticalSpacer(16),
                  state.isLoading == true
                      ? SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.kPrimaryColor,
                          ),
                        )
                      : state.isLoading == false &&
                              state.customerReviews?.isNotEmpty == true
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3.5),
                                  child: RatingBar.builder(
                                    initialRating: state.averageRating!,
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
                                ),
                                customHorizontalSpacer(15),
                                Text(
                                  "${state.customerReviews?.length} Reviews",
                                  style: AppStyles.normalStringStyle(12,
                                      lineHeight: 1),
                                ),
                                customHorizontalSpacer(15),
                                Globals.token == ''
                                    ? const SizedBox.shrink()
                                    : InkWell(
                                        onTap: () {
                                          log.d("Add review");
                                          showAddReviewDialog(context);
                                        },
                                        child: Text(
                                          "Add Your Review",
                                          style: AppStyles.normalStringStyle(12,
                                              lineHeight: 1),
                                        ),
                                      ),
                              ],
                            )
                          : state.noReviewsYet == true
                              ? Row(
                                  children: [
                                    Text(
                                      "No ratings yet",
                                      style: AppStyles.normalStringStyle(
                                        12.4,
                                        color: AppColors.regularGrey,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Text(
                                      "Unable to load ratings.",
                                      style: AppStyles.normalStringStyle(
                                        12.4,
                                        color: AppColors.coolRed,
                                      ),
                                    ),
                                  ],
                                ),
                  customVerticalSpacer(10),
                  Row(
                    children: [
                      Text(
                        "£${widget.fullMealData.price ?? ''}",
                        style: AppStyles.coloredSemiHeaderStyle(
                          28.15,
                          AppColors.kPrimaryColor,
                        ),
                      ),
                      customHorizontalSpacer(25),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => setState(() {
                              productItemCount++;
                            }),
                            child: const SizedBox(
                              height: 30,
                              width: 30,
                              child: Icon(
                                CupertinoIcons.add_circled_solid,
                                size: 15.4,
                              ),
                            ),
                          ),
                          SizedBox(
                            // width: 20,
                            child: Text(
                              "$productItemCount",
                              textAlign: TextAlign.center,
                              style: AppStyles.commonStringStyle(
                                24.5,
                                color: AppColors.fullBlack,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => setState(() {
                              if (productItemCount > 1) {
                                productItemCount--;
                              }
                            }),
                            child: const SizedBox(
                              height: 30,
                              width: 30,
                              child: Icon(
                                CupertinoIcons.minus_circle_fill,
                                size: 15.4,
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  customVerticalSpacer(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        onPressed: () {
                          TransactionsBloc transactionsBloc =
                              TransactionsBloc();
                          transactionsBloc.add(
                            AddToCart(widget.fullMealData, productItemCount),
                          );
                        },
                        width: screenWidth(context) * 0.44,
                        height: 42,
                        borderRadius: 30,
                        color: AppColors.lighterGrey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add To Cart",
                              style: AppStyles.coloredSemiHeaderStyle(
                                16,
                                AppColors.fullBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomButton(
                        // Buy now
                        onPressed: () async {
                          BlocProvider.of<TransactionsBloc>(context).add(
                            BuyNow(
                              context,
                              widget.fullMealData,
                              productItemCount,
                            ),
                          );
                        },
                        width: screenWidth(context) * 0.44,
                        height: 42,
                        borderRadius: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Buy Now",
                              style: AppStyles.coloredSemiHeaderStyle(
                                16,
                                AppColors.plainWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  customVerticalSpacer(15),
                  InkWell(
                    onTap: () {
                      if (Globals.token == '') {
                        showCustomSnackBar(
                          context,
                          content: "Login required. Tap to log in",
                          actionLabel: 'Log in',
                          actionTextColor: AppColors.coolRed,
                          duration: 5,
                          onpressed: () {
                            log.w("Login tapped");
                            context.push('/loginScreen');
                          },
                        );
                      } else {
                        AddToFavouriteModel addtoFavData = AddToFavouriteModel(
                          productId: widget.fullMealData.id,
                        );
                        homeBloc.add(
                          AddToFavMeals(addtoFavData),
                        );
                        log.wtf(
                            "Added ${widget.fullMealData.name} to fav meals");
                      }
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.add,
                          size: 15,
                          color: AppColors.darkGrey,
                        ),
                        Text(
                          "  Add to favourite meals",
                          style: AppStyles.normalStringStyle(
                            12.4,
                            color: AppColors.darkGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  customVerticalSpacer(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Reviews",
                        style: AppStyles.coloredSemiHeaderStyle(
                          14.63,
                          AppColors.kPrimaryColor,
                        ),
                      ),
                      Globals.token == ''
                          ? const SizedBox.shrink()
                          : InkWell(
                              onTap: () {
                                log.d("Add review");
                                showAddReviewDialog(context);
                              },
                              child: Text(
                                "Add Your Review",
                                style: AppStyles.normalStringStyle(
                                  12,
                                  color: AppColors.darkGrey,
                                ),
                              ),
                            ),
                    ],
                  ),
                  customVerticalSpacer(14),
                  state.isLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: AppColors.kPrimaryColor,
                          ),
                        )
                      : state.customerReviews?.isNotEmpty == true
                          ? ListView.builder(
                              physics: const ClampingScrollPhysics(),
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemCount: state.customerReviews?.length,
                              itemBuilder: (context, index) => ReviewWidget(
                                reviewData: state.customerReviews![index],
                              ),
                            )
                          : state.noReviewsYet == true
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "No reviews yet",
                                      style: AppStyles.normalStringStyle(
                                        12,
                                        color: AppColors.regularGrey,
                                      ),
                                    ),
                                  ],
                                )
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customVerticalSpacer(10),
                                    Text(
                                      "Unable to load reviews",
                                      style: AppStyles.normalStringStyle(
                                        12,
                                        color: AppColors.regularGrey,
                                      ),
                                    ),
                                    CustomButton(
                                      width: screenWidth(context) * 0.22,
                                      height: 35,
                                      borderRadius: 18,
                                      onPressed: () {
                                        homeBloc.add(
                                          FetchReviewsForMeals(
                                            widget.fullMealData.id,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Reload",
                                        style: AppStyles.coloredSemiHeaderStyle(
                                          14,
                                          AppColors.plainWhite,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                  customVerticalSpacer(20),
                ],
              ),
            );
          }),
    );
  }

  showAddReviewDialog(
    BuildContext dialogContext,
  ) {
    final HomepageBloc homeBloc = BlocProvider.of<HomepageBloc>(context);
    TextEditingController commentController = TextEditingController();
    int userRating = 0;
    String formValidatorString = '';

    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlocBuilder<HomepageBloc, HomepageState>(
            bloc: homeBloc,
            builder: (context, state) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Dialog(
                    backgroundColor: AppColors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(36),
                        ),
                        color: AppColors.plainWhite,
                      ),
                      width: screenSize(context).width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Add Review",
                            textAlign: TextAlign.center,
                            style: AppStyles.semiHeaderStyle(16, 1.5),
                          ),
                          customVerticalSpacer(6),
                          Text(
                            "Create your review here",
                            textAlign: TextAlign.center,
                            style: AppStyles.commonStringStyle(
                              13,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          customVerticalSpacer(12),
                          RatingBar(
                            initialRating: 0,
                            maxRating: 5,
                            glowColor: AppColors.amber,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            ratingWidget: RatingWidget(
                              full: Icon(
                                Icons.star_rounded,
                                color: AppColors.amber,
                                size: 17.85,
                              ),
                              half: Icon(
                                Icons.star_rounded,
                                color: AppColors.lightGrey,
                                size: 17.85,
                              ),
                              empty: Icon(
                                Icons.star_rounded,
                                color: AppColors.lightGrey,
                                size: 17.85,
                              ),
                            ),
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 0.0),
                            onRatingUpdate: (rating) {
                              userRating = rating.toInt();
                              log.w(userRating);
                            },
                          ),
                          customVerticalSpacer(10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.lighterGrey,
                            ),
                            width: screenWidth(context) * 0.9,
                            child: TextField(
                              controller: commentController,
                              maxLines: 3,
                              minLines: 1,
                              style: AppStyles.inputStringStyle(AppColors
                                      .fullBlack
                                      .withValues(alpha: 0.9))
                                  .copyWith(
                                letterSpacing: 0.8,
                              ),
                              decoration: InputDecoration(
                                fillColor: AppColors.plainWhite,
                                hintText: "Add Review",
                                hintStyle: AppStyles.hintStringStyle(12),
                                border: InputBorder.none,
                              ),
                              onTap: () {
                                log.wtf("Tapped textfield");
                              },
                            ),
                          ),
                          customVerticalSpacer(20),
                          Text(
                            formValidatorString,
                            textAlign: TextAlign.center,
                            style: AppStyles.commonStringStyle(
                              12,
                              color: AppColors.coolRed,
                            ),
                          ),
                          customVerticalSpacer(5),
                          CustomButton(
                            width: screenSize(context).width * 0.3,
                            height: 40,
                            borderRadius: 23,
                            onPressed: () {
                              if (commentController.text.trim().isNotEmpty ==
                                      true &&
                                  userRating > 0) {
                                CreateReviewModel reviewData =
                                    CreateReviewModel(
                                  product: widget.fullMealData.id,
                                  rating: userRating,
                                  comment: commentController.text.trim(),
                                );
                                Navigator.pop(context);
                                homeBloc.add(CreateReview(reviewData));
                              } else {
                                setState(
                                  () {
                                    formValidatorString =
                                        "Select rating and type your comments";
                                  },
                                );
                              }
                            },
                            color: AppColors.kPrimaryColor,
                            child: Text(
                              'Add Review',
                              style: AppStyles.coloredSemiHeaderStyle(
                                14,
                                AppColors.plainWhite,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            });
      },
    );
  }
}
