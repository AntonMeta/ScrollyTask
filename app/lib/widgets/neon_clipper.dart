import 'package:flutter/material.dart';
import 'dart:ui';

class NeonClipper extends StatelessWidget {
  final Widget child;
  final Color color;
  final double blurRadius;
  final double spread;

  const NeonClipper({
    super.key,
    required this.child,
    required this.color,
    this.blurRadius = 15.0,
    this.spread = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: Offset(spread, spread),
          child: _buildGlow(),
        ),
        Transform.translate(
          offset: Offset(-spread, spread),
          child: _buildGlow(),
        ),
        Transform.translate(
          offset: Offset(spread, -spread),
          child: _buildGlow(),
        ),
        Transform.translate(
          offset: Offset(-spread, -spread),
          child: _buildGlow(),
        ),

        child,
      ],
    );
  }

  Widget _buildGlow() {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: child,
      ),
    );
  }
}
