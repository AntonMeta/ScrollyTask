/// Unit tests for [TimerService] and related helper functions.
///
/// These tests verify:
/// 1. Time formatting helpers (seconds to text, grand total).
/// 2. Core business logic including:
///    - Data persistence/retrieval with Hive (using temporary directories).
///    - Weekly data aggregation for charts.
///    - Streak calculation logic.
///
/// Note: Hive is initialized in a temporary directory to ensure test isolation
/// and avoid platform channel issues during unit testing.
library;

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/features/timer/timer_service.dart';
import 'package:app/views/stats_page.dart';
import 'package:hive/hive.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Timer Helpers Tests', () {
    test('formatSecondsToText formats correctly', () {
      expect(formatSecondsToText(30), '<1m');
      expect(formatSecondsToText(60), '1m');
      expect(formatSecondsToText(3665), '1h 1m');
      expect(formatSecondsToText(7200), '2h');
    });

    test('formatGrandTotal formats correctly', () {
      expect(formatGrandTotal(0), '0m');
      expect(formatGrandTotal(3600), '1h 0m');
      expect(formatGrandTotal(90000), '1d 1h 0m');
    });
  });

  group('TimerService Logic Integration', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_test_');
      Hive.init(tempDir.path);
      await Hive.openBox('timer_data');
    });

    tearDown(() async {
      await Hive.close();
      await tempDir.delete(recursive: true);
    });

    test('getWeeklyData returns correct values from Hive', () async {
      final box = Hive.box('timer_data');
      final now = DateTime.now();
      String getKey(DateTime d) => "${d.year}-${d.month}-${d.day}";

      final todayKey = getKey(now);
      final yesterdayKey = getKey(now.subtract(const Duration(days: 1)));
      final twoDaysAgoKey = getKey(now.subtract(const Duration(days: 2)));

      await box.put(todayKey, 3600);
      await box.put(yesterdayKey, 7200);
      await box.put(twoDaysAgoKey, 1800);

      final service = TimerService();

      expect(
        service.dailySeconds,
        3600,
        reason: "Powinien widzieć 3600s dzisiaj",
      );
      expect(service.totalSeconds, 3600 + 7200 + 1800);

      final startOfWeek = now.subtract(const Duration(days: 2));
      final weeklyData = service.getWeeklyData(startOfWeek);

      expect(weeklyData[0], 1800);
      expect(weeklyData[1], 7200);
      expect(weeklyData[2], 3600);
      expect(weeklyData[3], 0);
    });

    test('calculate streak correctly', () async {
      final box = Hive.box('timer_data');
      final now = DateTime.now();
      String getKey(DateTime d) => "${d.year}-${d.month}-${d.day}";

      await box.put(getKey(now), 100);
      await box.put(getKey(now.subtract(const Duration(days: 1))), 100);

      await box.put(getKey(now.subtract(const Duration(days: 3))), 100);

      final service = TimerService();

      expect(service.currentStreak, 2);
    });
  });
}
