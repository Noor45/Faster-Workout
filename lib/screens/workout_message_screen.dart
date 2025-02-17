import 'package:faster_workouts/services/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import '../cards/workout_message_card.dart';
import '../functions/workout_message_functions.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/style.dart';
import '../widgets/round_button.dart';

class WorkoutMessageScreen extends StatefulWidget {
  static String workoutMessageScreenID = "/workout_message_screen";
  @override
  _WorkoutMessageScreenState createState() => _WorkoutMessageScreenState();
}

class _WorkoutMessageScreenState extends State<WorkoutMessageScreen> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(20, 0, 20, 0);

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value:
          SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        body: Container(
          width: width,
          height: height,
          padding: paddingValues,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage('assets/images/woman.png'),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AutoSizeText('You’re making progress! ',
                  textAlign: TextAlign.center,
                  style: StyleRefer.kTextStyle.copyWith(
                      fontSize: 19, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
              SizedBox(height: 20),
              Column(
                children: Constants.workoutType == Workouts.FastestWorkout
                    ? [FastestWorkoutMessageCard()]
                    : Constants.workoutType == Workouts.FasterWorkout
                        ? [FasterWorkoutMessageCard()]
                        : [Container()],
              ),
              SizedBox(height: 20),
              RoundedButton(
                  title: 'Finished – go to Home Screen',
                  buttonRadius: 8,
                  colour: ColorRefer.kOrangeColor,
                  height: 40,
                  onPressed: () {
                    String eventName = Constants.workoutType == Workouts.FasterWorkout
                        ? '5min_workout_end'
                        : '3min_workout_end';
                    FirebaseAnalyticsService.logEvent(eventName);
                    Message.clear();
                    Navigator.pop(context);
                    Navigator.pop(context);
                    // Navigator.pushNamed(context, MainScreen.MainScreenId);
                  }),
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
