import 'package:pusher_client/pusher_client.dart';

class PusherService {
  late final PusherClient pusher;

  PusherService() {
    init();
  }

  Future<void> init() async {
    PusherOptions options = PusherOptions(
      host: "192.168.100.244",
      wsPort: 6001,
      encrypted: false,
    );

    // env pusher key
    pusher = PusherClient('livepost_key', options);
  }
}
