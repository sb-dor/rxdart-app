import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_app/bloc/api.dart';
import 'package:rxdart_app/bloc/search_results.dart';

@immutable
class SearchBloc {
  final Sink<String> search;

  final Stream<SearchResultsStates?> results;

  // Sinks (in out context is search variable) have to be closed in the end of using
  // (как раковина, после мытья рук или посуды мы закрываем ее)
  void dispose() {
    search.close();
  }

  const SearchBloc._({required this.search, required this.results});

  factory SearchBloc({
    required Api api,
  }) {
    final textChanges =
        BehaviorSubject<String>(); // it has Stream under the hood that has sink

    final Stream<SearchResultsStates?> results = textChanges
        .distinct()
        .debounceTime(const Duration(seconds: 1))
        .switchMap<SearchResultsStates?>((String searchTerm) {
          if (searchTerm.isEmpty) {
            return Stream<SearchResultsStates?>.value(null);
          } else {
            final search = Rx.fromCallable(() => api.search(searchTerm)).map(
              (results) => results.isEmpty
                  ? const SearchResultNoResultsState()
                  : SearchResultWithResultsState(results),
            );
            return search;
          }
        })
        .startWith(const SearchResultLoadingState())
        .onErrorReturnWith(
          (error, _) => SearchResultErrorState(error),
        ); // we created one of that type of Streams that can be listened in future usages

    return SearchBloc._(search: textChanges.sink, results: results);
  }
}
