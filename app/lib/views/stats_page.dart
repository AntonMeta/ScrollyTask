import 'package:app/constants/app_assets.dart';
import 'package:app/constants/app_color.dart';
import 'package:app/constants/app_design.dart';
import 'package:app/constants/app_strings.dart';
import 'package:app/constants/app_text_styles.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:app/features/timer/timer_service.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final timerService = context.watch<TimerService>();

    final int streak = timerService.currentStreak;
    final int totalDays = timerService.totalActiveDays;

    return Scaffold(
      backgroundColor: Colors.transparent,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     context.read<TimerService>().debugAddFakeHistory();
      //   },
      //   backgroundColor: Colors.red,
      //   child: const Icon(Icons.bug_report),
      // ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 90),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.statsTitle,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColor.textPrimary(context),
                ),
              ),
              Spacer(flex: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCard(
                    context,
                    darkTheme: true,
                    svg: AppAssets.iconFlame,
                    value: "$streak",
                    label: AppStrings.streakLabel,
                    subLabel: "$totalDays days overall",
                  ),
                  SizedBox(width: 20),
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
              Spacer(flex: 1),

              const _WeeklyChartSection(),
              Spacer(flex: 1),
            ],
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
    return Expanded(
      child: Container(
        height: 190,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: darkTheme
              ? AppColor.primary(context)
              : AppColor.statsCardLight(context),
          border: AppColor.getAdaptiveBorder(context),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 20,
          children: [
            Container(
              padding: EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12,
                children: [
                  Text(
                    label,
                    style: darkTheme
                        ? AppTextStyles.darkStatsLabel.copyWith(
                            color: AppColor.statsCardDarkText(context),
                          )
                        : AppTextStyles.lightStatsLabel.copyWith(
                            color: AppColor.textPrimary(context),
                          ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset(
                        svg,
                        width: AppDesign.svgDim,
                        height: AppDesign.svgDim,
                        colorFilter: ColorFilter.mode(
                          darkTheme
                              ? AppColor.statsCardDarkText(context)
                              : AppColor.textPrimary(context),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        value,
                        style: darkTheme
                            ? AppTextStyles.darkStatsVal.copyWith(
                                color: AppColor.statsCardDarkText(context),
                              )
                            : AppTextStyles.lightStatsVal.copyWith(
                                color: AppColor.textPrimary(context),
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: darkTheme
                    ? AppColor.lightPill(context)
                    : AppColor.darkPill(context),
                borderRadius: BorderRadius.circular(11.5),
              ),
              child: Text(
                subLabel,
                style: darkTheme
                    ? AppTextStyles.darkPill.copyWith(
                        color: AppColor.textSecondary(context),
                      )
                    : AppTextStyles.lightPill.copyWith(
                        color: AppColor.textPrimary(context),
                      ),
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

      if (differenceInDays >= 0) {
        final weeksDiff = (differenceInDays / 7).round();
        pageCount = weeksDiff + 1;
      }
    }
    return Container(
      height: 328,
      width: double.infinity,

      decoration: BoxDecoration(
        color: AppColor.statsCardLight(context),
        borderRadius: BorderRadius.circular(47),
        border: AppColor.getAdaptiveBorder(context),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(47),
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
    final currentViewDate = now.subtract(Duration(days: 7 * widget.weekOffset));
    final startOfWeek = currentViewDate.subtract(
      Duration(days: currentViewDate.weekday - 1),
    );
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    final List<int> weeklyData = timerService.getWeeklyData(startOfWeek);
    final double averageVal = timerService.getWeeklyAverage(startOfWeek);

    final int daysWithDataCount = timerService.getDaysCountWithData(
      startOfWeek,
    );

    final bool isCurrentWeek = widget.weekOffset == 0;
    final bool isLastWeek = widget.weekOffset == 1;

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

    final String currentValue = touchedIndex == -1
        ? formatSecondsToText(averageVal.floor())
        : formatSecondsToText(weeklyData[touchedIndex]);

    return GestureDetector(
      onTap: () {
        setState(() {
          touchedIndex = -1;
        });
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColor.statsCardLight(context),
          borderRadius: BorderRadius.circular(47),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titleText,
              style: AppTextStyles.chartLabel.copyWith(
                color: AppColor.textPrimary(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentValue,
              style: AppTextStyles.chartVal
                ..copyWith(color: AppColor.textPrimary(context)),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 170,
              child: BarChart(
                BarChartData(
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      if (averageVal > 0 && daysWithDataCount > 1)
                        HorizontalLine(
                          y: averageVal / 60,
                          color: AppColor.textPrimary(context),
                          strokeWidth: 2,
                          dashArray: [5, 5],
                          label: HorizontalLineLabel(
                            show: true,
                            alignment: Alignment.topLeft,
                            padding: EdgeInsets.only(bottom: 5, left: 0),
                            style: AppTextStyles.chartAvg.copyWith(
                              color: AppColor.textPrimary(context),
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
                    touchCallback: (FlTouchEvent event, barTouchResponse) {
                      setState(() {
                        if (barTouchResponse != null &&
                            barTouchResponse.spot != null) {
                          touchedIndex =
                              barTouchResponse.spot!.touchedBarGroupIndex;
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
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < weekDays.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Text(
                                weekDays[index],
                                style: AppTextStyles.chartWeekday.copyWith(
                                  color: AppColor.textPrimary(context),
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
                          width: 33,
                          borderRadius: BorderRadius.circular(10),
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

  String _getFullDayName(int index) {
    const days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      "Sunday",
    ];
    return days[index];
  }

  String _formatDateRange(DateTime start, DateTime end) {
    String format(DateTime d) {
      final day = d.day.toString().padLeft(2, '0');
      final month = d.month.toString().padLeft(2, '0');
      return "$day.$month";
    }

    return "${format(start)}-${format(end)}";
  }
}

String formatSecondsToText(int totalSeconds) {
  if (totalSeconds > 0 && totalSeconds < 60) {
    return "<1m";
  }

  final int totalMinutes = totalSeconds ~/ 60;

  if (totalMinutes < 60) {
    return "${totalMinutes}m";
  } else {
    final int hours = totalMinutes ~/ 60;
    final int minutes = totalMinutes % 60;

    if (minutes == 0) {
      return "${hours}h";
    }
    return "${hours}h ${minutes}m";
  }
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
