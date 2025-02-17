import 'package:flutter/material.dart';
import '../cards/workout_info_card.dart';
import '../utils/strings.dart';

class FasterWorkoutHistory extends StatefulWidget {
  FasterWorkoutHistory({this.listAnswer});
  final List listAnswer;
  @override
  _FasterWorkoutHistoryState createState() => _FasterWorkoutHistoryState();
}

class _FasterWorkoutHistoryState extends State<FasterWorkoutHistory> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(20, 0, 20, 0);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q1,
          value: widget.listAnswer[0].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q2,
          value: widget.listAnswer[1].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q3,
          value: widget.listAnswer[2].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q4,
          value: widget.listAnswer[3].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q5,
          value: widget.listAnswer[4].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q6,
          value: widget.listAnswer[5].toString(),
        ),
      ],
    );
  }
}

class FastestWorkoutHistory extends StatefulWidget {
  FastestWorkoutHistory({this.listAnswer});
  final List listAnswer;
  @override
  _FastestWorkoutHistoryState createState() => _FastestWorkoutHistoryState();
}

class _FastestWorkoutHistoryState extends State<FastestWorkoutHistory> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(20, 0, 20, 0);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q1,
          value: widget.listAnswer[0].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q2,
          value: widget.listAnswer[1].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q3,
          value: widget.listAnswer[2].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q4,
          value: widget.listAnswer[3].toString(),
        ),
      ],
    );
  }
}
