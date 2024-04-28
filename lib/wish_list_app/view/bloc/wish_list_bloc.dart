import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_app/wish_list_app/data/model/wish_model.dart';
import 'package:rxdart_app/wish_list_app/domain/entity/wish.dart';
import 'package:rxdart_app/wish_list_app/view/bloc/state_model/wish_list_state_model.dart';
import 'package:rxdart_app/wish_list_app/view/bloc/wish_list_events.dart';
import 'package:rxdart_app/wish_list_app/view/bloc/wish_list_states.dart';
import 'package:uuid/uuid.dart';

@immutable
class WishListBloc {
  static late final WishListStateModel _currentState;

  final Sink<WishListEvents> wishlistEvents;

  // if I would use StreamController instead of BehaviorSubject (which both of them are almost same, but BehaviorSubject has more functions and BehaviorSubject uses broadcast by optional)
  // it would throw an error : "Bad state Stream has already been listened to."

  // The BehaviorSubject is a type of StreamController that caches the latest added value or error
  final BehaviorSubject<WishListStates> _wishlistStates;

  Stream<WishListStates> get wishlistStates => _wishlistStates.stream;

  const WishListBloc._({
    required this.wishlistEvents,
    required BehaviorSubject<WishListStates> wishlistStates,
  }) : _wishlistStates = wishlistStates;

  factory WishListBloc() {
    final wishListEvents = BehaviorSubject<WishListEvents>();

    _currentState = WishListStateModel();

    final state = _state(events: wishListEvents);

    final BehaviorSubject<WishListStates> wishlistStates = BehaviorSubject<WishListStates>()
      ..addStream(state);

    return WishListBloc._(
      wishlistEvents: wishListEvents,
      wishlistStates: wishlistStates,
    );
  }

  static Stream<WishListStates> _state({
    required BehaviorSubject<WishListEvents> events,
  }) {
    return events.map((wishListEvent) {
      late WishListStates states;

      if (wishListEvent is AddWishListEvent) {
        states = _addWishListEvent(wishListEvent);
      } else if (wishListEvent is InitWishListEvent) {
        states = _initWishListEvent(wishListEvent);
      } else if (wishListEvent is InitTempWishListEvent) {
        states = _initTempWishListForUpdate(wishListEvent);
      } else {
        // here should be first init of bloc
        states = LoadingWishListState(_currentState);
      }

      return states;
    }).startWith(LoadingWishListState(_currentState));
  }

  static WishListStates _addWishListEvent(
    AddWishListEvent event,
  ) {
    try {
      if (_currentState.tempWishForUpdate != null) {
        var tempValueFromList = WishModel.fromEntity(
          _currentState.wishList
              .firstWhere((element) => element.id == _currentState.tempWishForUpdate?.id),
        );

        tempValueFromList.wishName = event.name;

        _currentState.wishList[_currentState.wishList
                .indexWhere((element) => element.id == tempValueFromList.id)] =
            tempValueFromList.copyWith();

        _currentState.tempWishForUpdate = null;
      } else {
        final currentDate = DateTime.now();
        final Wish wish = Wish(
          id: const Uuid().v4(),
          wishName: event.name.trim(),
          dateTime: currentDate,
        );
        _currentState.wishList.add(wish);
      }
      return LoadedWishListState(_currentState);
    } catch (e) {
      return ErrorWishListState(_currentState);
    }
  }

  static WishListStates _initWishListEvent(
    InitWishListEvent event,
  ) {
    try {
      _currentState.wishList.clear();
      return LoadedWishListState(_currentState);
    } catch (e) {
      return ErrorWishListState(_currentState);
    }
  }

  static WishListStates _initTempWishListForUpdate(
    InitTempWishListEvent event,
  ) {
    _currentState.tempWishForUpdate = event.wish;
    return LoadedWishListState(_currentState);
  }
}
