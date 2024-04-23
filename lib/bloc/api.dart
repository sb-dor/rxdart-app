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

    // final persons = await _getJson(url)
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
