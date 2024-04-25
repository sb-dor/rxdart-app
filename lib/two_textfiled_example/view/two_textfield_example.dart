import 'package:flutter/material.dart';
import 'package:rxdart_app/two_textfiled_example/bloc/two_textfiled_bloc.dart';
import 'package:rxdart_app/two_textfiled_example/view/asyn_snapshot_builder/async_snapshot_builder.dart';

class TwoTextFieldExample extends StatefulWidget {
  const TwoTextFieldExample({super.key});

  @override
  State<TwoTextFieldExample> createState() => _TwoTextFieldExampleState();
}

class _TwoTextFieldExampleState extends State<TwoTextFieldExample> {
  late TwoTextFieldBloc _textFieldBloc;

  @override
  void initState() {
    super.initState();
    _textFieldBloc = TwoTextFieldBloc();
  }

  @override
  void dispose() {
    _textFieldBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Two textfield stream"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(hintText: "Enter a first name here..."),
              onChanged: (value) => _textFieldBloc.firstNameSink.add(value.trim()),
            ),
            TextField(
              decoration: const InputDecoration(hintText: "Enter a second name here..."),
              onChanged: (value) => _textFieldBloc.secondNameSink.add(value.trim()),
            ),
            AsyncSnapshotBuilder<String?>(
              stream: _textFieldBloc.fullName,
              onActive: (context, String? value) => Text(value ?? ''),
            )
          ],
        ),
      ),
    );
  }
}
