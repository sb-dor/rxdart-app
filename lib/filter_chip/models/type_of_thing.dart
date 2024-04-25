import 'package:flutter/foundation.dart';

enum TypeOfThing { animal, person }

@immutable
class ThingFilterChip {
  final TypeOfThing typeOfThing;
  final String name;

  const ThingFilterChip({
    required this.typeOfThing,
    required this.name,
  });
}
