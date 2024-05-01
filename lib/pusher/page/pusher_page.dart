import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pusher_client/pusher_client.dart';
import 'package:rxdart_app/getit/getit_inj.dart';
import 'package:rxdart_app/pusher/service/dart_pusher_channels_service.dart';
import 'package:rxdart_app/pusher/service/pusher_service.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class PusherPage extends StatefulWidget {
  const PusherPage({super.key});

  @override
  State<PusherPage> createState() => _PusherPageState();
}

class _PusherPageState extends State<PusherPage> {
  late final PusherService _pusherService;

  final String _channelName = "always.flutter";

  final String _eventName = "send.event";

  String _lastMessage = '';

  @override
  void initState() {
    super.initState();
    _pusherService = locator<PusherService>();

    Channel channel = _pusherService.pusher.subscribe(_channelName);

    // event name
    channel.bind(_eventName, (event) {
      setState(() {
        Map<String, dynamic> json = jsonDecode(event?.data ?? '');
        _lastMessage = json['message'];
      });
    });

    // dart pusher service
    dartPusherChannelsService();

    // websocket plugin test
    webSocketTestFunc();
  }

  void webSocketTestFunc() async {
    const url = "wss://192.168.100.244:6001";

    final webSocketChannel = WebSocketChannel.connect(Uri.parse(url));

    await webSocketChannel.ready;

    webSocketChannel.stream.listen((event) {
      debugPrint("websocket data: ${event}");
    });
  }

  void dartPusherChannelsService() {
    final service = locator<DartPusherChannelsService>();

    service.pusherChannelsClient.connect();

    final channel = service.pusherChannelsClient.publicChannel(_channelName);

    channel.subscribe();

    channel.bind(_eventName).listen((event) {
      debugPrint("dart pusher service: ${event}");
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
