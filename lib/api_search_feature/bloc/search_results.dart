import 'package:flutter/foundation.dart';
import 'package:rxdart_app/api_search_feature/models/thing.dart';

@immutable
abstract class SearchResultsStates {
  const SearchResultsStates();
}

@immutable
class SearchResultLoadingState extends SearchResultsStates {
  const SearchResultLoadingState();
}

@immutable
class SearchResultNoResultsState extends SearchResultsStates {
  const SearchResultNoResultsState();
}

@immutable
class SearchResultErrorState extends SearchResultsStates {
  final Object error;

  const SearchResultErrorState(this.error);
}

@immutable
class SearchResultWithResultsState extends SearchResultsStates {
  final List<Thing> results;

  const SearchResultWithResultsState(this.results);
}
