import 'package:flutter/foundation.dart';
import 'package:rxdart_app/api_search_feature/models/thing.dart';

enum AnimalType {
  dog,
  cat,
  rabbit,
  unknown,
}

@immutable
class Animal extends Thing {
  final AnimalType type;

  const Animal({required super.name, required this.type});

  @override
  String toString() => "Animal, name: $name, type: $type";

  factory Animal.fromJson(Map<String, dynamic> json) {
    final AnimalType animalType;
    switch ((json['type'] as String).toLowerCase().trim()) {
      case "rabbit":
        animalType = AnimalType.rabbit;
      case "dog":
        animalType = AnimalType.dog;
      case "cat":
        animalType = AnimalType.cat;
      default:
        animalType = AnimalType.unknown;
    }
    return Animal(name: json['name'], type: animalType);
  }
}
