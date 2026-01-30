import 'package:flutter/material.dart';

/// Mixin obsługujący cykl życia aplikacji (tło/wznowienie).
mixin TimerLifecycleMixin on ChangeNotifier, WidgetsBindingObserver {
  // Te metody musi zaimplementować Twój TimerService
  bool get isTimerRunning;
  void onAppBackgrounded();
  void onAppResumed();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Aplikacja idzie w tło / ekran zablokowany
      if (isTimerRunning) {
        onAppBackgrounded();
      }
    } else if (state == AppLifecycleState.resumed) {
      // Aplikacja wraca na pierwszy plan
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
