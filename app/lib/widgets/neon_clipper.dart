import 'package:flutter/material.dart'; 
import 'dart:ui';


class NeonClipper extends StatelessWidget {
  final Widget child;
  final Color color;
  final double blurRadius;
  final double spread; // Jak bardzo ramka ma wystawać

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
        // WARSTWA 1: POŚWIATA (CIEŃ)
        // Przesuwamy lekko w 4 strony, żeby "pogrubić" kształt (symulacja stroke)
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

        // WARSTWA 2: ORYGINAŁ
        child,
      ],
    );
  }

  Widget _buildGlow() {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: blurRadius, sigmaY: blurRadius),
      child: ColorFiltered(
        // Ten tryb zamienia wszystkie widoczne piksele obrazka na jeden kolor
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        child: child,
      ),
    );
  }
}
