import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../cards/workout_summary_card.dart';
import '../controllers/exercise_controller.dart';
import '../functions/global_functions.dart';
import '../utils/constants.dart';
import '../widgets/round_button.dart';
import '../utils/colors.dart';
import '../utils/style.dart';
import 'workout_message_screen.dart';

class WorkoutSummaryScreen extends StatefulWidget {
  static String workoutSummaryScreenID = "/workout_summary_screen";
  @override
  _WorkoutSummaryScreenState createState() => _WorkoutSummaryScreenState();
}

class _WorkoutSummaryScreenState extends State<WorkoutSummaryScreen> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(20, 0, 20, 0);
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List arg = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Confirm Workout Data',
          style: StyleRefer.kTextStyle.copyWith(fontSize: 16),
        ),
      ),
      body: SafeArea(
          child: ModalProgressHUD(
            inAsyncCall: _isLoading,
            progressIndicator: CircularProgressIndicator(
              backgroundColor: ColorRefer.kOrangeColor,
            ),
            child: Container(
              width: width,
              height: height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 25),
                    Container(
                      padding: paddingValues,
                      child: AutoSizeText('if this is not right, press the back arrow',
                          textAlign: TextAlign.center,
                          style: StyleRefer.kTextStyle
                              .copyWith(fontSize: 16, fontWeight: FontWeight.w900, color: ColorRefer.kGreyColor)),
                    ),
                    SizedBox(height: 25),
                    Column(
                      children: Constants.workoutType == Workouts.FastestWorkout
                          ? [FastestWorkoutSummary()]
                          : Constants.workoutType == Workouts.FasterWorkout
                              ? [FasterWorkoutSummary()]
                              : [Container()],
                    ),
                    SizedBox(height: 15),
                    Container(
                      padding: paddingValues,
                      child: RoundedButton(
                          title: 'Save Workout Data',
                          buttonRadius: 8,
                          colour: ColorRefer.kOrangeColor,
                          height: 40,
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await ExerciseDataController.saveUserExerciseData(arg[0], arg[1]);
                            await updateWorkoutStreak();
                            setState(() {
                              _isLoading = false;
                            });
                            Navigator.pushReplacementNamed(context, WorkoutMessageScreen.workoutMessageScreenID);
                          }),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      )),
    );
  }
}
