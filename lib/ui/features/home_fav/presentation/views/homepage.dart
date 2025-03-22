// ignore_for_file: depend_on_referenced_packages

import 'package:cupertino_will_pop_scope/cupertino_will_pop_scope.dart';
import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/helpers/sharedprefs_helper.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_bloc.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_events.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_states.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/views/widgets/meal_item_tile.dart';
import 'package:d818_mobile_app/ui/features/nav_bar/data/page_index_class.dart';
import 'package:d818_mobile_app/ui/features/nav_bar/presentation/custom_navbar.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/buttons/custom_button.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/custom_textfield.dart';
import 'package:d818_mobile_app/ui/shared/shared_widgets/spacer.dart';
import 'package:d818_mobile_app/utils/app_constants/app_colors.dart';
import 'package:d818_mobile_app/utils/app_constants/app_styles.dart';
import 'package:d818_mobile_app/utils/screen_util/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

var log = getLogger('HomePage');

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController searchController;
  @override
  void initState() {
    super.initState();
    saveSharedPrefsStringValue(stringKey: "notFirstTime", stringValue: 'true');
    BlocProvider.of<HomepageBloc>(context).add(GetAllMeals());
    searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final HomepageBloc homeBloc = BlocProvider.of<HomepageBloc>(context);

    return ConditionalWillPopScope(
      onWillPop: () async {
        if (Provider.of<CurrentPage>(context, listen: false).currentPageIndex ==
            0) {
          log.w("Do nothing");
        } else {
          Provider.of<CurrentPage>(context, listen: false)
              .setCurrentPageIndex(0);
          context.pop();
        }

        return false;
      },
      shouldAddCallback: true,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: AppColors.plainWhite,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.plainWhite,
        ),
        child: Scaffold(
          backgroundColor: AppColors.plainWhite,
          bottomNavigationBar: const CustomNavBar(currentPageIndx: 0),
          body: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
            child: BlocBuilder<HomepageBloc, HomepageState>(
                bloc: homeBloc,
                builder: (context, state) {
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
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Expanded(child: SizedBox()),
                                    customHorizontalSpacer(10),
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
                                                padding:
                                                    const EdgeInsets.all(0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(11),
                                                ),
                                                child: CustomTextField(
                                                  mainFillColor:
                                                      AppColors.lighterGrey,
                                                  textEditingController:
                                                      searchController,
                                                  height: 40,
                                                  hintText: "Search meal",
                                                  onChanged: (txt) {
                                                    if (txt.isNotEmpty) {
                                                      log.d("Searching . . .");
                                                      homeBloc.add(
                                                          SearchForMeals(txt));
                                                    } else {
                                                      log.d(
                                                          "No text to search");
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
                              searchController.text.trim().isNotEmpty == true
                                  // ? state.searchMeals != null &&
                                  //         state.searchMeals != []
                                  ? state.searchMeals!.isNotEmpty
                                      ? GridView.builder(
                                          physics:
                                              const ClampingScrollPhysics(),
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount: state.searchMeals?.length,
                                          itemBuilder: (context, index) =>
                                              MealItemTile(
                                            mealData: state.searchMeals![index],
                                          ),
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
                                            "No items found for \"${searchController.text.trim()}\"",
                                            style:
                                                AppStyles.normalStringStyle(14),
                                          ),
                                        )
                                  // IF NO SEARCH TEXT
                                  : Column(
                                      children: [
                                        Container(
                                          height: 168,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                "assets/food_banner.png",
                                              ),
                                            ),
                                          ),
                                        ),
                                        customVerticalSpacer(10),
                                        Row(
                                          children: [
                                            Text(
                                              "Recommended",
                                              style:
                                                  AppStyles.boldHeaderStyle(20),
                                            ),
                                          ],
                                        ),
                                        customVerticalSpacer(10),
                                        state.isLoading == true
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  strokeWidth: 3,
                                                  color:
                                                      AppColors.kPrimaryColor,
                                                ),
                                              )
                                            : state.isLoading == false &&
                                                    (state.meals != null &&
                                                        state.meals != [])
                                                ? GridView.builder(
                                                    physics:
                                                        const ClampingScrollPhysics(),
                                                    padding: EdgeInsets.zero,
                                                    shrinkWrap: true,
                                                    itemCount:
                                                        state.meals?.length,
                                                    itemBuilder:
                                                        (context, index) =>
                                                            MealItemTile(
                                                      mealData:
                                                          state.meals![index],
                                                    ),
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      mainAxisSpacing: 10,
                                                      crossAxisSpacing: 10,
                                                      mainAxisExtent: 264,
                                                    ),
                                                  )
                                                // : SizedBox(),
                                                : Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "Error loading meals!",
                                                          style: AppStyles
                                                              .commonStringStyle(
                                                            14,
                                                            color: AppColors
                                                                .kPrimaryColor,
                                                          ),
                                                        ),
                                                        customVerticalSpacer(
                                                            20),
                                                        CustomButton(
                                                          width: screenWidth(
                                                                  context) *
                                                              0.4,
                                                          height: 45,
                                                          onPressed: () {
                                                            homeBloc.add(
                                                              GetAllMeals(),
                                                            );
                                                          },
                                                          child: Text(
                                                            "Retry",
                                                            style: AppStyles
                                                                .coloredSemiHeaderStyle(
                                                              16,
                                                              AppColors
                                                                  .plainWhite,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                        customVerticalSpacer(15),
                                      ],
                                    ),
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ),
      ),
    );
  }
}
