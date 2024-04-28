import 'package:flutter/material.dart';
import 'package:rxdart_app/wish_list_app/view/bloc/counter_bloc.dart';
import 'package:rxdart_app/wish_list_app/view/getit/getit_inj.dart';

class OtherCounterPage extends StatefulWidget {
  const OtherCounterPage({super.key});

  @override
  State<OtherCounterPage> createState() => _OtherCounterPageState();
}

class _OtherCounterPageState extends State<OtherCounterPage> {
  late final CounterBloc _counterBloc;

  @override
  void initState() {
    super.initState();
    _counterBloc = locator<CounterBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Counter page"),
      ),
      body: StreamBuilder<CounterState>(
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
                            .add(IncrementCounterEvent(snapshot.requireData.stateModel)),
                        child: const Text("Increment")),
                    Text(
                      "${snapshot.requireData.stateModel.counter}",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    ElevatedButton(
                        onPressed: () => _counterBloc.onDataEvent
                            .add(DecrementCounterEvent(snapshot.requireData.stateModel)),
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
