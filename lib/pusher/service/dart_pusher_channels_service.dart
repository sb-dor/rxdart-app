import 'package:dart_pusher_channels/dart_pusher_channels.dart';

class DartPusherChannelsService {
  late final PusherChannelsClient pusherChannelsClient;

  DartPusherChannelsService() {
    init();
  }

  void init() {
    const options = PusherChannelsOptions.fromHost(
      scheme: 'http',
      host: 'http://192.168.100.244',
      port: 6001,
      key: 'livepost_key',
    );
    pusherChannelsClient = PusherChannelsClient.websocket(
      options: options,
      connectionErrorHandler: (exception, trace, refresh) {
        refresh();
      },
    );
  }
}
