import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';

class DataSeeder {
  static Future<void> seedHistory() async {
    final box = Hive.box('timer_data');

    await box.clear();

    final now = DateTime.now();
    final random = Random();

    for (int i = 0; i < 14; i++) {
      final date = now.subtract(Duration(days: i));
      final key = "${date.year}-${date.month}-${date.day}";

      if (i % 3 == 0 && i != 0) continue;

      final int seconds = (15 + random.nextInt(225)) * 60;

      await box.put(key, seconds);
    }
  }
}
