import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rxdart_app/getit/getit_inj.dart';
import 'package:rxdart_app/pusher/service/pusher_service.dart';

class PusherPage extends StatefulWidget {
  const PusherPage({super.key});

  @override
  State<PusherPage> createState() => _PusherPageState();
}

class _PusherPageState extends State<PusherPage> {
  late final PusherService _pusherService;

  final String _channelName = "always_flutter";

  String _lastMessage = '';

  @override
  void initState() {
    super.initState();
    _pusherService = locator<PusherService>();

    Channel channel = _pusherService.pusher.subscribe(_channelName);

    // event name
    channel.bind("send.event", (event) {
      setState(() {
        Map<String, dynamic> json = jsonDecode(event?.data ?? '');
        _lastMessage = json['message'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pusher page"),
      ),
      body: Center(
        child: Text(
          _lastMessage,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
