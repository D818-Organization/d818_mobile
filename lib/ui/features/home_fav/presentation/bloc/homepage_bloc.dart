// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'dart:convert';

import 'package:d818_mobile_app/app/helpers/globals.dart';
import 'package:d818_mobile_app/app/helpers/location_helper.dart';
import 'package:d818_mobile_app/app/helpers/sharedprefs_helper.dart';
import 'package:d818_mobile_app/app/models/favourite/add_to_favs.dart';
import 'package:d818_mobile_app/app/models/favourite/get_my_favs.dart';
import 'package:d818_mobile_app/app/models/location/location_model.dart';
import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';
import 'package:d818_mobile_app/app/models/review/create_review_model.dart';
import 'package:d818_mobile_app/app/models/review/customer_review_model.dart';
import 'package:d818_mobile_app/app/resources/app.logger.dart';
import 'package:d818_mobile_app/app/services/api_services/api_services.dart';
import 'package:d818_mobile_app/app/services/navigation_service.dart';
import 'package:d818_mobile_app/app/services/snackbar_service.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_events.dart';
import 'package:d818_mobile_app/ui/features/home_fav/presentation/bloc/homepage_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var log = getLogger('Home_bloc');

class HomepageBloc extends Bloc<HomepageBlocEvent, HomepageState> {
  ApiServices apiServices = ApiServices();
  HomepageBloc() : super(HomepageState()) {
    on<GetAllMeals>((event, emit) async {
      await getAllMeals();
    });

    on<CreateReview>((event, emit) async {
      await createReview(event.reviewData!);
    });

    on<FetchReviewsForMeals>((event, emit) async {
      fetchReviewsForMeals(event.mealId!);
    });

    on<AddToFavMeals>((event, emit) async {
      await addToFavMeals(event.favMealData);
    });

    on<RemoveFromFavMeals>((event, emit) async {
      await deleteItemFromFavMeals(event.productId!);
    });

    on<GetAllFavMeals>((event, emit) async {
      await getFavMeals();
    });

    on<SearchForMeals>((event, emit) async {
      await searchForMeals(event.searchText!);
    });

    on<SearchFavMeals>((event, emit) async {
      await searchFavMeals(event.searchText!);
    });
  }

