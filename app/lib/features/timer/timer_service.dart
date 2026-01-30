import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TimerService extends ChangeNotifier {
  Timer? _timer;
  bool _isRunning = false;

  final Box _box = Hive.box('timer_data');

  int get dailySeconds => _getSecondsForDay(DateTime.now());
  bool get isRunning => _isRunning;

  String get formattedTime {
    int totalSeconds = dailySeconds;

    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    if (minutes < 1) {
      return "${seconds}s";
    } else if (hours < 1) {
      return "${minutes}m ${seconds}s";
    } else {
      return "${hours}h ${minutes}m ${seconds}s";
    }
  }

  void startTimer() {
    if (_isRunning) return;
    _isRunning = true;
    notifyListeners();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _addSecondToHistory();

      notifyListeners();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
    notifyListeners();
  }

  void toggleTimer() {
    if (_isRunning) {
      stopTimer();
    } else {
      startTimer();
    }
  }

  void _addSecondToHistory() {
    final String todayKey = _getDateKey(DateTime.now());

    final int currentSeconds = _box.get(todayKey, defaultValue: 0);

    _box.put(todayKey, currentSeconds + 1);
  }

  int getSecondsForDay(DateTime date) {
    return _getSecondsForDay(date);
  }

  int _getSecondsForDay(DateTime date) {
    final String key = _getDateKey(date);
    return _box.get(key, defaultValue: 0);
  }

  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  List<int> getWeeklyData(DateTime startOfWeek) {
    return List.generate(7, (index) {
      final date = startOfWeek.add(Duration(days: index));
      return _getSecondsForDay(date);
    });
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

    int totalSeconds = 0;
    int validDaysCount = 0;

    for (int i = 0; i < 7; i++) {
      final currentDay = startOfWeek.add(Duration(days: i));
      final currentDayMidnight = DateTime(
        currentDay.year,
        currentDay.month,
        currentDay.day,
      );

      if (currentDayMidnight.isAfter(todayMidnight)) {
        continue;
      }

      if (currentDayMidnight.isBefore(firstDayMidnight)) {
        continue;
      }

      final key = _getDateKey(currentDay);
      final int seconds = _box.get(key, defaultValue: 0);

      totalSeconds += seconds;
      validDaysCount++;
    }

    if (validDaysCount == 0) return 0.0;

    return totalSeconds / validDaysCount;
  }

  int getDaysCountWithData(DateTime startOfWeek) {
    int count = 0;
    for (int i = 0; i < 7; i++) {
      final date = startOfWeek.add(Duration(days: i));
      if (_box.containsKey(_getDateKey(date))) {
        count++;
      }
    }
    return count;
  }

  DateTime? getOldestEntryDate() {
    if (_box.isEmpty) return null;

    final keys = _box.keys.cast<String>();
    DateTime? minDate;

    for (var key in keys) {
      final parts = key.split('-');
      if (parts.length == 3) {
        final date = DateTime(
          int.parse(parts[0]),
          int.parse(parts[1]),
          int.parse(parts[2]),
        );

        if (minDate == null || date.isBefore(minDate)) {
          minDate = date;
        }
      }
    }
    return minDate;
  }

  int get currentStreak {
    int streak = 0;
    final now = DateTime.now();

    if (dailySeconds > 0) {
      streak++;
    }

    int daysBack = 1;
    while (true) {
      final pastDate = now.subtract(Duration(days: daysBack));
      final key = _getDateKey(pastDate);

      final int seconds = _box.get(key, defaultValue: 0);

      if (seconds > 0) {
        streak++;
        daysBack++;
      } else {
        break;
      }
    }

    return streak;
  }

  int get totalActiveDays {
    int count = 0;
    for (var key in _box.keys) {
      final int seconds = _box.get(key, defaultValue: 0);
      if (seconds > 0) {
        count++;
      }
    }
    return count;
  }

  int get totalSeconds {
    int total = 0;
    for (var key in _box.keys) {
      final int seconds = _box.get(key, defaultValue: 0);
      total += seconds;
    }
    return total;
  }

  void debugAddFakeHistory() {
    _box.clear();

    final now = DateTime.now();

    void addDay(int daysAgo, int minutes) {
      final date = now.subtract(Duration(days: daysAgo));
      final key = _getDateKey(date);
      _box.put(key, minutes * 60);
    }

    addDay(0, 68);
    addDay(1, 60);

    addDay(3, 90);
    addDay(4, 100);

    addDay(6, 40);
    addDay(7, 55);

    addDay(9, 110);
    addDay(10, 24 * 60 - 1);
    addDay(11, 110);
    addDay(12, 90);

    print("✅ Fake dane dodane! Zrestartuj apkę.");
    notifyListeners();
  }
}
