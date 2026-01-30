import 'package:app/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:app/features/timer/timer_service.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_color.dart';
import '../constants/app_assets.dart';
import '../constants/app_design.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final timerService = context.watch<TimerService>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          spacing: AppDesign.homeSpacing,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                AppStrings.homeTitle,
                style: AppTextStyles.titleLarge,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: AppDesign.timerCardWidth,
              height: AppDesign.timerCardHeight,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: BorderRadius.circular(AppDesign.radiusCard),
              ),
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 5,
                    children: [
                      SvgPicture.asset(
                        AppAssets.iconTime,
                        width: 26,
                        height: 26,
                        colorFilter: const ColorFilter.mode(
                          AppColor.secondary,
                          BlendMode.srcIn,
                        ),
                      ),
                      Text(
                        AppStrings.homeLabel,
                        style: AppTextStyles.homeLabel,
                      ),
                    ],
                  ),
                  Text(
                    timerService.formattedTime,
                    style: AppTextStyles.homeTimer,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => timerService.toggleTimer(),
              child: AnimatedSwitcher(
                duration: AppAnimations.defaultDuration,
                switchInCurve: Curves.elasticOut,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Image.asset(
                  timerService.isRunning
                      ? AppAssets.scrollyHappy
                      : AppAssets.scrollyAngry,
                  key: ValueKey(timerService.isRunning),
                  height: 240,
                ),
              ),
            ),
            SizedBox(
              width: AppDesign.focusButtonWidth,
              height: AppDesign.focusButtonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDesign.radiusButton),
                  ),
                ),
                onPressed: () => timerService.toggleTimer(),
                child: Text(
                  timerService.isRunning
                      ? AppStrings.tapToUnfocus
                      : AppStrings.tapToFocus,
                  style: AppTextStyles.homeButton,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
