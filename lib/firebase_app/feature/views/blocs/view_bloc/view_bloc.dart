import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_app/firebase_app/feature/views/blocs/view_bloc/current_view.dart';

@immutable
class ViewBloc {
  final Sink<CurrentView> goToView;
  final Stream<CurrentView> currentView;

  const ViewBloc._({
    required this.goToView,
    required this.currentView,
  });

  factory ViewBloc() {
    final goToViewB = BehaviorSubject<CurrentView>();

    return ViewBloc._(
      goToView: goToViewB.sink,
      currentView: goToViewB.startWith(
        CurrentView.login,
      ),
    );
  }

  void dispose() {
    goToView.close();
  }
}
