import 'package:flutter/material.dart';

class AppColor {
  static const Color _navyBlue = Color(0xFF0B2B41); 
  static const Color _cream = Color(0xFFFFF9E7); 
  static const Color _neonCyan = Color(0xFF3DF1FF); 
  static const Color _neonRed = Color(0xFFFF5252); 
  static const Color _darkBg = Color(0xFF121212); 
  static const Color _lightCard = Color(0xFFF4DCAD);
  static const Color _mediumBlue = Color(0xFF51697A);
  static const Color _darkGrey = Color(0xFF545454);
  static const Color _lightBrown = Color(0xFFBFAC85);
  static const Color _darkOrange = Color(0xFFD1B888);

  static const Color chartWeekday = _darkGrey;
  static const Color navBar = _lightBrown;
  static const Color secondary = _cream;
  static const Color neonBorder = _neonCyan;
  static const Color redNeon = _neonRed;
  static const Color pill = _darkOrange;

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color primary(BuildContext context) {
    return _navyBlue;
  }

  static Color pageBg(BuildContext context) {
    return isDarkMode(context) ? _darkBg : _cream;
  }

  static Color cardSurface(BuildContext context) {
    return _navyBlue;
  }

  static Color textPrimary(BuildContext context) {
    return isDarkMode(context) ? _cream : _navyBlue;
  }

  static Color textSecondary(BuildContext context) {
    return isDarkMode(context) ? _navyBlue : _cream;
  }

  static Color statsCardDark(BuildContext context) {
    return isDarkMode(context) ? _mediumBlue : _navyBlue;
  }

  static Color statsCardLight(BuildContext context) {
    return isDarkMode(context) ? _navyBlue : _lightCard;
  }

  static Color statsCardDarkText(BuildContext context) {
    return isDarkMode(context) ? pill : _cream;
  }

  static Color darkPill(BuildContext context) {
    return isDarkMode(context) ? _navyBlue : pill;
  }

  static Color lightPill(BuildContext context) {
    return isDarkMode(context) ? pill : _navyBlue;
  }

  static Color chartBar(BuildContext context) {
    return isDarkMode(context) ? pill : _mediumBlue;
  }

  static Color untouchedBar(BuildContext context) {
    return isDarkMode(context) ? _mediumBlue : pill;
  }

  static Border? getAdaptiveBorder(BuildContext context) {
    if (isDarkMode(context)) {
      return Border.all(
        color: Colors.white.withAlpha(40), 
        width: 1.0,
      );
    }
    return null;
  }
}
