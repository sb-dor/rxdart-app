import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

class FlutterHooksHomePageExample extends HookWidget {
  const FlutterHooksHomePageExample({super.key});

  @override
  Widget build(BuildContext context) {
    // create out behavior subject every time widget is re-built
    final subject = useMemoized(() => BehaviorSubject<String>(), [key]);

    // dispose of the old subject every time widget is rebuilt
    useEffect(() => subject.close, [subject]);

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<String>(
            stream: subject.stream.distinct().debounceTime(const Duration(seconds: 1)),
            initialData: "Please start typing...",
            builder: (context, snapshot) {
              return Text(snapshot.requireData);
            }),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          onChanged: (v) {
            subject.sink.add(v);
          },
        ),
      ),
    );
  }
}
