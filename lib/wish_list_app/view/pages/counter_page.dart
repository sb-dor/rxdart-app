import 'package:flutter/material.dart';
import 'package:rxdart_app/wish_list_app/view/bloc/counter_bloc.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  late CounterBloc _counterBloc;

  @override
  void initState() {
    super.initState();
    _counterBloc = CounterBloc();
  }

  @override
  void dispose() {
    _counterBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Counter page"),
      ),
      body: StreamBuilder(
        stream: _counterBloc.counterState,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CircularProgressIndicator(
                color: Theme.of(context).colorScheme.inversePrimary,
              );
            case ConnectionState.active:
            case ConnectionState.done:
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () => _counterBloc.onDataEvent
                            .add(IncrementCounterEvent(snapshot.requireData.counter)),
                        child: const Text("Increment")),
                    Text(
                      "${snapshot.requireData.counter}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () => _counterBloc.onDataEvent
                            .add(DecrementCounterEvent(snapshot.requireData.counter)),
                        child: const Text("Decrement"))
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
