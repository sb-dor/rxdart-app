import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class ConcatAppPage extends StatefulWidget {
  const ConcatAppPage({super.key});

  @override
  State<ConcatAppPage> createState() => _ConcatAppPageState();
}

class _ConcatAppPageState extends State<ConcatAppPage> {
  @override
  void initState() {
    super.initState();
  }

  Stream<String> getFromPath({required String filePath}) {
    final names = rootBundle.loadString(filePath);
    return Stream.fromFuture(names).transform(const LineSplitter());
  }

  Stream<String> getConcatStreams() {
    return getFromPath(filePath: "assets/texts/cats.txt").concatWith([
      getFromPath(filePath: "assets/texts/dogs.txt"),
    ]).delay(const Duration(seconds: 3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Concat app page"),
        actions: [
          IconButton(
            onPressed: () => [],
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<String?>>(
        future: getConcatStreams().toList(),
        builder: (context, snap) {
          switch (snap.connectionState) {
            case ConnectionState.none:
              return const Center(child: CircularProgressIndicator(color: Colors.blue));
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator(color: Colors.red));
            case ConnectionState.active:
              return const Center(child: CircularProgressIndicator(color: Colors.amber));
            case ConnectionState.done:
              final names = snap.requireData;
              return RefreshIndicator(
                onRefresh: () async => [],
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.black,
                  ),
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(names[index] ?? ''),
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
