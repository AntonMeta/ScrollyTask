import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/features/timer/timer_service.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final timerService = context.watch<TimerService>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Stats Page',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),

            _SummaryCards(todaySeconds: timerService.dailySeconds),

            const SizedBox(height: 40),

            const _WeeklyChartSection(),
          ],
        ),
      ),
    );
  }
}

class _SummaryCards extends StatelessWidget {
  final int todaySeconds;

  const _SummaryCards({required this.todaySeconds});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildCard(
            icon: Icons.local_fire_department,
            value: "34",
            label: "Current\ndays streak",
            subLabel: "32 days overall",
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCard(
            icon: Icons.access_time_filled,
            value: formatMinutes(todaySeconds ~/ 60),
            label: "Focus\ntime today",
            subLabel: "3d 15h 32m overall",
          ),
        ),
      ],
    );
  }

  Widget _buildCard({
    required IconData icon,
    required String value,
    required String label,
    required String subLabel,
  }) {
    return Container(
      height: 190,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(7),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 19,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(icon, size: 30),
                    SizedBox(width: 5),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(11.5),
            ),
            child: Text(
              subLabel,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

class _WeeklyChartSection extends StatefulWidget {
  const _WeeklyChartSection();

  @override
  State<_WeeklyChartSection> createState() => _WeeklyChartSectionState();
}

class _WeeklyChartSectionState extends State<_WeeklyChartSection> {
  final List<int> weeklyData = [15, 45, 120, 100, 60, 30, 0];
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
    final String currentTitle = touchedIndex == -1
        ? "Average focus time\nThis week"
        : "Focus time\n${_getFullDayName(touchedIndex)}";

    final double averageVal = _calculateDoubleAverage();

    final String currentValue = touchedIndex == -1
        ? formatMinutes(averageVal.round())
        : formatMinutes(weeklyData[touchedIndex]);

    return GestureDetector(
      onTap: () {
        setState(() {
          touchedIndex = -1;
        });
      },
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.orange.shade100,
          borderRadius: BorderRadius.circular(47),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              currentTitle,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentValue,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 32),

            SizedBox(
              height: 145,
              child: BarChart(
                BarChartData(
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      if (weeklyData.length > 1)
                        HorizontalLine(
                          y: averageVal,
                          color: Colors.black,
                          strokeWidth: 2,
                          dashArray: [5, 5],
                          label: HorizontalLineLabel(
                            show: true,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(bottom: 5, left: 0),
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
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
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                weekDays[index],
                                style: TextStyle(
                                  color: index == touchedIndex
                                      ? Colors.black
                                      : Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12,
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
                          toY: weeklyData[index].toDouble(),
                          color: index == touchedIndex
                              ? Colors.black
                              : Colors.grey,
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

  double _calculateDoubleAverage() {
    if (weeklyData.isEmpty) return 0;
    final sum = weeklyData.reduce((a, b) => a + b);
    return sum / weeklyData.length;
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
}

String formatMinutes(int totalMinutes) {
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
