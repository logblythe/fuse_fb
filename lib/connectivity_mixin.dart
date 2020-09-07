import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

mixin ConnectivityMixin {
  StreamSubscription<ConnectivityResult> subscription;

  initializeConnectivity({
    @required Function onConnected,
    @required Function onDisconnected,
  }) {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        onConnected();
      } else {
        onDisconnected();
      }
    });
  }

  closeSubscription() {
    subscription.cancel();
  }
}
