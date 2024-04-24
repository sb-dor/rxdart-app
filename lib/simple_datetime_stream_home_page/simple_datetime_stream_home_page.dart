import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final BehaviorSubject<DateTime> subject;
  late final Stream<String> streamOfStrings;

  @override
  void initState() {
    super.initState();
    subject = BehaviorSubject<DateTime>();
    // about switchMap you can find here in youtube link: https://www.youtube.com/watch?v=xBFWMYmm9ro&t=10720s
    // start youtube video link from 3:17:10

    // like when you click the button for adding new value
    // switchMap deletes previous value
    streamOfStrings = subject.switchMap(
      (dateTime) => Stream.periodic(
        const Duration(seconds: 1),
        (counter) => "Stream count = $counter, datetime = $dateTime",
      ),
    );
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: streamOfStrings,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final string = snapshot.requireData;
                return Text(string);
              } else {
                return const Text("Waiting for pressing the button");
              }
            },
          ),
          TextButton(
            onPressed: () => subject.add(DateTime.now()),
            child: const Text(
              "Start the strem",
            ),
          ),
        ],
      ),
    );
  }
}
