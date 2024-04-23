import 'dart:convert';
import 'dart:io';

import 'package:rxdart_app/models/animal.dart';
import 'package:rxdart_app/models/person.dart';
import 'package:rxdart_app/models/thing.dart';

typedef SearchTerm = String;

class Api {
  List<Animal>? _animals;
  List<Person>? _persons;

  Api();

  Future<List<Thing>> search(SearchTerm searchTerm) async {
    final term = searchTerm.trim().toLowerCase();

    // search in the cache
    final cashedResults = _extractThingUsingSearchTerm(term);

    if (cashedResults != null) return cashedResults;

    // calling api for persons
    const personUrl =
        "https://raw.githubusercontent.com/sb-dor/rxdart-app/master/apis/persons.json";

    final persons = await _getJson(personUrl).then((json) => json.map((e) => Person.fromJson(e)));

    _persons = persons.toList();

    // calling api for animals
    const animalUrl =
        "https://raw.githubusercontent.com/sb-dor/rxdart-app/master/apis/api_animals.json";

    final animals = await _getJson(animalUrl).then((json) => json.map((e) => Animal.fromJson(e)));

    _animals = animals.toList();

    return _extractThingUsingSearchTerm(term) ?? [];
  }

  // searchterm is just a string
  List<Thing>? _extractThingUsingSearchTerm(SearchTerm term) {
    final cachedAnimals = _animals;
    final cachedPersons = _persons;
    if (cachedAnimals != null && cachedPersons != null) {
      List<Thing> result = [];

      // go through animals
      for (final animal in cachedAnimals) {
        if (animal.name.trimmedContains(term) || animal.type.name.trimmedContains(term)) {
          result.add(animal);
        }
      }

      // go through persons
      for (final person in cachedPersons) {
        if (person.name.trimmedContains(term) || person.age.toString().trimmedContains(term)) {
          result.add(person);
        }
      }
      return result;
    }
    return null;
  }

  Future<List<dynamic>> _getJson(String url) async => HttpClient()
      .getUrl(Uri.parse(url))
      .then((req) => req.close())
      .then((response) => response.transform(utf8.decoder).join())
      .then((jsonString) => jsonDecode(jsonString) as List<dynamic>);
}

extension TrimmedCaseInsensitiveContain on String {
  bool trimmedContains(String other) => trim().toLowerCase().contains(
        other.trim().toLowerCase(),
      );
}
