import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:battery_info/battery_info_plugin.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  StatisticsState createState() => StatisticsState();
}

class StatisticsState extends State<Statistics> {
  final statisticsBox = Hive.box('statistics');
  // ignore: prefer_typing_uninitialized_variables
  String? batteryHealth;
  double? remainingLifeInHours;
  int? batteryTemperature;
  List<FlSpot> lineChartDataList = [];

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff01B399),
  ];

  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    fillLineChartDataList();
    getBatteryInfo();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 242, 242),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 242, 242, 242),
        elevation: 0,
        toolbarHeight: 100,
        title: Container(
            alignment: Alignment.centerLeft,
            width: 350,
            padding: const EdgeInsets.only(top: 15),
            child: const Text(
              'Статистики',
              style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 57, 57, 57)),
            )),
      ),
      body: Center(
          child: SizedBox(
        width: screenWidth * 0.93,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 5,
            ),
            AspectRatio(
              aspectRatio: 1.6,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: const Color.fromARGB(255, 229, 229, 229),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 16),
                            child: const Text(
                              'Използване на батерията',
                              style: TextStyle(
                                color: Color.fromARGB(255, 79, 79, 79),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: DecoratedBox(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                                color: Color.fromARGB(255, 229, 229, 229),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  right: 18,
                                  left: 12,
                                  top: 24,
                                  bottom: 12,
                                ),
                                child: LineChart(
                                  mainData(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            AspectRatio(
              aspectRatio: 1.4,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: const Color(0xff01B399),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            'Спестена енергия',
                            style: TextStyle(
                              color: Color(0xffe6fffb),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          const Text(
                            'Единиците са във ватове',
                            style: TextStyle(
                              color: Color(0xffb3fff4),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 28,
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: BarChart(
                                mainBarData(),
                                swapAnimationDuration: animDuration,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            AspectRatio(
              aspectRatio: 2.1,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                color: const Color.fromARGB(255, 229, 229, 229),
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            'Състояние на батерията',
                            style: TextStyle(
                              color: Color.fromARGB(255, 57, 57, 57),
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Живот на батерията: $batteryHealth",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 39, 55, 53),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Оставащи часове: ${remainingLifeInHours?.toInt()} часа",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 39, 55, 53),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "Тепмература на батерията: $batteryTemperature°",
                            style: const TextStyle(
                              color: Color.fromARGB(255, 39, 55, 53),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff68737d),
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 4:
        text = const Text('04:00', style: style);
        break;
      case 12:
        text = const Text('12:00', style: style);
        break;
      case 20:
        text = const Text('20:00', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff67727d),
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 20:
        text = '20%';
        break;
      case 50:
        text = '50%';
        break;
      case 80:
        text = '80%';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      backgroundColor: const Color.fromARGB(255, 229, 229, 229),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 20,
        verticalInterval: 2,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 154, 161, 166),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 154, 161, 166),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color.fromARGB(255, 76, 86, 94)),
      ),
      minX: 0,
      maxX: 24,
      minY: 0,
      maxY: 100,
      lineBarsData: [
        LineChartBarData(
          spots: lineChartDataList,
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color barColor = Colors.white,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? Colors.orangeAccent : barColor,
          width: width,
          borderSide: isTouched
              ? const BorderSide(color: Colors.orangeAccent)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(
                0,
                double.parse(statisticsBox
                    .get("Monday", defaultValue: 0)
                    .toStringAsFixed(1)),
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(
                1,
                double.parse(statisticsBox
                    .get("Tuesday", defaultValue: 0)
                    .toStringAsFixed(1)),
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(
                2,
                double.parse(statisticsBox
                    .get("Wednesday", defaultValue: 0)
                    .toStringAsFixed(1)),
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(
                3,
                double.parse(statisticsBox
                    .get("Thursday", defaultValue: 0)
                    .toStringAsFixed(1)),
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(
                4,
                double.parse(statisticsBox
                    .get("Friday", defaultValue: 0)
                    .toStringAsFixed(1)),
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(
                5,
                double.parse(statisticsBox
                    .get("Saturday", defaultValue: 0)
                    .toStringAsFixed(1)),
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(
                6,
                double.parse(statisticsBox
                    .get("Sunday", defaultValue: 0)
                    .toStringAsFixed(1)),
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Monday';
                break;
              case 1:
                weekDay = 'Tuesday';
                break;
              case 2:
                weekDay = 'Wednesday';
                break;
              case 3:
                weekDay = 'Thursday';
                break;
              case 4:
                weekDay = 'Friday';
                break;
              case 5:
                weekDay = 'Saturday';
                break;
              case 6:
                weekDay = 'Sunday';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.orangeAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('M', style: style);
        break;
      case 1:
        text = const Text('T', style: style);
        break;
      case 2:
        text = const Text('W', style: style);
        break;
      case 3:
        text = const Text('T', style: style);
        break;
      case 4:
        text = const Text('F', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('S', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: text,
    );
  }

  fillLineChartDataList() {
    setState(() {
      for (int i = 0; i <= 24; ++i) {
        if (statisticsBox.get(i, defaultValue: 0) != 0) {
          lineChartDataList.add(FlSpot(
              i.toDouble(), statisticsBox.get(i, defaultValue: 0).toDouble()));
        }
      }
    });
  }

  Future<void> getBatteryInfo() async {
    final battery = await BatteryInfoPlugin().androidBatteryInfo;
    batteryHealth = battery?.health ?? 'Unknown';
    setState(() {
      if (battery?.health == "health_good") {
        batteryHealth = "Отличен";
      } else {
        battery?.health ?? 'Unknown';
      }
      remainingLifeInHours = (battery!.batteryLevel! / 100) *
          battery.batteryCapacity!.toInt() /
          600;
      batteryTemperature = battery.temperature;
    });
  }
}
