import 'package:app/constants/app_design.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/timer/timer_service.dart';
import 'package:app/views/home_page.dart';
import 'package:app/views/stats_page.dart';
import '../constants/app_color.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final isRunning = context.watch<TimerService>().isRunning;
    return Scaffold(
      backgroundColor: AppColor.secondary,

      body: AnimatedContainer(
        duration: AppAnimations.defaultDuration,
        curve: Curves.easeInOut,
        margin: isRunning ? const EdgeInsets.only(top: 2.0) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: AppColor.secondary,
          borderRadius: isRunning
              ? BorderRadius.circular(AppDesign.radiusMainScreen)
              : BorderRadius.zero,
          border: isRunning
              ? Border.all(color: AppColor.neonBorder, width: 7)
              : null,
        ),
        child: PageView(
          controller: _pageController,
          children: const [HomePage(), StatsPage()],
        ),
      ),
    );
  }
}
