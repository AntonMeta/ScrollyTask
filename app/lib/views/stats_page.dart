import 'package:app/constants/app_assets.dart';
import 'package:app/constants/app_color.dart';
import 'package:app/constants/app_design.dart';
import 'package:app/constants/app_strings.dart';
import 'package:app/constants/app_text_styles.dart';
import 'package:app/features/timer/timer_service.dart';
import 'package:app/features/utils/ui_scaler.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final timerService = context.watch<TimerService>();
    final int streak = timerService.currentStreak;
    final int totalDays = timerService.totalActiveDays;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppDesign.elementPadding.s(context),
              AppDesign.elementPadding.s(context),
              AppDesign.elementPadding.s(context),
              90.s(context),
            ),
            child: Column(
              children: [
                /// TITLE
                Text(
                  AppStrings.statsTitle,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColor.textPrimary(context),
                    fontSize: 34.s(context),
                  ),
                ),

                SizedBox(height: 25.s(context)),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// STREAK CARD
                    _buildCard(
                      context,
                      darkTheme: true,
                      svg: AppAssets.iconFlame,
                      value: "$streak",
                      label: AppStrings.streakLabel,
                      subLabel: "$totalDays days overall",
                    ),
                    SizedBox(width: 15.s(context)),

                    ///CURR FOCUS CARD
                    _buildCard(
                      context,
                      svg: AppAssets.iconTime,
                      value: formatSecondsToText(timerService.dailySeconds),
                      label: AppStrings.currentFocusLabel,
                      subLabel:
                          "${formatGrandTotal(timerService.totalSeconds)} overall",
                    ),
                  ],
                ),

                SizedBox(height: 25.s(context)),

                const _WeeklyChartSection(),

                SizedBox(height: 10.s(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, {
    bool darkTheme = false,
    required String svg,
    required String value,
    required String label,
    required String subLabel,
  }) {
    /// local styles
    final double labelSize = 15.s(context);
    final double valueSize = 26.s(context);
    final double pillTextSize = 11.s(context);

    return Expanded(
      child: Container(
        height: AppDesign.statsCardHeight.s(context),
        padding: EdgeInsets.all(12.s(context)),
        decoration: BoxDecoration(
          color: darkTheme
              ? AppColor.primary(context)
              : AppColor.statsCardLight(context),
          border: AppColor.getAdaptiveBorder(context),
          borderRadius: BorderRadius.circular(AppDesign.radiusCard.s(context)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.s(context)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    label,
                    style:
                        (darkTheme
                                ? AppTextStyles.darkStatsLabel.copyWith(
                                    color: AppColor.statsCardDarkText(context),
                                  )
                                : AppTextStyles.lightStatsLabel.copyWith(
                                    color: AppColor.textPrimary(context),
                                  ))
                            .copyWith(fontSize: labelSize),
                  ),
                ),
                SizedBox(height: 10.s(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      svg,
                      width: AppDesign.svgDim.s(context),
                      height: AppDesign.svgDim.s(context),
                      colorFilter: ColorFilter.mode(
                        darkTheme
                            ? AppColor.statsCardDarkText(context)
                            : AppColor.textPrimary(context),
                        BlendMode.srcIn,
                      ),
                    ),
                    SizedBox(width: 5.s(context)),
                    Expanded(
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(
                          value,
                          style:
                              (darkTheme
                                      ? AppTextStyles.darkStatsVal.copyWith(
                                          color: AppColor.statsCardDarkText(
                                            context,
                                          ),
                                        )
                                      : AppTextStyles.lightStatsVal.copyWith(
                                          color: AppColor.textPrimary(context),
                                        ))
                                  .copyWith(fontSize: valueSize),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: 8.s(context),
                vertical: 6.s(context),
              ),
              decoration: BoxDecoration(
                color: darkTheme
                    ? AppColor.lightPill(context)
                    : AppColor.darkPill(context),
                borderRadius: BorderRadius.circular(
                  AppDesign.radiusPill.s(context),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                subLabel,
                style:
                    (darkTheme
                            ? AppTextStyles.darkPill.copyWith(
                                color: AppColor.textSecondary(context),
                              )
                            : AppTextStyles.lightPill.copyWith(
                                color: AppColor.textPrimary(context),
                              ))
                        .copyWith(fontSize: pillTextSize),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChartSection extends StatelessWidget {
  const _WeeklyChartSection();

  @override
  Widget build(BuildContext context) {
    final timerService = context.watch<TimerService>();
    final oldestDate = timerService.getOldestEntryDate();
    int pageCount = 1;

    if (oldestDate != null) {
      final now = DateTime.now();
      final currentMondayDate = now.subtract(Duration(days: now.weekday - 1));
      final currentMonday = DateTime(
        currentMondayDate.year,
        currentMondayDate.month,
        currentMondayDate.day,
      );
      final oldestMondayDate = oldestDate.subtract(
        Duration(days: oldestDate.weekday - 1),
      );
      final oldestMonday = DateTime(
        oldestMondayDate.year,
        oldestMondayDate.month,
        oldestMondayDate.day,
      );
      final differenceInDays = currentMonday.difference(oldestMonday).inDays;
      if (differenceInDays >= 0) pageCount = (differenceInDays / 7).round() + 1;
    }

    return Container(
      height: AppDesign.statsChartHeight.s(context),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.statsCardLight(context),
        borderRadius: BorderRadius.circular(AppDesign.radiusChart.s(context)),
        border: AppColor.getAdaptiveBorder(context),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDesign.radiusChart.s(context)),
        child: PageView.builder(
          reverse: true,
          itemCount: pageCount,
          controller: PageController(initialPage: 0),
          physics: pageCount > 1
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _SingleWeekPage(weekOffset: index);
          },
        ),
      ),
    );
  }
}

class _SingleWeekPage extends StatefulWidget {
  final int weekOffset;
  const _SingleWeekPage({required this.weekOffset});

  @override
  State<_SingleWeekPage> createState() => _SingleWeekPageState();
}

class _SingleWeekPageState extends State<_SingleWeekPage> {
  final List<String> weekDays = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final timerService = context.watch<TimerService>();
    final now = DateTime.now();
    final startOfWeek = now
        .subtract(Duration(days: 7 * widget.weekOffset))
        .subtract(
          Duration(
            days:
                now.subtract(Duration(days: 7 * widget.weekOffset)).weekday - 1,
          ),
        );
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    final weeklyData = timerService.getWeeklyData(startOfWeek);
    final averageVal = timerService.getWeeklyAverage(startOfWeek);
    final daysWithDataCount = timerService.getDaysCountWithData(startOfWeek);

    ///title logic
    final isCurrentWeek = widget.weekOffset == 0;
    final isLastWeek = widget.weekOffset == 1;
    String titleText;
    if (isCurrentWeek == isLastWeek) {
      if (touchedIndex != -1) {
        titleText =
            "Focus time\n${_formatDateRange(startOfWeek, endOfWeek)} ${_getFullDayName(touchedIndex)}";
      } else {
        titleText =
            "Average focus time\n${_formatDateRange(startOfWeek, endOfWeek)}";
      }
    } else if (touchedIndex != -1) {
      titleText =
          "Focus time\n${isLastWeek ? "Last " : ''}${_getFullDayName(touchedIndex)}";
    } else {
      titleText = "Average focus time\n${isCurrentWeek ? "This" : "Last"} week";
    }

    final currentValue = touchedIndex == -1
        ? formatSecondsToText(averageVal.floor())
        : formatSecondsToText(weeklyData[touchedIndex]);

    return GestureDetector(
      onTap: () => setState(() => touchedIndex = -1),
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.all(20.s(context)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleText,
              style: AppTextStyles.chartLabel.copyWith(
                color: AppColor.textPrimary(context),
                fontSize: 18.s(context),
              ),
            ),
            SizedBox(height: 8.s(context)),
            Text(
              currentValue,
              style: AppTextStyles.chartVal.copyWith(
                color: AppColor.textPrimary(context),
                fontSize: 22.s(context),
              ),
            ),
            SizedBox(height: 25.s(context)),
            Expanded(
              child: BarChart(
                BarChartData(
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      if (averageVal > 0 && daysWithDataCount > 1)
                        HorizontalLine(
                          y: averageVal / 60,
                          color: AppColor.textPrimary(context),
                          strokeWidth: 2.s(context),
                          dashArray: [5, 5],
                          label: HorizontalLineLabel(
                            show: true,
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(
                              bottom: 5.s(context),
                              left: 0,
                            ),
                            style: AppTextStyles.chartAvg.copyWith(
                              color: AppColor.textPrimary(context),
                              fontSize: 11.s(context),
                            ),
                            labelResolver: (line) => "avg",
                          ),
                        ),
                    ],
                  ),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (_, _, _, _) => null,
                    ),
                    touchCallback: (event, response) {
                      setState(() {
                        if (response?.spot != null) {
                          touchedIndex = response!.spot!.touchedBarGroupIndex;
                        } else {
                          touchedIndex = -1;
                        }
                      });
                    },
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30.s(context),
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < weekDays.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 10.0.s(context)),
                              child: Text(
                                weekDays[index],
                                style: AppTextStyles.chartWeekday.copyWith(
                                  color: AppColor.textPrimary(context),
                                  fontSize: 12.s(context),
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  barGroups: List.generate(weeklyData.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: weeklyData[index] / 60,
                          color: index == touchedIndex
                              ? AppColor.chartBar(context)
                              : AppColor.untouchedBar(context),
                          width: 30.s(context),
                          borderRadius: BorderRadius.circular(10.s(context)),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFullDayName(int index) => [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ][index];

  String _formatDateRange(DateTime start, DateTime end) {
    String f(DateTime d) =>
        "${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}";
    return "${f(start)}-${f(end)}";
  }
}

/// formatting funcs
String formatSecondsToText(int totalSeconds) {
  if (totalSeconds > 0 && totalSeconds < 60) return "<1m";
  final int totalMinutes = totalSeconds ~/ 60;
  if (totalMinutes < 60) return "${totalMinutes}m";
  final int hours = totalMinutes ~/ 60;
  final int minutes = totalMinutes % 60;
  if (minutes == 0) return "${hours}h";
  return "${hours}h ${minutes}m";
}

String formatGrandTotal(int totalSeconds) {
  if (totalSeconds == 0) return "0m";
  final int days = totalSeconds ~/ (24 * 3600);
  final int hours = (totalSeconds % (24 * 3600)) ~/ 3600;
  final int minutes = (totalSeconds % 3600) ~/ 60;
  if (days > 0) {
    return "${days}d ${hours}h ${minutes}m";
  } else if (hours > 0) {
    return "${hours}h ${minutes}m";
  } else {
    return "${minutes}m";
  }
}
