import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart_app/firebase_app/views/loading/loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();

  static LoadingScreen? _instance;

  static LoadingScreen get instance => _instance ??= LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final text0 = StreamController<String>();
    text0.add(text);

    final state = Overlay.of(context);

    final renderBox = context.findRenderObject() as RenderBox;

    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material();
      },
    );
  }
}
