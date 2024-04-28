import 'package:flutter/foundation.dart';

import 'state_model/wish_list_state_model.dart';

@immutable
class WishListStates {
  final WishListStateModel wishListStateModel;

  const WishListStates(this.wishListStateModel);
}

@immutable
class LoadingWishListState extends WishListStates {
  const LoadingWishListState(super.wishListStateModel);
}

@immutable
class ErrorWishListState extends WishListStates {
  const ErrorWishListState(super.wishListStateModel);
}

@immutable
class LoadedWishListState extends WishListStates {
  const LoadedWishListState(super.wishListStateModel);
}
