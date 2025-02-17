import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';
import '../cards/last_three_month_graph_card.dart';
import '../cards/monthly_graph_card.dart';
import '../cards/weekly_graph_card.dart';
import '../functions/analytic_functions.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../utils/strings.dart';
import '../utils/style.dart';

class ProgressGraphScreen extends StatefulWidget {
  static String progressGraphScreenID = "/progress_graph_screen";
  @override
  _ProgressGraphScreenState createState() => _ProgressGraphScreenState();
}

class _ProgressGraphScreenState extends State<ProgressGraphScreen> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(20, 0, 20, 0);
  int originalSize = 800;
  String link = Platform.isIOS
      ? 'https://apps.apple.com/us/app/faster-workouts/id1564741642'
      : 'https://play.google.com/store/apps/details?id=fasterworkouts.example.com';
  GlobalKey previewContainer = new GlobalKey();
  List<String> durationRange = ['Weekly', 'Monthly', 'Last 3 Months'];
  String selectedDuration;
  List<String> exerciseType = ['Fastest Workout'];
  String selectedExercise;
  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: 12.0,
      width: 12.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrentPage ? ColorRefer.kGraph2Color : ColorRefer.kGraph1Color,
      ),
    );
  }

  @override
  void initState() {
    selectedDuration = durationRange[0];
    List weeklyRecord = AnalyticsFunction.filterWeeklyData();
    AnalyticsFunction.filterMonthlyData();
    WeeklyData.fastestWorkoutBagRecord = weeklyRecord[0];
    WeeklyData.fastestWorkoutBagPackRecord = weeklyRecord[1];
    WeeklyData.fasterWorkoutBagRecord = weeklyRecord[2];
    WeeklyData.fasterWorkoutBagPackRecord = weeklyRecord[3];

    List monthlyRecord = AnalyticsFunction.filterMonthlyData();
    MonthlyData.fastestWorkoutBagRecord = monthlyRecord[0];
    MonthlyData.fastestWorkoutBagPackRecord = monthlyRecord[1];
    MonthlyData.fasterWorkoutBagRecord = monthlyRecord[2];
    MonthlyData.fasterWorkoutBagPackRecord = monthlyRecord[3];

    AnalyticsFunction.filterThreeMonthData();
    List threeMonthRecord = AnalyticsFunction.filterThreeMonthData();
    ThreeMonthsData.fastestWorkoutBagRecord = threeMonthRecord[0];
    ThreeMonthsData.fastestWorkoutBagPackRecord = threeMonthRecord[1];
    ThreeMonthsData.fasterWorkoutBagRecord = threeMonthRecord[2];
    ThreeMonthsData.fasterWorkoutBagPackRecord = threeMonthRecord[3];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Progress',
          style: StyleRefer.kTextStyle.copyWith(fontSize: 16),
        ),
        actions: [
          GestureDetector(
              onTap: () {
                ShareFilesAndScreenshotWidgets()
                    .takeScreenshot(previewContainer, originalSize)
                    .then((Image value) {
                  setState(() {});
                });
                ShareFilesAndScreenshotWidgets().shareScreenshot(
                    previewContainer, originalSize, "Workout Results", "Name.png", "image/png",
                    text: "Check out my progress in Faster Workouts! Download the app now:\n" + link);
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Icon(Icons.share, size: 20),
              )),
        ],
      ),
      body: SafeArea(
          child: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: RepaintBoundary(
            key: previewContainer,
            child: Container(
              color: theme.brightness == Brightness.light ? Colors.white : Colors.transparent,
              child: Column(
                children: [
                  SizedBox(height: 25),
                  Container(
                    padding: paddingValues,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText('My Progress',
                            textAlign: TextAlign.center,
                            style: StyleRefer.kTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w900)),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SelectRange(
                              value: selectedDuration,
                              selectionList: durationRange,
                              onChanged: (value) {
                                setState(() {
                                  selectedDuration = value;
                                });
                              },
                            ),
                            SelectRange(
                              value: Constants.selectedGraphExercise,
                              selectionList: exerciseType,
                              onChanged: (value) {
                                setState(() {
                                  Constants.selectedGraphExercise = value;
                                });
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                    child: AutoSizeText(StringRefer.kGraphString,
                        textAlign: TextAlign.start,
                        style: StyleRefer.kTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                  Container(
                    child: selectedDuration == 'Weekly'
                        ? WeeklyGraph()
                        : selectedDuration == 'Monthly'
                            ? MonthlyGraph()
                            : LastThreeMonthGraph(),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: paddingValues,
                    child: Row(
                      children: [
                        Row(
                          children: [
                            _buildPageIndicator(false),
                            SizedBox(width: 5),
                            AutoSizeText('Bag',
                                textAlign: TextAlign.center,
                                style: StyleRefer.kTextStyle
                                    .copyWith(fontSize: 12, fontWeight: FontWeight.w800)),
                          ],
                        ),
                        SizedBox(width: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPageIndicator(true),
                            SizedBox(width: 5),
                            AutoSizeText('Backpack',
                                textAlign: TextAlign.center,
                                style: StyleRefer.kTextStyle
                                    .copyWith(fontSize: 12, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  List<LineChartBarData> linesBarData1(List points) {
    final LineChartBarData lineChartBarData1 = LineChartBarData(
      spots: [
        FlSpot(0.0, 0),
        FlSpot(1.0, 1.0),
        FlSpot(2.0, 1.0),
        FlSpot(3.0, 2.0),
        FlSpot(4.0, 3.0),
        FlSpot(5.0, 1.0),
        FlSpot(6.0, 0.0),
        FlSpot(7.0, 1.0),
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
        FlSpot(1.0, 1.0),
        FlSpot(2.0, 1.0),
        FlSpot(3.0, 3.0),
        FlSpot(4.0, 0.0),
        FlSpot(5.0, 4.0),
        FlSpot(6.0, 1.0),
        FlSpot(7.0, 1.0),
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

class SelectRange extends StatefulWidget {
  SelectRange({this.label, this.selectionList, this.onChanged, this.value});
  final String label;
  final List<String> selectionList;
  final Function onChanged;
  final String value;
  @override
  _SelectRangeState createState() => _SelectRangeState();
}

class _SelectRangeState extends State<SelectRange> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      height: 40,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.light ? ColorRefer.kLightColor : Colors.white10,
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        value: widget.value,
        onChanged: widget.onChanged,
        icon: Icon(
          Icons.arrow_drop_down_sharp,
          color: ColorRefer.kOrangeColor,
        ),
        style: TextStyle(
            fontSize: 11,
            color: ColorRefer.kOrangeColor,
            fontWeight: FontWeight.w900,
            fontFamily: FontRefer.OpenSans),
        underline: Container(
          height: 0,
          color: theme.brightness == Brightness.light ? ColorRefer.kLightColor : Colors.white10,
        ),
        items: widget.selectionList.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
