// ignore_for_file: override_on_non_overriding_member

import 'package:d818_mobile_app/app/models/favourite/get_my_favs.dart';
import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';
import 'package:d818_mobile_app/app/models/review/customer_review_model.dart';

class HomepageState {
  HomepageState({
    this.networkAvailable,
    this.isLoading = true,
    this.noReviewsYet,
    this.meals,
    this.searchMeals,
    this.searchFavMeals,
    this.favMealData,
    this.customerReviews,
    this.averageRating,
    this.errorFetchingFavs,
    this.userNotLoggedIn,
    this.myLocationString,
  });

  bool? networkAvailable,
      isLoading,
      noReviewsYet,
      errorFetchingFavs,
      userNotLoggedIn;
  List<EachMealModel>? meals = [], searchMeals = [];
  List<FavProduct>? searchFavMeals = [];
  GetMyFavouriteModel? favMealData;
  List<CustomerReviewModel>? customerReviews;
  double? averageRating;
  String? myLocationString;

  HomepageState copyWith(
          {bool? networkAvailable,
          bool? isLoading,
          bool? errorFetchingFavs,
          bool? userNotLoggedIn,
          bool? noReviewsYet,
          List<EachMealModel>? meals,
          List<EachMealModel>? searchMeals,
          List<FavProduct>? searchFavMeals,
          GetMyFavouriteModel? favMealData,
          List<CustomerReviewModel>? customerReviews,
          double? averageRating,
          String? myLocationString}) =>
      HomepageState(
        networkAvailable: networkAvailable ?? this.networkAvailable,
        isLoading: isLoading ?? this.isLoading,
        noReviewsYet: noReviewsYet ?? this.noReviewsYet,
        meals: meals ?? this.meals,
        searchMeals: searchMeals ?? this.searchMeals,
        searchFavMeals: searchFavMeals ?? this.searchFavMeals,
        favMealData: favMealData ?? this.favMealData,
        customerReviews: customerReviews ?? this.customerReviews,
        averageRating: averageRating ?? this.averageRating,
        errorFetchingFavs: errorFetchingFavs ?? this.errorFetchingFavs,
        userNotLoggedIn: userNotLoggedIn ?? this.userNotLoggedIn,
        myLocationString: myLocationString ?? this.myLocationString,
      );

  @override
  List<Object?> get props => [
        networkAvailable,
        isLoading,
        errorFetchingFavs,
        userNotLoggedIn,
        noReviewsYet,
        meals,
        searchMeals,
        searchFavMeals,
        favMealData,
        customerReviews,
        averageRating,
        myLocationString,
      ];
}
