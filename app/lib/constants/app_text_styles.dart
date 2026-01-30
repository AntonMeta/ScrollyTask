import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_color.dart'; 

class AppTextStyles {
  
  static TextStyle titleLarge = GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColor.primary,
  );

  ///home_page
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
}
