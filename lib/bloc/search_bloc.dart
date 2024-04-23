import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_app/bloc/api.dart';
import 'package:rxdart_app/bloc/search_results.dart';

@immutable
class SearchBloc {
  final Sink<String> search;

  final Stream<SearchResultsStates?> results; // represents states

  // Sinks (in out context is search variable) have to be closed in the end of using
  // (как раковина, после мытья рук или посуды мы закрываем ее)
  void dispose() {
    search.close();
  }

  const SearchBloc._({
    required this.search,
    required this.results,
  }); // every time when i call this private constructor i change the values above

  factory SearchBloc({
    required Api api,
  }) {
    // it has Stream under the hood that has sink
    // because simple Streams doesn't have sink itself
    final textChanges = BehaviorSubject<String>();

    final Stream<SearchResultsStates?> results = textChanges
        .distinct()
        .debounceTime(const Duration(seconds: 1))
        .switchMap<SearchResultsStates?>((String searchTerm) {
          if (searchTerm.isEmpty) {
            return Stream<SearchResultsStates?>.value(null);
          } else {
            // Rx.fromCallable changes the Future type into Stream
            final search = Rx.fromCallable(() => api.search(searchTerm)).map(
              (results) => results.isEmpty
                  ? const SearchResultNoResultsState()
                  : SearchResultWithResultsState(results),
            );
            return search;
          }
        })
        // every time when this all streams work the start value will be the places value
        .startWith(const SearchResultLoadingState())
        // we created one of that type of Streams that can be listened in future usages
        .onErrorReturnWith((error, _) => SearchResultErrorState(error));

    return SearchBloc._(search: textChanges.sink, results: results);
  }
}
