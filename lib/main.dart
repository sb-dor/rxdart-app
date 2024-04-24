import 'package:flutter/material.dart';
import 'simple_datetime_stream_home_page/simple_datetime_stream_home_page.dart';

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
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
