import 'package:faster_workouts/services/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../cards/workout_info_card.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../widgets/round_button.dart';
import '../utils/colors.dart';
import '../utils/style.dart';
import 'workout_summery_screen.dart';

class FasterWorkoutInfoScreen extends StatefulWidget {
  static const String ID = "/faster_workout_info_screen";
  @override
  _FasterWorkoutInfoScreenState createState() => _FasterWorkoutInfoScreenState();
}

class _FasterWorkoutInfoScreenState extends State<FasterWorkoutInfoScreen> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(20, 0, 20, 0);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Workout Summary',
          style: StyleRefer.kTextStyle.copyWith(fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 25),
                Container(
                  padding: paddingValues,
                  child: AutoSizeText('Way to go! How did you do?',
                      textAlign: TextAlign.center,
                      style: StyleRefer.kTextStyle
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w900, color: ColorRefer.kGreyColor)),
                ),
                SizedBox(height: 25),
                WorkoutInfoCard(
                  title: FastestWorkoutQuestion.q1,
                  slideValue: Constants.fastestWorkoutValues[0].toDouble(),
                  max: 25.0,
                  onChanged: (dynamic value) {
                    setState(() {
                      Constants.fastestWorkoutValues[0] = value.round();
                      FasterWorkout.bicepReps = Constants.fastestWorkoutValues[0].round();
                    });
                  },
                ),
                SizedBox(height: 8),
                WorkoutInfoCard(
                  title: FastestWorkoutQuestion.q2,
                  slideValue: Constants.fastestWorkoutValues[1].toDouble(),
                  max: 100.0,
                  onChanged: (dynamic value) {
                    setState(() {
                      Constants.fastestWorkoutValues[1] = value.round();
                      FasterWorkout.bicepWt = Constants.fastestWorkoutValues[1].round();
                    });
                  },
                ),
                SizedBox(height: 8),
                WorkoutInfoCard(
                  title: FastestWorkoutQuestion.q3,
                  slideValue: Constants.fastestWorkoutValues[2].toDouble(),
                  max: 50.0,
                  onChanged: (dynamic value) {
                    setState(() {
                      Constants.fastestWorkoutValues[2] = value.round();
                      FasterWorkout.pushUpReps = Constants.fastestWorkoutValues[2].round();
                    });
                  },
                ),
                SizedBox(height: 8),
                WorkoutInfoCard(
                  title: FastestWorkoutQuestion.q4,
                  slideValue: Constants.fastestWorkoutValues[3].toDouble(),
                  max: 100.0,
                  onChanged: (dynamic value) {
                    setState(() {
                      Constants.fastestWorkoutValues[3] = value.round();
                      FasterWorkout.pushUpWt = Constants.fastestWorkoutValues[3].round();
                    });
                  },
                ),
                SizedBox(height: 8),
                WorkoutInfoCard(
                  title: FastestWorkoutQuestion.q5,
                  slideValue: Constants.fastestWorkoutValues[4].toDouble(),
                  max: 25.0,
                  onChanged: (dynamic value) {
                    setState(() {
                      Constants.fastestWorkoutValues[4] = value.round();
                      FasterWorkout.kettleReps = Constants.fastestWorkoutValues[4].round();
                    });
                  },
                ),
                SizedBox(height: 8),
                WorkoutInfoCard(
                  title: FastestWorkoutQuestion.q6,
                  slideValue: Constants.fastestWorkoutValues[5].toDouble(),
                  max: 40.0,
                  onChanged: (dynamic value) {
                    setState(() {
                      Constants.fastestWorkoutValues[5] = value.round();
                      FasterWorkout.kettleLbs = Constants.fastestWorkoutValues[5].round();
                    });
                  },
                ),
                SizedBox(height: 8),
                Container(
                  padding: paddingValues,
                  child: RoundedButton(
                      title: 'Save Workout Data',
                      buttonRadius: 8,
                      colour: ColorRefer.kOrangeColor,
                      height: 40,
                      onPressed: () async {
                        FirebaseAnalyticsService.logEvent("5min_summary");
                        Navigator.pushNamed(context, WorkoutSummaryScreen.workoutSummaryScreenID,
                            arguments: ['Faster Workout', Constants.fastestWorkoutValues]);
                      }),
                ),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
