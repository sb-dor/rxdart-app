import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  // testCombined();
  // testConcat();
  // testMerge();
  testZip();

  runApp(const App());
}

// combine two or more streams with combinesLatest method of rxDart
// it start to work when the latest stream start to have value
void testCombined() async {
  final stream1 = Stream.periodic(const Duration(seconds: 1), (i) => "Stream 1, count = $i");

  final stream2 = Stream.periodic(const Duration(seconds: 3), (i) => "Stream 2, count = $i");

  final combined = Rx.combineLatest2(stream1, stream2, (a, b) => "One is: $a | Two is: $b");

  await for (final value in combined) {
    value.log();
  }
}

// concat (merge) two or more streams until the first stream ends
void testConcat() async {
  // (take) takes only the number of values that you set there

  final stream1 = Stream.periodic(
    const Duration(seconds: 1),
    (i) => "Stream 1, count = $i",
  ).take(3);

  final stream2 = Stream.periodic(
    const Duration(seconds: 3),
    (i) => "Stream 2, count = $i",
  );

  final concat = Rx.concat([stream1, stream2]);

  await for (final each in concat) {
    each.log();
  }
  // LOGS:

  // [log] Stream 1, count = 0
  // [log] Stream 1, count = 1
  // [log] Stream 1, count = 2 // after taking 3 values stream 1 ends and second stream starts two work
  // [log] Stream 2, count = 0
  // [log] Stream 2, count = 1
  // [log] Stream 2, count = 2
  // [log] Stream 2, count = 3
  // [log] Stream 2, count = 4
  // [log] Stream 2, count = 5
}

void testMerge() async {
  final stream1 = Stream.periodic(
    const Duration(seconds: 1),
    (i) => "Stream 1, count = $i",
  ).take(7);

  final stream2 = Stream.periodic(
    const Duration(seconds: 3),
    (i) => "Stream 2, count = $i",
  );

  // merge just merges several streams and whenever one of the streams gives value we can listen them
  final merged = Rx.merge([stream1, stream2]);

  await for (final each in merged) {
    each.log();
  }
}

void testZip() async {
  final stream1 = Stream.periodic(
    const Duration(seconds: 1),
    (i) => "Stream 1, count = $i | ",
  ).take(7);

  final stream2 = Stream.periodic(
    const Duration(seconds: 3),
    (i) => "Stream 2, count = $i | ",
  ).take(7);

  final stream3 = Stream.periodic(
    const Duration(seconds: 5),
    (i) => "Stream 3, count = $i",
  ).take(7);

  // you have to see the web site and you will understand
  // link is in readme.md file in lib folder
  final merged = Rx.zipList([stream1, stream2, stream3]);

  await for (final each in merged) {
    each.log();
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
      ),
    );
  }
}
