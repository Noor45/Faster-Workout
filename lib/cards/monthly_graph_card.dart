import 'package:faster_workouts/utils/constants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MonthlyGraph extends StatefulWidget {
  @override
  _MonthlyGraphState createState() => _MonthlyGraphState();
}

class _MonthlyGraphState extends State<MonthlyGraph> {
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
                  case 6:
                    return '';
                  case 5:
                    return 'W5';
                  case 4:
                    return 'W4';
                  case 3:
                    return 'W3';
                  case 2:
                    return 'W2';
                  case 1:
                    return 'W1';
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
          maxX: 6,
          minY: 0,
          maxY: 120,
          lineBarsData: Constants.selectedGraphExercise == 'Fastest Workout'
              ? linesBarData1(
                  bag: MonthlyData.fastestWorkoutBagRecord, bagPack: MonthlyData.fastestWorkoutBagPackRecord)
              : linesBarData1(
                  bag: MonthlyData.fasterWorkoutBagRecord, bagPack: MonthlyData.fasterWorkoutBagPackRecord),
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
