import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TimerService extends ChangeNotifier {
  Timer? _timer;
  int _dailySeconds = 0;
  bool _isRunning = false;
  DateTime _lastActiveDate = DateTime.now();

  int get dailySeconds => _dailySeconds;
  bool get isRunning => _isRunning;

  String get formattedTime {
    final hours = (_dailySeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_dailySeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_dailySeconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$seconds";
  }

  TimerService() {
    _loadData();
  }

  void toggleTimer() {
    if (_isRunning) {
      _stopTimer();
    } else {
      _startTimer();
    }
  }

  void _startTimer() {
    _checkMidnightReset();
    _isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _dailySeconds++;
      _checkMidnightReset();
      _saveData();
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    _saveData();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dailySeconds', _dailySeconds);
    await prefs.setString('lastActiveDate', DateTime.now().toIso8601String());
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final lastDateString = prefs.getString('lastActiveDate');

    if (lastDateString != null) {
      _lastActiveDate = DateTime.parse(lastDateString);
      if (_isSameDay(_lastActiveDate, DateTime.now())) {
        _dailySeconds = prefs.getInt('dailySeconds') ?? 0;
      } else {
        _dailySeconds = 0;
      }
    }
    notifyListeners();
  }

  void _checkMidnightReset() {
    final now = DateTime.now();
    if (!_isSameDay(_lastActiveDate, now)) {
      _dailySeconds = 0;
      _lastActiveDate = now;
      notifyListeners();
    }
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
}
