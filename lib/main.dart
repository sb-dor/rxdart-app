import 'package:flutter/material.dart';
import 'package:rxdart_app/concat_app_example/view/concat_app_page.dart';

void main() {
  // testCombined();
  // testConcat();
  // testMerge();
  // testZip();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ConcatAppPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
