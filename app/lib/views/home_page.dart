import 'package:app/constants/app_strings.dart';
import 'package:app/features/utils/ui_scaler.dart'; 
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
    final isVerySmallHeight = screenHeight < 700;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppDesign.elementPadding.s(context),
            AppDesign.elementPadding.s(context),
            AppDesign.elementPadding.s(context),
            90,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// TITLE
              Text(
                AppStrings.homeTitle,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColor.textPrimary(context),
                  fontSize: 36.s(context),
                ),
              ),

              const Spacer(flex: 2),

              /// TIMER CARD
              Container(
                constraints: BoxConstraints(
                  minHeight: AppDesign.timerCardMinHeight.s(context),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 15.s(context),
                  horizontal: 25.s(context),
                ),
                decoration: BoxDecoration(
                  color: AppColor.cardSurface(context),
                  borderRadius: BorderRadius.circular(16.s(context)),
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
                          width: AppDesign.svgDim.s(context),
                          height: AppDesign.svgDim.s(context),
                          colorFilter: const ColorFilter.mode(
                            AppColor.secondary,
                            BlendMode.srcIn,
                          ),
                        ),
                        SizedBox(width: 5.s(context)),
                        Text(
                          AppStrings.homeLabel,
                          style: AppTextStyles.homeLabel.copyWith(
                            fontSize: 18.s(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.s(context)),
                    Text(
                      timerService.formattedTime,
                      style: AppTextStyles.homeTimer.copyWith(
                        color: AppColor.secondary,
                        fontSize: 40.s(context),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              /// SCROLLY PIC
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
                      height: isVerySmallHeight
                          ? AppDesign.scrollyHeightSmall.s(context)
                          : AppDesign.scrollyHeightBig.s(context),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              /// FOCUS BUTTON
              SizedBox(
                width: AppDesign.buttonWidth.s(context),
                height: AppDesign.buttonHeight.s(context),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.cardSurface(context),
                    side: isDark
                        ? const BorderSide(color: Colors.white24)
                        : BorderSide.none,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDesign.radiusButton.s(context),
                      ),
                    ),
                  ),
                  onPressed: () => timerService.toggleTimer(),
                  child: Text(
                    timerService.isRunning
                        ? AppStrings.tapToUnfocus
                        : AppStrings.tapToFocus,
                    style: AppTextStyles.homeButton.copyWith(
                      fontSize: 14.s(context),
                    ),
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