  addToFavMeals(AddToFavouriteModel favModel) async {
    var addToFavsResponse = await apiServices.addToFavourites(
      addToFavouriteModelToJson(favModel),
    );
    emit(state.copyWith(
      isLoading: false,
    ));

    if (addToFavsResponse.toString() == 'error') {
      log.w("Error adding to favourites");
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        icon: Icons.error_outline,
        content: "Error adding to favourites.",
      );
    } else {
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        icon: CupertinoIcons.check_mark_circled,
        content: "Added to favourites",
      );
      log.wtf("Added to favs");
      getFavMeals();
    }
  }

  deleteItemFromFavMeals(String productId) async {
    var removeFromFavResponse = await apiServices.removeFromFavourites(
      {"productId": productId},
    );
    emit(state.copyWith(
      isLoading: false,
    ));
    if (removeFromFavResponse.toString() == 'error') {
      log.w("Error removing from favs");
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        icon: Icons.error_outline,
        content: "Error removing from favourites.",
      );
    } else {
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        icon: CupertinoIcons.check_mark_circled,
        content: "Removed from favourites",
      );
      log.wtf("Removed $productId from favs");
      getFavMeals();
    }
  }

  getFavMeals() async {
    if (Globals.token == '') {
      emit(state.copyWith(
        isLoading: false,
        userNotLoggedIn: true,
      ));
      log.w("User is not yet logged in: ${state.userNotLoggedIn}");

      return;
    }

    emit(state.copyWith(
      isLoading: true,
      userNotLoggedIn: false,
    ));

    // Getting all favs
    var getMyFavouritesResponse = await apiServices.getMyFavourites();

    if (getMyFavouritesResponse.toString() == "error") {
      log.w("Error fetching favs");
      emit(state.copyWith(
        isLoading: false,
        errorFetchingFavs: true,
      ));
    } else if (getMyFavouritesResponse.toString() == "[]" ||
        getMyFavouritesResponse.toString() == "") {
      log.w("No fav items yet");
      emit(state.copyWith(
        isLoading: false,
        errorFetchingFavs: true,
      ));
    } else {
      log.wtf(
        "Successfully fetched favs: ${getMyFavouritesResponse.toString()}",
      );
      var dataBody = getMyFavouritesResponse;

      GetMyFavouriteModel favMealsData = getMyFavouriteModelFromJson(
        jsonEncode(
          dataBody,
        ),
      );
      log.wtf("Last favourite: ${favMealsData.products?.last}");

      emit(state.copyWith(
        isLoading: false,
        errorFetchingFavs: false,
        favMealData: favMealsData,
      ));
    }
    log.w("Done: Fav Meals = ${state.favMealData?.products?.length}");
    if (state.meals?.isEmpty == true) {
      getAllMeals();
    }
  }

  createReview(CreateReviewModel reviewData) async {
    emit(state.copyWith(
      isLoading: true,
    ));
    var createReviewResponse = await apiServices.createReview(
      createReviewModelToJson(reviewData),
    );
    emit(state.copyWith(
      isLoading: false,
    ));

    if (createReviewResponse.toString() == 'error') {
      log.w("Error creating Review");
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        icon: Icons.error_outline,
        content: "Error adding review.",
      );
    } else {
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        icon: CupertinoIcons.check_mark_circled,
        content: "Review added",
      );
      fetchReviewsForMeals(reviewData.product!);
    }
  }

  fetchReviewsForMeals(String mealId) async {
    emit(state.copyWith(
      isLoading: true,
      customerReviews: [],
      averageRating: 0,
    ));
    if (Globals.token == '') {
      Globals.token = await getSharedPrefsSavedString("savedToken");
    }

    // Getting all meals list
    var getReviewsResponse = await apiServices.getProductReviews(mealId);

    List<CustomerReviewModel> reviewsList = [];

    if (getReviewsResponse.toString() == "error") {
      log.w("Error getting reviews");
      emit(state.copyWith(
        isLoading: false,
        customerReviews: null,
        averageRating: null,
        noReviewsYet: false,
      ));
      log.w(
          "${state.noReviewsYet}, ${state.customerReviews?.length.toString()}");
    } else if (getReviewsResponse.toString() == '[]') {
      log.w("No reviews yet");
      emit(state.copyWith(
        isLoading: false,
        customerReviews: [],
        averageRating: 0.0,
        noReviewsYet: true,
      ));
      log.w(
          "${state.noReviewsYet}, ${state.customerReviews?.length.toString()}");
    } else {
      log.wtf(
        "Successfully fetched Reviews: ${getReviewsResponse.toString()}",
      );
      var dataBody = getReviewsResponse;
      if (dataBody != null) {
        reviewsList = (dataBody)
            .map((i) => CustomerReviewModel.fromJson(i))
            .toList()
            .cast<CustomerReviewModel>();
      }
      log.wtf("Last user: ${reviewsList.last.toJson()}");
      double avgRating = calculateAverageRating(reviewsList);

      emit(state.copyWith(
        isLoading: false,
        noReviewsYet: false,
        customerReviews: reviewsList,
        averageRating: avgRating,
      ));
      log.w(
          "Done: Customer Reviews = ${state.customerReviews?.length}, averageRating: $avgRating");
    }
  }

  double calculateAverageRating(List<CustomerReviewModel> list) {
    if (list.isEmpty) {
      return 0.0;
    }

    int sum = list.map((model) => model.rating!).reduce((a, b) => a + b);
    double average = sum / list.length.toDouble();

    return average;
  }

  getAllMeals() async {
    emit(state.copyWith(isLoading: true));
    try {
      if (Globals.token == '') {
        Globals.token = await getSharedPrefsSavedString("savedToken");
      }
      // Getting all meals list
      var getMealsResponse = await apiServices.getMeals();

      List<EachMealModel> mealsList = [];

      if (getMealsResponse.toString() == "error") {
        log.w("Error getting meals");
        emit(state.copyWith(
          isLoading: false,
          meals: [],
        ));
      } else {
        log.wtf(
          "Successfully fetched Meals: ${getMealsResponse.toString()}",
        );
        var dataBody = getMealsResponse;
        if (dataBody != null) {
          mealsList = (dataBody)
              .map((i) => EachMealModel.fromJson(i))
              .toList()
              .cast<EachMealModel>();
        }
        log.wtf("Last user: ${mealsList.last.toJson()}");
      }

      emit(state.copyWith(
        isLoading: false,
        meals: mealsList,
      ));
      log.w("Done: Meals = ${state.meals?.length}");
      getMyLocation();
      await getFavMeals();
    } catch (e) {
      log.wtf("Error occured: ${e.toString()}");
      emit(state.copyWith(
        isLoading: false,
      ));
    }
  }

  searchForMeals(String searchText) {
    List<EachMealModel> searchMealsList = state.meals!
        .where(
            (obj) => obj.name!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();

    emit(state.copyWith(searchMeals: searchMealsList));
    log.wtf("searchMealsList: ${searchMealsList.length}");
  }

  searchFavMeals(String searchText) {
    List<FavProduct> searchFavMealsList = state.favMealData!.products!
        .where((obj) => obj.productId!.name!
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();

    emit(state.copyWith(searchFavMeals: searchFavMealsList));
    log.wtf("searchFavMealsList: ${searchFavMealsList.length}");
  }

  getMyLocation() async {
    LocationModel locationData;
    // Get my location data
    locationData = await LocationHelper().getCurrentLocation();
    Globals.myPostcode = locationData.postalCode ?? "";
    Globals.myCity = locationData.city ?? "";
    Globals.myCountry = locationData.country ?? "";
    emit(state.copyWith(
      myLocationString:
          "${Globals.myPostcode}, ${Globals.myCity}, ${Globals.myCountry}",
    ));
    log.wtf("My Location: ${state.myLocationString}");
  }
}
