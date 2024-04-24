import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() {
  testIt();

  runApp(const App());
}

void testIt() async {
  final stream1 = Stream.periodic(const Duration(seconds: 1), (i) => "Stream 1, count = $i");

  final stream2 = Stream.periodic(const Duration(seconds: 3), (i) => "Stream 2, count = $i");

  final combined = Rx.combineLatest2(stream1, stream2, (a, b) => "One is: $a | Two is: $b");

  await for (final value in combined) {
    value.log();
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        title: Text("Home page"),
      ),
    );
  }
}
