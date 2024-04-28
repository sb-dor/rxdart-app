import 'package:flutter/foundation.dart';
import 'package:rxdart_app/wish_list_app/domain/entity/wish.dart';

@immutable
abstract class WishListEvents {
  const WishListEvents();
}

@immutable
class InitWishListEvent extends WishListEvents {
  const InitWishListEvent();
}

@immutable
class AddWishListEvent extends WishListEvents {
  final String name;

  const AddWishListEvent({required this.name});
}

class InitTempWishListEvent extends WishListEvents {
  final Wish wish;

  const InitTempWishListEvent({required this.wish});
}
