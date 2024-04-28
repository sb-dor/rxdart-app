import 'package:flutter/foundation.dart';
import 'package:rxdart_app/wish_list_app/domain/entity/wish.dart';

class WishModel extends Wish {
  WishModel({
    required super.id,
    required super.wishName,
    required super.dateTime,
  });

  WishModel copyWith() => WishModel(id: id, wishName: wishName, dateTime: dateTime);

  factory WishModel.fromEntity(Wish wish) {
    return WishModel(
      id: wish.id,
      wishName: wish.wishName,
      dateTime: wish.dateTime,
    );
  }
}
