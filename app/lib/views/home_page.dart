import 'package:app/constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:app/features/timer/timer_service.dart';
import '../constants/app_text_styles.dart';
import '../constants/app_color.dart';
import '../constants/app_assets.dart';
import '../constants/app_design.dart';
import '../widgets/neon_clipper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final timerService = context.watch<TimerService>();
    final isDark = AppColor.isDarkMode(context);

    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.homeTitle,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColor.textPrimary(context),
                ),
              ),
              const Spacer(flex: 2),
              Container(
                constraints: const BoxConstraints(minHeight: 120),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 25,
                ),
                decoration: BoxDecoration(
                  color: AppColor.cardSurface(context),
                  borderRadius: BorderRadius.circular(16),
                  border: AppColor.getAdaptiveBorder(context),
                ),
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.iconTime,
                          width: AppDesign.svgDim,
                          height: AppDesign.svgDim,
                          colorFilter: ColorFilter.mode(
                            AppColor.secondary,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          AppStrings.homeLabel,
                          style: AppTextStyles.homeLabel,
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      timerService.formattedTime,
                      style: AppTextStyles.homeTimer.copyWith(
                        color: AppColor.secondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              GestureDetector(
                onTap: () => timerService.toggleTimer(),
                child: AnimatedSwitcher(
                  duration: AppAnimations.defaultDuration,
                  switchInCurve: Curves.elasticOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
                  child: NeonClipper(
                    key: ValueKey(timerService.isRunning),

                    color: timerService.isRunning
                        ? AppColor.neonBorder
                        : AppColor.redNeon,

                    blurRadius: 7.0,
                    spread: 0.1,
                    child: Image.asset(
                      timerService.isRunning
                          ? AppAssets.scrollyHappy
                          : AppAssets.scrollyAngry,
                      height: isSmallScreen ? 180 : 240,
                    ),
                  ),
                ),
              ),
              Spacer(flex: 1),
              SizedBox(
                width: 160,
                height: 41,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.cardSurface(context),
                    side: isDark
                        ? const BorderSide(color: Colors.white24)
                        : BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
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
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
