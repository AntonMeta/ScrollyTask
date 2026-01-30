import 'package:flutter/material.dart';
import 'package:app/views/home_page.dart';
import 'package:app/views/stats_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: PageView(
        controller: _pageController,
        children: const [HomePage(), StatsPage()],
      ),
    );
  }
}
