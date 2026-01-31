import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart';

class AppTextStyles {
  static TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColor.primary,
  );

  ///home page
  static TextStyle homeTimer = GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    color: AppColor.secondary,
  );
  static TextStyle homeLabel = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColor.secondary,
  );
  static TextStyle homeButton = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColor.secondary,
  );

  ///stats page
  static TextStyle darkStatsLabel = GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: AppColor.secondary,
  );
  static TextStyle lightStatsLabel = GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
  );
  static TextStyle darkStatsVal = GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    color: AppColor.secondary,
  );
  static TextStyle lightStatsVal = GoogleFonts.poppins(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
  );
  static TextStyle darkPill = GoogleFonts.poppins(
    fontSize: 12.28,
    fontWeight: FontWeight.w500,
    color: AppColor.secondary,
  );
  static TextStyle lightPill = GoogleFonts.poppins(
    fontSize: 12.25,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
  );

  static TextStyle chartLabel = GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
  );
  static TextStyle chartVal = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColor.primary,
  );
  static TextStyle chartAvg = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
  );
  static TextStyle chartWeekday = GoogleFonts.poppins(
    fontSize: 13.14,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
  );
}
