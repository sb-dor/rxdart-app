import 'package:flutter/material.dart';
import 'package:rxdart_app/bloc/search_results.dart';
import 'package:rxdart_app/models/animal.dart';
import 'package:rxdart_app/models/person.dart';

class SearchResultView extends StatelessWidget {
  final Stream<SearchResultsStates?> search;

  const SearchResultView({super.key, required this.search});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: search,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final result = snapshot.data;
          if (result is SearchResultErrorState) {
            return const Text("Got Error");
          } else if (result is SearchResultLoadingState) {
            return const CircularProgressIndicator();
          } else if (result is SearchResultNoResultsState) {
            return const Text("No result");
          } else if (result is SearchResultWithResultsState) {
            final results = result.results; // variable inside of SearchResultWIthResultState
            return Expanded(
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index) {
                  final item = results[index];
                  String title;
                  if (item is Animal) {
                    title = "Animal";
                  } else if (item is Person) {
                    title = "Person";
                  } else {
                    title = 'Unknown';
                  }
                  return ListTile(
                    title: Text(title),
                    subtitle: (Text(item.toString())),
                  );
                },
              ),
            );
          } else {
            return const Text("Unknown");
          }
        } else {
          return const Text("Waiting");
        }
      },
    );
  }
}
