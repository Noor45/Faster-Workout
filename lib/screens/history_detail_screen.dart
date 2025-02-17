import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import '../cards/workout_history_card.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';
import '../utils/style.dart';

class HistoryDetailScreen extends StatefulWidget {
  static String historyDetailScreenID = "/history_detail_screen";
  @override
  _HistoryDetailScreenState createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(20, 0, 20, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List args = ModalRoute.of(context).settings.arguments;
    DateTime datetime = args[2];
    List list = args[1];
    print(list);
    var formatter_1 = new DateFormat('MMMM dd, yyyy');
    var formatter_2 = new DateFormat('hh:mm a');
    String date = formatter_1.format(datetime);
    String time = formatter_2.format(datetime);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          args[0],
          // 'Fastest Workout',
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
                  Padding(
                    padding: EdgeInsets.fromLTRB(45, 25, 45, 15),
                    child: Column(
                      children: [
                        AutoSizeText(date,
                            textAlign: TextAlign.center,
                            style: StyleRefer.kTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w800)),
                        SizedBox(height: 5),
                        AutoSizeText(time,
                            textAlign: TextAlign.center,
                            style: StyleRefer.kTextStyle.copyWith(
                                fontSize: 17, fontWeight: FontWeight.w700, color: ColorRefer.kGreyColor)),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: paddingValues,
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText(
                        Constants.workoutType == Workouts.FastestWorkout
                            ? 'Your Fastest Workout Progress'
                            : 'Your Fastest Workout Progress',
                        textAlign: TextAlign.center,
                        style: StyleRefer.kTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w900)),
                  ),
                  SizedBox(height: 20),
                  WorkoutMessageCard(
                    workoutType:  Constants.workoutType,
                    pointOne: Constants.historyWorkoutValues[0],
                    pointTwo: Constants.historyWorkoutValues[3],
                    pointThree: Constants.historyWorkoutValues[5],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: paddingValues,
                    alignment: Alignment.centerLeft,
                    child: AutoSizeText('Workout Summary',
                        textAlign: TextAlign.center,
                        style: StyleRefer.kTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w900)),
                  ),
                  Container(
                    child: FasterWorkoutHistory(listAnswer: Constants.historyWorkoutValues),
                  ),
                ],
              ),
            ),
      )),
    );
  }
}

class WorkoutMessageCard extends StatefulWidget {
  WorkoutMessageCard({this.workoutType, this.pointOne, this.pointTwo, this.pointThree});
  final Workouts workoutType;
  final int pointOne;
  final int pointTwo;
  final int pointThree;
  @override
  _WorkoutMessageCardState createState() => _WorkoutMessageCardState();
}

class _WorkoutMessageCardState extends State<WorkoutMessageCard> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(15, 15, 15, 15);
  String message1 = '';
  String message2 = '';
  String message3 = '';

  calculateResult() {
    setState(() {
      if (Constants.workoutType == Workouts.FastestWorkout) {
        message1 = FastestWorkoutMessageShow.messageOne(bicepReps: widget.pointOne);
        message2 = FastestWorkoutMessageShow.messageTwo(pushUpReps: widget.pointTwo);
        message3 = FastestWorkoutMessageShow.messageThree(kettleReps: widget.pointThree);
      } else if (Constants.workoutType == Workouts.FasterWorkout) {
        message1 = FastestWorkoutMessageShow.messageOne(bicepReps: widget.pointOne);
        message2 = FastestWorkoutMessageShow.messageTwo(pushUpReps: widget.pointTwo);
      }
    });
  }

  @override
  void initState() {
    calculateResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: [
          Visibility(
            visible: message1 == '' ? false : true,
            child: Container(
              width: width,
              padding: paddingValues,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: AutoSizeText(message1,
                  textAlign: TextAlign.center,
                  style: StyleRefer.kTextStyle
                      .copyWith(fontSize: 14, color: theme.brightness == Brightness.light ? Colors.black54 : Colors.white, letterSpacing: 0.5)),
            ),
          ),
          SizedBox(height: 20),
          Visibility(
            visible: message2 == '' ? false : true,
            child: Container(
              width: width,
              padding: paddingValues,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: AutoSizeText(message2,
                  textAlign: TextAlign.center,
                  style: StyleRefer.kTextStyle
                      .copyWith(fontSize: 14, color: theme.brightness == Brightness.light ? Colors.black54 : Colors.white, letterSpacing: 0.5)),
            ),
          ),
          SizedBox(height: 20),
          Visibility(
            visible: message3 == '' ? false : true,
            child: Container(
              width: width,
              padding: paddingValues,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: AutoSizeText(message3,
                  textAlign: TextAlign.center,
                  style: StyleRefer.kTextStyle
                      .copyWith(fontSize: 14, color: theme.brightness == Brightness.light ? Colors.black54 : Colors.white, letterSpacing: 0.5)),
            ),
          ),
        ],
      ),
    );
  }
}

// class FastestWorkoutMessageShow {
//   static String messageOne({int rowsReps}) {
//     print(rowsReps);
//     String message1;
//     if (rowsReps < 6)
//       message1 = FastestWorkoutMessage.rows_reps_message1;
//     else if (rowsReps > 5 && rowsReps < 10)
//       message1 = FastestWorkoutMessage.rows_reps_message2;
//     else if (rowsReps > 9) message1 = FastestWorkoutMessage.rows_reps_message3;
//     print(message1);
//     return message1;
//   }
//
//   static String messageTwo({int pushUpReps}) {
//     String message2;
//     if (pushUpReps < 6)
//       message2 = FastestWorkoutMessage.pushup_reps_message1;
//     else if (pushUpReps > 5 && pushUpReps < 10)
//       message2 = FastestWorkoutMessage.pushup_reps_message2;
//     else if (pushUpReps > 9) message2 = FastestWorkoutMessage.pushup_reps_message3;
//     return message2;
//   }
// }

class FastestWorkoutMessageShow {
  static String messageOne({int bicepReps}) {
    String message1;
    if (bicepReps < 6)
      message1 = FastestWorkoutMessage.bicep_reps_message1;
    else if (bicepReps > 5 && bicepReps < 10)
      message1 = FastestWorkoutMessage.bicep_reps_message2;
    else if (bicepReps > 9) message1 = FastestWorkoutMessage.bicep_reps_message3;
    return message1;
  }

  static String messageTwo({int pushUpReps}) {
    String message2;
    if (pushUpReps < 6)
      message2 = FastestWorkoutMessage.pushup_reps_message1;
    else if (pushUpReps > 5 && pushUpReps < 10)
      message2 = FastestWorkoutMessage.pushup_reps_message2;
    else if (pushUpReps > 9) message2 = FastestWorkoutMessage.pushup_reps_message3;
    return message2;
  }
  static String messageThree({int kettleReps}) {
    String message3;
    if (kettleReps < 13)
      message3 = FastestWorkoutMessage.kettle_reps_message1;
    else if (kettleReps > 12 && kettleReps < 20)
      message3 = FastestWorkoutMessage.kettle_reps_message2;
    else if (kettleReps > 19) message3 = FastestWorkoutMessage.kettle_reps_message3;
    return message3;
  }
}
