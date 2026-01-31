import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'timer_lifecycle_mixin.dart';

class TimerService extends ChangeNotifier
    with WidgetsBindingObserver, TimerLifecycleMixin {
  Timer? _timer;
  bool _isRunning = false;
  final Box _box = Hive.box('timer_data');

  static const String _kSessionActiveKey = 'session_is_active';
  static const String _kLastTickKey = 'session_last_tick';

  TimerService() {
    setupLifecycleObserver();
    _restoreSessionIfNeeded();
  }

  @override
  void dispose() {
    disposeLifecycleObserver();
    _timer?.cancel();
    super.dispose();
  }

  bool get isRunning => _isRunning;
  String get formattedTime {
    final int totalSeconds = dailySeconds;
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    if (hours < 1) {
      if (minutes < 1) {
        return "${seconds}s";
      } else {
        return "${minutes}m ${seconds}s";
      }
    } else {
      return "${hours}h ${minutes}m ${seconds}s";
    }
  }

  int get dailySeconds => _getSecondsForDay(DateTime.now());

  @override
  bool get isTimerRunning => _isRunning;

  @override
  void onAppBackgrounded() {
    _saveCurrentTick();
  }

  @override
  void onAppResumed() {
    if (_isRunning) {
      final String? lastTickStr = _box.get(_kLastTickKey);
      if (lastTickStr != null) {
        final lastTick = DateTime.parse(lastTickStr);
        final now = DateTime.now();
        if (now.difference(lastTick).inSeconds > 2) {
          _distributeTimeAcrossDays(lastTick, now);
          _saveCurrentTick();
        }
      }
    }
  }

  void _restoreSessionIfNeeded() {
    final bool wasRunning = _box.get(_kSessionActiveKey, defaultValue: false);
    final String? lastTickStr = _box.get(_kLastTickKey);

    if (wasRunning && lastTickStr != null) {
      final lastTick = DateTime.parse(lastTickStr);
      final now = DateTime.now();

      if (now.isAfter(lastTick)) {
        _distributeTimeAcrossDays(lastTick, now);
      }

      startTimer();
    }
  }

  void _distributeTimeAcrossDays(DateTime start, DateTime end) {
    DateTime currentPointer = start;

    while (currentPointer.isBefore(end)) {
      final nextMidnight = DateTime(
        currentPointer.year,
        currentPointer.month,
        currentPointer.day + 1,
      );

      final segmentEnd = end.isBefore(nextMidnight) ? end : nextMidnight;

      final secondsToAdd = segmentEnd.difference(currentPointer).inSeconds;

      if (secondsToAdd > 0) {
        _addSecondsToDate(currentPointer, secondsToAdd);
      }

      currentPointer = segmentEnd;
    }
    notifyListeners();
  }

  void _addSecondsToDate(DateTime date, int amount) {
    final key = _getDateKey(date);
    final currentSeconds = _box.get(key, defaultValue: 0) as int;
    _box.put(key, currentSeconds + amount);
  }

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    _box.put(_kSessionActiveKey, true);
    _saveCurrentTick();
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _addSecondsToDate(DateTime.now(), 1);

      _saveCurrentTick();

      notifyListeners();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    _box.put(_kSessionActiveKey, false);
    _box.delete(_kLastTickKey);
    notifyListeners();
  }

  void toggleTimer() {
    if (_isRunning) {
      stopTimer();
    } else {
      startTimer();
    }
  }

  int get totalActiveDays {
    int count = 0;
    for (var key in _box.keys) {
      if (key == _kSessionActiveKey || key == _kLastTickKey) continue;

      if ((_box.get(key, defaultValue: 0) as int) > 0) {
        count++;
      }
    }
    return count;
  }

  int get totalSeconds {
    int total = 0;
    for (var key in _box.keys) {
      if (key == _kSessionActiveKey || key == _kLastTickKey) continue;

      final val = _box.get(key, defaultValue: 0);
      if (val is int) total += val;
    }
    return total;
  }

  int get currentStreak {
    int streak = 0;
    final now = DateTime.now();

    if (dailySeconds > 0) streak++;

    int daysBack = 1;
    while (true) {
      final pastDate = now.subtract(Duration(days: daysBack));
      final key = _getDateKey(pastDate);
      final val = _box.get(key, defaultValue: 0);

      if ((val is int ? val : 0) > 0) {
        streak++;
        daysBack++;
      } else {
        break;
      }
    }
    return streak;
  }

  void _saveCurrentTick() {
    _box.put(_kLastTickKey, DateTime.now().toIso8601String());
  }

  int _getSecondsForDay(DateTime date) {
    return _box.get(_getDateKey(date), defaultValue: 0) as int;
  }

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  DateTime? getOldestEntryDate() {
    if (_box.isEmpty) return null;
    final keys = _box.keys.cast<String>().where(
      (k) => k != _kSessionActiveKey && k != _kLastTickKey,
    );

    DateTime? minDate;
    for (var key in keys) {
      final parts = key.split('-');
      if (parts.length == 3) {
        final date = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );
        if (minDate == null || date.isBefore(minDate)) minDate = date;
      }
    }
    return minDate;
  }

  List<int> getWeeklyData(DateTime startOfWeek) {
    List<int> data = [];
    for (int i = 0; i < 7; i++) {
      DateTime date = startOfWeek.add(Duration(days: i));
      data.add(_getSecondsForDay(date));
    }
    return data;
  }

  double getWeeklyAverage(DateTime startOfWeek) {
    final DateTime? firstEntry = getOldestEntryDate();
    if (firstEntry == null) return 0.0;
    final firstDayMidnight = DateTime(
      firstEntry.year,
      firstEntry.month,
      firstEntry.day,
    );
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    int totalSec = 0;
    int validDaysCount = 0;
    for (int i = 0; i < 7; i++) {
      final currentDay = startOfWeek.add(Duration(days: i));
      final currentDayMidnight = DateTime(
        currentDay.year,
        currentDay.month,
        currentDay.day,
      );
      if (currentDayMidnight.isAfter(todayMidnight)) continue;
      if (currentDayMidnight.isBefore(firstDayMidnight)) continue;
      final key = _getDateKey(currentDay);
      final val = _box.get(key, defaultValue: 0);
      totalSec += (val is int ? val : 0);
      validDaysCount++;
    }
    if (validDaysCount == 0) return 0.0;
    return totalSec / validDaysCount;
  }

  int getDaysCountWithData(DateTime startOfWeek) {
    int count = 0;
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      if (_box.containsKey(_getDateKey(date))) count++;
    }
    return count;
  }

  //used with data seeder
  void forceNotify() => notifyListeners();
}
