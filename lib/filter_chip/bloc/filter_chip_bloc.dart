import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_app/filter_chip/models/type_of_thing.dart';

@immutable
class FilterChipBloc {
  // the only one write thing the ui cal control,
  // so ui can tell us what current filter is (animal or person)
  final Sink<TypeOfThing?> typeOfThing; // write-only

  // in order that ui can know what kind of filter was selected
  // we have to hold that somewhere like streams
  final Stream<TypeOfThing?> currentTypeOfThing; // read-only

  final Stream<Iterable<ThingFilterChip>> things; // read-only

  // after communication between ui and bloc
  // we have to dispose the sink (bridge communicator between ui and bloc)
  void dispose() {
    typeOfThing.close();
  }

  // the reason why we create private contractor is that
  // we don't have to create new object for filterchipbloc
  // the reason only for passing data to sink and streams that we created above
  // as a constructor that will represent the object for creating filterChipBloc will be factory
  // remember that doing like this you will never create the new instance of
  // -> "typeOfThing", "currentTypeOfThing", "things" that we created above
  const FilterChipBloc._({
    required this.typeOfThing,
    required this.currentTypeOfThing,
    required this.things,
  });

  factory FilterChipBloc({
    required Iterable<ThingFilterChip> things,
  }) {
    final communicator = BehaviorSubject<TypeOfThing?>();

    final filterThings = communicator
        .debounceTime(const Duration(milliseconds: 300))
        .map<Iterable<ThingFilterChip>>((typeOfThing) {
      if (typeOfThing != null) {
        return things.where((element) => element.typeOfThing == typeOfThing);
      }
      {
        return things;
      }
    }).startWith(things);

    return FilterChipBloc._(
      typeOfThing: communicator.sink,
      currentTypeOfThing: communicator.stream,
      things: filterThings,
    );
  }
}
