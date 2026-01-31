import 'package:flutter/material.dart';

/// Mixin handling app lifecycle (background/resume).
mixin TimerLifecycleMixin on ChangeNotifier, WidgetsBindingObserver {
  bool get isTimerRunning;
  void onAppBackgrounded();
  void onAppResumed();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (isTimerRunning) {
        onAppBackgrounded();
      }
    } else if (state == AppLifecycleState.resumed) {
      onAppResumed();
    }
  }

  void setupLifecycleObserver() {
    WidgetsBinding.instance.addObserver(this);
  }

  void disposeLifecycleObserver() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
