import 'package:flutter/material.dart';

class UIScaler {
  static const double designWidth = 430.0;

  static double scale(BuildContext context, double value) {
    final screenWidth = MediaQuery.of(context).size.width;

    final double scaleFactor = (screenWidth / designWidth).clamp(0.85, 1.1);

    return value * scaleFactor;
  }
}

extension ScaleExtension on num {
  double s(BuildContext context) => UIScaler.scale(context, toDouble());
}
