import 'package:flutter/material.dart';
import '../cards/workout_info_card.dart';
import '../utils/constants.dart';
import '../utils/strings.dart';

class FasterWorkoutSummary extends StatefulWidget {
  FasterWorkoutSummary({this.listAnswer});
  final List listAnswer;
  @override
  _FasterWorkoutSummaryState createState() => _FasterWorkoutSummaryState();
}

class _FasterWorkoutSummaryState extends State<FasterWorkoutSummary> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(20, 0, 20, 0);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q1,
          value: Constants.fastestWorkoutValues[0].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q2,
          value: Constants.fastestWorkoutValues[1].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q3,
          value: Constants.fastestWorkoutValues[2].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q4,
          value: Constants.fastestWorkoutValues[3].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q5,
          value: Constants.fastestWorkoutValues[4].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q6,
          value: Constants.fastestWorkoutValues[5].toString(),
        ),
      ],
    );
  }
}

class FastestWorkoutSummary extends StatefulWidget {
  @override
  _FastestWorkoutSummaryState createState() => _FastestWorkoutSummaryState();
}

class _FastestWorkoutSummaryState extends State<FastestWorkoutSummary> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(20, 0, 20, 0);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 25),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q1,
          value: Constants.fastestWorkoutValues[0].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q2,
          value: Constants.fastestWorkoutValues[1].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q3,
          value: Constants.fastestWorkoutValues[2].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q4,
          value: Constants.fastestWorkoutValues[3].toString(),
        ),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q5,
          value: Constants.fastestWorkoutValues[4].toString(),
        ),
        SizedBox(height: 10),
        ShowWorkoutInfoCard(
          title: FastestWorkoutQuestion.q6,
          value: Constants.fastestWorkoutValues[5].toString(),
        ),
      ],
    );
  }
}
