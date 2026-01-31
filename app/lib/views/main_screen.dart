import 'package:app/constants/app_assets.dart';
import 'package:app/constants/app_design.dart';
import 'package:app/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  int _currentIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: AppAnimations.defaultDuration,
      curve: Curves.fastEaseInToSlowEaseOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = context.watch<TimerService>().isRunning;
    return Scaffold(
      backgroundColor: AppColor.secondary,

      body: Stack(
        children: [
          AnimatedContainer(
            duration: AppAnimations.defaultDuration,
            curve: Curves.easeInOut,
            margin: isRunning
                ? const EdgeInsets.only(top: 2.0)
                : EdgeInsets.zero,
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
              onPageChanged: _onPageChanged,
              children: const [HomePage(), StatsPage()],
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 87,
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(AppAssets.iconHome, 0, "Scrolly"),
                  _buildNavItem(AppAssets.iconStats, 1, "Statistics"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String asset, int index, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            asset,
            width: 22,
            colorFilter: ColorFilter.mode(
              isSelected ? AppColor.navBar : AppColor.secondary,
              BlendMode.srcIn,
            ),
          ),
          Text(
            label,
            style: isSelected
                ? AppTextStyles.navBarActive
                : AppTextStyles.navBar,
          ),
        ],
      ),
    );
  }
}
