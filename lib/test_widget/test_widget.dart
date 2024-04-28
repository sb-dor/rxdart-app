import 'dart:async';
import 'package:flutter/material.dart';

// Define a global stream controller
StreamController<int> _streamController = StreamController<int>.broadcast();

// Method to add data to the stream
void addDataToStream(int data) {
  _streamController.add(data);
}

// Method to close the stream when it's no longer needed
void disposeStream() {
  _streamController.close();
}

// Widget to display the stream data
class StreamConsumerWidget extends StatefulWidget {
  const StreamConsumerWidget({super.key});

  @override
  _StreamConsumerWidgetState createState() => _StreamConsumerWidgetState();
}

class _StreamConsumerWidgetState extends State<StreamConsumerWidget> {
  int _data = 0;

  @override
  void initState() {
    super.initState();
    // Listen to the stream and update the data
    _streamController.stream.listen((data) {
      setState(() {
        _data = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('Stream Data: $_data');
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// Example usage of the stream consumer widget across different pages
class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('First Page')),
      body: Column(
        children: [
          const StreamConsumerWidget(), // Display the stream data
          ElevatedButton(
            onPressed: () => addDataToStream(10), // Add data to the stream
            child: const Text('Add Data to Stream'),
          ),
          ElevatedButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => const SecondPage())),
              child: const Text("PUsh"))
        ],
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second Page')),
      body: const Column(
        children: [
          StreamConsumerWidget(), // Display the stream data
        ],
      ),
    );
  }
}
