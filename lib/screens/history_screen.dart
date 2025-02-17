import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faster_workouts/utils/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import '../controllers/exercise_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/style.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String fastestWorkout = 'Fastest Workout';
  String fasterWorkout = 'Faster Workout';
  bool isLoadingVertical = false;
  Future _loadMoreVertical() async {
    () async {
      Constants.historyLimit = Constants.historyLimit + 10;
      setState(() {
        isLoadingVertical = true;
      });
      await ExerciseDataController.getUserExerciseData(Constants.historyLimit);
      setState(() {
        isLoadingVertical = false;
      });
    }();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Constants.historyLimit = 10;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              const SizedBox(height: 15),
              AutoSizeText(
                'History',
                style: StyleRefer.kTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 15),
              LazyLoadScrollView(
                isLoading: isLoadingVertical,
                scrollOffset: 20,
                onEndOfPage: () => _loadMoreVertical(),
                child: SizedBox(
                  height: height / 1.35,
                  child: Constants.userExerciseData.length == null || Constants.userExerciseData.length == 0
                  ? Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 1.8,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.square_list,
                              color: theme.brightness == Brightness.light ? ColorRefer.kDarkGreyColor : ColorRefer.kGreyColor,
                              size: 50,
                            ),
                            SizedBox(height: 6),
                            AutoSizeText(
                              'Nothing to show',
                              style: TextStyle(
                                  color: theme.brightness == Brightness.light ? ColorRefer.kDarkGreyColor : ColorRefer.kGreyColor,
                                  fontFamily: FontRefer.OpenSans,
                                  fontSize: 20),
                            )
                          ],
                        ),
                  ) : ListView(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: Constants.historyLimit > Constants.userExerciseData.length
                            ? Constants.userExerciseData.length
                            : Constants.historyLimit,
                        itemBuilder: (context, position) {
                          Timestamp createdAt = Constants.userExerciseData[position].createdAt;
                          DateTime datetime = createdAt.toDate();
                          var formatter = new DateFormat('dd/MM/yyyy hh:mm a');
                          String date = formatter.format(datetime);
                          return Constants.userExerciseData[position].exerciseType == fastestWorkout
                              ? WorkoutHistoryTab(
                                  image: 'assets/images/fastest_workout.png',
                                  title: fastestWorkout,
                                  // title: 'Fastest Workout',
                                  size: 85,
                                  subTitle: date,
                                  onPressed: () {
                                    Constants.workoutType = Workouts.FastestWorkout;
                                    Constants.historyWorkoutValues = Constants.userExerciseData[position].data;
                                    Navigator.pushNamed(context, HistoryDetailScreen.historyDetailScreenID,
                                        arguments: [
                                          fastestWorkout,
                                          Constants.userExerciseData[position].data,
                                          datetime
                                        ]);
                                  },
                                )
                              : Constants.userExerciseData[position].exerciseType == fasterWorkout
                                  ? WorkoutHistoryTab(
                                      image: 'assets/images/faster_workout.png',
                                      title: fasterWorkout,
                                      subTitle: date,
                                      size: 60,
                                      onPressed: () {
                                        Constants.historyWorkoutValues =
                                            Constants.userExerciseData[position].data;
                                        Constants.workoutType = Workouts.FasterWorkout;
                                        Navigator.pushNamed(
                                            context, HistoryDetailScreen.historyDetailScreenID, arguments: [
                                          fasterWorkout,
                                          Constants.userExerciseData[position].data,
                                          datetime
                                        ]);
                                      },
                                    )
                                  : SizedBox();
                        },
                      ),
                      if (isLoadingVertical == true)
                        const Center(
                          child: CircularProgressIndicator(backgroundColor: ColorRefer.kOrangeColor),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutHistoryTab extends StatefulWidget {
  WorkoutHistoryTab({this.onPressed, this.title, this.image, this.subTitle, this.size});
  final String title;
  final String subTitle;
  final String image;
  final double size;
  final Function onPressed;
  @override
  _WorkoutHistoryTabState createState() => _WorkoutHistoryTabState();
}

class _WorkoutHistoryTabState extends State<WorkoutHistoryTab> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: widget.onPressed,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Container(
          width: width,
          height: width / 4,
          padding: EdgeInsets.only(left: 20),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.light ? ColorRefer.kLightColor : Colors.white10,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                widget.image,
                // 'assets/images/fastest_workout.png',
                width: widget.size,
                height: widget.size,
              ),
              Container(
                width: width / 1.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(
                        widget.title,
                        // 'Fastest Workout',
                        style: StyleRefer.kTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w900)),
                    SizedBox(height: 6),
                    Text(widget.subTitle,
                        softWrap: true,
                        style: StyleRefer.kTextStyle.copyWith(
                            fontSize: 11,
                            height: 1.5,
                            fontWeight: FontWeight.w700,
                            color: ColorRefer.kGreyColor)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
