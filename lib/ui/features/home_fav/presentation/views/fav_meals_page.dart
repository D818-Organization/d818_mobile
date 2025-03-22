// ignore_for_file: depend_on_referenced_packages

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/helpers/sharedprefs_helper.dart';
import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_bloc.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_events.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_states.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/views/widgets/fav_meal_item_tile.dart';
import 'package:d818_mobile_app/ui/features/nav_bar/data/page_index_class.dart';
import 'package:d818_mobile_app/ui/features/nav_bar/presentation/custom_navbar.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/custom_textfield.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

var log = getLogger('FavWeeklyMenuPage');

class FavWeeklyMenuPage extends StatefulWidget {
  const FavWeeklyMenuPage({super.key});

  @override
  State<FavWeeklyMenuPage> createState() => _FavWeeklyMenuPageState();
}

class _FavWeeklyMenuPageState extends State<FavWeeklyMenuPage> {
  bool loading = true, swipeRight = false;
  late TextEditingController searchFavController;

  @override
  void initState() {
    super.initState();
    searchFavController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final HomepageBloc homeBloc = BlocProvider.of<HomepageBloc>(context);

    return ConditionalWillPopScope(
      onWillPop: () async {
        Provider.of<CurrentPage>(context, listen: false).setCurrentPageIndex(0);

        context.pop();
        return false;
      },
      shouldAddCallback: true,
      child: Scaffold(
        backgroundColor: AppColors.plainWhite,
        bottomNavigationBar: const CustomNavBar(currentPageIndx: 1),
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
          child: BlocBuilder<HomepageBloc, HomepageState>(
            bloc: homeBloc,
            builder: (context, state) {
              if (Globals.token == '') {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Favourite Menu",
                            style: AppStyles.boldHeaderStyle(20),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            Text(
                              "You can only add meals to favourite or see your favourite meals after you sign in.",
                              textAlign: TextAlign.center,
                              style: AppStyles.normalStringStyle(12),
                            ),
                            customVerticalSpacer(25),
                            CustomButton(
                              width: 120,
                              height: 40,
                              borderRadius: 15,
                              child: Text(
                                "Sign in",
                                style: AppStyles.commonStringStyle(15),
                              ),
                              onPressed: () {
                                log.w("To login screen");
                                saveScreenToGoAfterLogin('favWeeklyMenuPage');
                                context.push('/loginScreen');
                              },
                            ),
                          ],
                        ),
                      ),
                      customVerticalSpacer(1),
                    ],
                  ),
                );
              } else {
                return CustomScrollView(
                  physics: const ClampingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      floating: true,
                      snap: true,
                      automaticallyImplyLeading: false,
                      backgroundColor: AppColors.plainWhite,
                      expandedHeight: screenWidth(context) < 400 ? 60 : 75.0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          color: AppColors.plainWhite,
                          height: 60.0,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    size: 35,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                  Text(
                                    Globals.myCity == ""
                                        ? " "
                                        : state.myLocationString ?? "",
                                    style: AppStyles.headerStyle(
                                      13.1,
                                      color: AppColors.kPrimaryColor,
                                    ),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  InkWell(
                                    onTap: () {
                                      // Go to Profile here
                                      log.wtf("Go to Profile");
                                      context.push('/profilePage');
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.blueGray,
                                      radius: 20,
                                      child: const Icon(
                                        Icons.person_2_outlined,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              customVerticalSpacer(10),
                              state.isLoading == true
                                  ? const SizedBox.shrink()
                                  : SizedBox(
                                      width: screenWidth(context),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(11),
                                              ),
                                              child: CustomTextField(
                                                mainFillColor:
                                                    AppColors.lighterGrey,
                                                height: 40,
                                                textEditingController:
                                                    searchFavController,
                                                hintText: "Search meal",
                                                onChanged: (txt) {
                                                  if (txt.isNotEmpty) {
                                                    log.d("Searching . . .");
                                                    homeBloc.add(
                                                        SearchFavMeals(txt));
                                                  } else {
                                                    log.d("No text to search");
                                                    setState(() {});
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          customHorizontalSpacer(10),
                                          InkWell(
                                            onTap: () {
                                              // Go to Cart here
                                              log.wtf("Go to Cart");
                                              // Provider.of<CurrentPage>(context,
                                              //         listen: false)
                                              //     .setCurrentPageIndex(2);
                                              context.push('/cartPage');
                                            },
                                            child: Image.asset(
                                                "assets/cart_red.png"),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        physics: const ClampingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child:
                            // CHECK IF TEHERE'S SEARCH TEXT
                            searchFavController.text.trim().isNotEmpty == true
                                ? state.searchFavMeals!.isNotEmpty
                                    ? GridView.builder(
                                        physics: const ClampingScrollPhysics(),
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: state.searchFavMeals?.length,
                                        itemBuilder: (context, index) {
                                          EachMealModel mealData =
                                              EachMealModel(
                                            id: state.searchFavMeals![index]
                                                .productId?.id,
                                            name: state.searchFavMeals![index]
                                                .productId?.name,
                                            description: state
                                                .searchFavMeals![index]
                                                .productId
                                                ?.description,
                                            image: state.searchFavMeals![index]
                                                .productId?.image,
                                            price: state.searchFavMeals![index]
                                                .productId?.price,
                                          );
                                          return FavMealItemTile(
                                            mealData: mealData,
                                            removeFromListPressed: () {
                                              log.wtf("Remove From List");
                                              setState(() {
                                                homeBloc.add(
                                                  RemoveFromFavMeals(
                                                      mealData.id),
                                                );
                                              });
                                              log.w(
                                                  "Removed ${state.searchFavMeals?[index].productId?.name} from fav meals: ${state.searchFavMeals?.length}");
                                            },
                                          );
                                        },
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10,
                                          mainAxisExtent: 264,
                                        ),
                                      )
                                    : Center(
                                        child: Text(
                                          "No fav items found for \"${searchFavController.text.trim()}\"",
                                          style:
                                              AppStyles.normalStringStyle(14),
                                        ),
                                      )
                                // IF NO SEARCH TEXT
                                : Column(
                                    children: [
                                      customVerticalSpacer(10),
                                      Row(
                                        children: [
                                          Text(
                                            "Favourite Menu",
                                            style:
                                                AppStyles.boldHeaderStyle(20),
                                          ),
                                        ],
                                      ),
                                      customVerticalSpacer(10),
                                      state.favMealData?.products?.isNotEmpty ==
                                              true
                                          ? GridView.builder(
                                              physics:
                                                  const ClampingScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: state.favMealData
                                                  ?.products?.length,
                                              itemBuilder: (context, index) {
                                                EachMealModel mealData =
                                                    EachMealModel(
                                                  id: state
                                                      .favMealData!
                                                      .products![index]
                                                      .productId
                                                      ?.id,
                                                  name: state
                                                      .favMealData!
                                                      .products![index]
                                                      .productId
                                                      ?.name,
                                                  description: state
                                                      .favMealData!
                                                      .products![index]
                                                      .productId
                                                      ?.description,
                                                  image: state
                                                      .favMealData!
                                                      .products![index]
                                                      .productId
                                                      ?.image,
                                                  price: state
                                                      .favMealData!
                                                      .products![index]
                                                      .productId
                                                      ?.price,
                                                );
                                                return FavMealItemTile(
                                                  mealData: mealData,
                                                  removeFromListPressed: () {
                                                    log.wtf("Remove From List");
                                                    setState(() {
                                                      homeBloc.add(
                                                        RemoveFromFavMeals(
                                                            mealData.id),
                                                      );
                                                    });
                                                    log.w(
                                                        "Removed ${state.favMealData?.products?[index].productId?.name} from fav meals: ${state.favMealData?.products?.length}");
                                                  },
                                                );
                                              },
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 10,
                                                crossAxisSpacing: 10,
                                                mainAxisExtent: 264,
                                              ),
                                            )
                                          : Center(
                                              child: Text(
                                                "No meal added to favourites yet.",
                                                style:
                                                    AppStyles.normalStringStyle(
                                                        12),
                                              ),
                                            ),
                                      customVerticalSpacer(15),
                                    ],
                                  ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
