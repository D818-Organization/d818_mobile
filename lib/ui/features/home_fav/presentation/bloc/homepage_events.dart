import 'package:d818_mobile_app/app/models/favourite/add_to_favs.dart';
import 'package:d818_mobile_app/app/models/meals/each_meal_model.dart';
import 'package:d818_mobile_app/app/models/review/create_review_model.dart';
import 'package:equatable/equatable.dart';

abstract class HomepageBlocEvent extends Equatable {}

class GetAllMeals extends HomepageBlocEvent {
  @override
  List<Object?> get props => [];
}

class CreateReview extends HomepageBlocEvent {
  final CreateReviewModel? reviewData;

  CreateReview(this.reviewData);

  @override
  List<Object?> get props => [reviewData];
}

class FetchReviewsForMeals extends HomepageBlocEvent {
  final String? mealId;

  FetchReviewsForMeals(this.mealId);

  @override
  List<Object?> get props => [mealId];
}

class AddToFavMeals extends HomepageBlocEvent {
  final AddToFavouriteModel favMealData;

  AddToFavMeals(this.favMealData);

  @override
  List<Object?> get props => [favMealData];
}

class RemoveFromFavMeals extends HomepageBlocEvent {
  final String? productId;

  RemoveFromFavMeals(this.productId);

  @override
  List<Object?> get props => [productId];
}

class GetAllFavMeals extends HomepageBlocEvent {
  @override
  List<Object?> get props => [];
}

class AddMealToCart extends HomepageBlocEvent {
  final EachMealModel? meal;

  AddMealToCart(this.meal);

  @override
  List<Object?> get props => [meal];
}

class SearchForMeals extends HomepageBlocEvent {
  final String? searchText;

  SearchForMeals(this.searchText);

  @override
  List<Object?> get props => [searchText];
}

class SearchFavMeals extends HomepageBlocEvent {
  final String? searchText;

  SearchFavMeals(this.searchText);

  @override
  List<Object?> get props => [searchText];
}
