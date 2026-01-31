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
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: AppColor.pageBg(context),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                children: const [HomePage(), StatsPage()],
              ),
            ),
          ),

          Positioned(
            top: 2,
            left: 0,
            right: 0,
            bottom: 0,
            child: IgnorePointer(
              child: AnimatedOpacity(
                duration: AppAnimations.defaultDuration,
                opacity: isRunning ? 1.0 : 0.0,
                curve: Curves.easeInOut,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          AppDesign.radiusMainScreen,
                        ),
                        border: Border.all(
                          color: AppColor.neonBorder.withValues(alpha: 0.15),
                          width: 12.0,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          AppDesign.radiusMainScreen,
                        ),
                        border: Border.all(
                          color: AppColor.neonBorder.withValues(alpha: 0.4),
                          width: 6.0,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          AppDesign.radiusMainScreen,
                        ),
                        border: Border.all(
                          color: AppColor.neonBorder,
                          width: 1.5,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 0,
            right: 0,
            bottom: -1,
            child: Container(
              height: 90,
              decoration: BoxDecoration(
                color: AppColor.cardSurface(context),
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                border: AppColor.getAdaptiveBorder(context),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    asset: AppAssets.iconHome,
                    index: 0,
                    label: "Scrolly",
                  ),
                  _buildNavItem(
                    asset: AppAssets.iconStats,
                    index: 1,
                    label: "Statistics",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String asset,
    required int index,
    required String label,
  }) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
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
      ),
    );
  }
}
