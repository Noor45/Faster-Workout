import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/constants.dart';

class WeeklyGraph extends StatefulWidget {
  WeeklyGraph({this.exerciseType});
  final String exerciseType;
  @override
  _WeeklyGraphState createState() => _WeeklyGraphState();
}

class _WeeklyGraphState extends State<WeeklyGraph> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      height: width / 1.2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            horizontalInterval: 20,
          ),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTextStyles: (value) => const TextStyle(
                color: Color(0xff97a6ba),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              margin: 2,
              getTitles: (value) {
                switch (value.toInt()) {
                  case 100:
                    return '100';
                  case 80:
                    return '80';
                  case 60:
                    return '60';
                  case 40:
                    return '40';
                  case 20:
                    return '20';
                }
                return '';
              },
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTextStyles: (value) => const TextStyle(
                color: Color(0xff97a6ba),
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
              getTitles: (value) {
                switch (value.toInt()) {
                  case 7:
                    return 'Sun';
                  case 6:
                    return 'Sat';
                  case 5:
                    return 'Fri';
                  case 4:
                    return 'Thu';
                  case 3:
                    return 'Wed';
                  case 2:
                    return 'Tues';
                  case 1:
                    return 'Mon';
                }
                return '';
              },
              margin: 20,
              reservedSize: 30,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(
                color: Color(0xff4e4965),
                width: 1,
              ),
              left: BorderSide(
                color: Colors.transparent,
              ),
              right: BorderSide(
                color: Colors.transparent,
              ),
            ),
          ),
          minX: 0,
          maxX: 8,
          minY: 0,
          maxY: 120,
          lineBarsData: Constants.selectedGraphExercise == 'Fastest Workout'
              ? linesBarData1(
                  bag: WeeklyData.fastestWorkoutBagRecord, bagPack: WeeklyData.fastestWorkoutBagPackRecord)
              : linesBarData1(
                  bag: WeeklyData.fasterWorkoutBagRecord, bagPack: WeeklyData.fasterWorkoutBagPackRecord),
        ),
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  List<LineChartBarData> linesBarData1({List bag, List bagPack}) {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(0.0, 0),
        FlSpot(1.0, bag[0]),
        FlSpot(2.0, bag[1]),
        FlSpot(3.0, bag[2]),
        FlSpot(4.0, bag[3]),
        FlSpot(5.0, bag[4]),
        FlSpot(6.0, bag[5]),
        FlSpot(7.0, bag[6]),
      ],
      isCurved: true,
      colors: [
        Color(0xff563cde),
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData lineChartBarData2 = LineChartBarData(
      spots: [
        FlSpot(0.0, 0),
        FlSpot(1.0, bagPack[0]),
        FlSpot(2.0, bagPack[1]),
        FlSpot(3.0, bagPack[2]),
        FlSpot(4.0, bagPack[3]),
        FlSpot(5.0, bagPack[4]),
        FlSpot(6.0, bagPack[5]),
        FlSpot(7.0, bagPack[6]),
      ],
      isCurved: true,
      colors: [
        Color(0xffffa800),
      ],
      barWidth: 2,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return [lineChartBarData1, lineChartBarData2];
  }
}
