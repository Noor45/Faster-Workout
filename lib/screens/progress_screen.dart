import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../controllers/auth_controller.dart';
import '../utils/style.dart';
import 'progress_matrices.dart';

class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              AutoSizeText('Your Progress',
                  style: StyleRefer.kTextStyle.copyWith(fontSize: 28, fontWeight: FontWeight.w900)),
              SizedBox(height: 15),
              StreakWorkoutCard(
                color: Color(0xff9890e8),
                heading: 'Workout Streak',
                title: '28 days',
                subTile: 'View insights',
              ),
              SizedBox(height: 15),
              ProgressCard(
                color: Color(0xff9890e8),
                heading: 'Progress',
                detail: 'Press to see how much stronger you’re getting',
                onPressed: () {
                  Navigator.pushNamed(context, ProgressGraphScreen.progressGraphScreenID);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ProgressCard extends StatefulWidget {
  ProgressCard({this.heading, this.detail, this.color, this.onPressed});
  final String heading;
  final String detail;
  // final String title;
  // final String subTile;
  final Color color;
  final Function onPressed;
  @override
  _ProgressCardState createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        width: width,
        height: width / 3,
        padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            AutoSizeText(widget.heading,
                style: StyleRefer.kTextStyle.copyWith(
                    fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: Colors.white)),
            SizedBox(height: 6),
            Text(widget.detail,
                softWrap: true,
                style: StyleRefer.kTextStyle.copyWith(fontSize: 12, height: 1.5, color: Colors.white)),
            // SizedBox(height: 12),
            // AutoSizeText(widget.title,  style: StyleRefer.kTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white)),
            // SizedBox(height: 2),
            // Text(widget.subTile, softWrap: true, style: StyleRefer.kTextStyle.copyWith(fontSize: 11, height: 1.5, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class StreakWorkoutCard extends StatefulWidget {
  StreakWorkoutCard({this.title, this.heading, this.subTile, this.color, this.onPressed});
  final String heading;
  final String title;
  final String subTile;
  final Color color;
  final Function onPressed;
  @override
  _StreakWorkoutCardState createState() => _StreakWorkoutCardState();
}

class _StreakWorkoutCardState extends State<StreakWorkoutCard> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoSizeText(widget.heading,
                style: StyleRefer.kTextStyle.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                )),
            SizedBox(height: 10),
            Container(
              width: width,
              height: width / 3,
              padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
              decoration: BoxDecoration(
                color: Color(0xff4c5a81).withOpacity(0.8),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Weeks in a Row',
                      softWrap: true,
                      style: StyleRefer.kTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                          color: Colors.white)),
                  SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('No. of weeks in a row in which you',
                              softWrap: true,
                              style: StyleRefer.kTextStyle
                                  .copyWith(fontSize: 12, height: 1.5, color: Colors.white)),
                          Text(' have at least one workout day',
                              softWrap: true,
                              style: StyleRefer.kTextStyle
                                  .copyWith(fontSize: 12, height: 1.5, color: Colors.white)),
                        ],
                      ),
                      Text(AuthController.currentUser.workoutWeeks.toString(),
                          softWrap: true,
                          style: StyleRefer.kTextStyle.copyWith(
                              fontSize: 22, height: 1.5, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  SizedBox(height: 6),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
