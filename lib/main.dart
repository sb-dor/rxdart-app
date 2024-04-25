import 'package:flutter/material.dart';
import 'two_textfiled_example/view/two_textfield_example.dart';

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
      home: TwoTextFieldExample(),
      debugShowCheckedModeBanner: false,
    );
  }
}
