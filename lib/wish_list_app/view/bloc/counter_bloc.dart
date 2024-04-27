import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class CounterState {
  int counter;

  CounterState(this.counter);
}

class InitialCounterState extends CounterState {
  InitialCounterState(super.counter);
}

@immutable
class CounterEvents {
  final int counter;

  const CounterEvents(this.counter);
}

@immutable
class IncrementCounterEvent extends CounterEvents {
  const IncrementCounterEvent(super.counter);
}

@immutable
class DecrementCounterEvent extends CounterEvents {
  const DecrementCounterEvent(super.counter);
}

@immutable
class CounterBloc {
  final Sink<CounterEvents> onDataEvent;
  final Stream<CounterState> counterState;

  const CounterBloc._({
    required this.onDataEvent,
    required this.counterState,
  });

  void dispose() {
    onDataEvent.close();
  }

  factory CounterBloc() {
    final onDataEvent = BehaviorSubject<CounterEvents>();

    final incrementState = _incrementStates(onDataEvent);

    return CounterBloc._(
      onDataEvent: onDataEvent,
      counterState: incrementState,
    );
  }

  static Stream<CounterState> _incrementStates(BehaviorSubject<CounterEvents> onDataEvent) {
    return onDataEvent.asyncMap<CounterState>((event) async {
      var data = event.counter;
      if (event is IncrementCounterEvent) {
        return InitialCounterState(++data);
      } else {
        return InitialCounterState(--data);
      }
    }).startWith(InitialCounterState(0));
  }
}
