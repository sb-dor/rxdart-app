import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class CounterStateModel {
  int counter = 1;
}

@immutable
class CounterState {
  final CounterStateModel stateModel;

  const CounterState(this.stateModel);
}

@immutable
class InitialCounterState extends CounterState {
  const InitialCounterState(super.stateModel);
}

@immutable
class CounterEvents {
  final CounterStateModel stateModel;

  const CounterEvents(this.stateModel);
}

@immutable
class IncrementCounterEvent extends CounterEvents {
  const IncrementCounterEvent(super.stateModel);
}

@immutable
class DecrementCounterEvent extends CounterEvents {
  const DecrementCounterEvent(super.stateModel);
}

@immutable
class CounterBloc {
  final Sink<CounterEvents> onDataEvent;

  // if I would use StreamController instead of BehaviorSubject (which both of them are almost same, but BehaviorSubject has more functions and BehaviorSubject uses broadcast by optional)
  // it would throw an error : "Bad state Stream has already been listened to."
  // that is why BehaviorSubject can be listened multiple times


  // The BehaviorSubject is a type of StreamController that caches the latest added value or error
  final BehaviorSubject<CounterState> counterStateSubject;

  Stream<CounterState> get counterState => counterStateSubject.stream;

  const CounterBloc._({
    required this.onDataEvent,
    required this.counterStateSubject,
  });

  void dispose() {
    onDataEvent.close();
  }

  factory CounterBloc() {
    final onDataEvent = BehaviorSubject<CounterEvents>();

    final state = _incrementStates(onDataEvent);

    final behavior = BehaviorSubject<CounterState>()..addStream(state);

    return CounterBloc._(
      onDataEvent: onDataEvent.sink,
      counterStateSubject: behavior,
    );
  }

  static Stream<CounterState> _incrementStates(
    BehaviorSubject<CounterEvents> onDataEvent,
  ) {
    final data = onDataEvent.map<CounterState>((event) {
      var data = event.stateModel;
      if (event is IncrementCounterEvent) {
        data.counter++;
        return InitialCounterState(data);
      } else {
        data.counter--;
        return InitialCounterState(data);
      }
    }).startWith(InitialCounterState(CounterStateModel()));

    return data;
  }
}
