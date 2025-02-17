import 'package:faster_workouts/services/firebase_analytics.dart';
import 'package:faster_workouts/utils/colors.dart';
import 'package:flutter/material.dart';
import '../controllers/video_controller.dart';
import '../utils/constants.dart';
import '../widgets/workout_player.dart';
import '../utils/style.dart';
import 'faster_workout_info_screen.dart';

class FasterWorkoutScreen extends StatefulWidget {
  static const String ID = 'Faster_workout_screen';
  @override
  _FasterWorkoutScreenState createState() => _FasterWorkoutScreenState();
}

class _FasterWorkoutScreenState extends State<FasterWorkoutScreen> {
  @override
  void initState() {
    () async {
      await VideoDataController.getWorkoutVideos();
    }();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Faster Workout',
          style: StyleRefer.kTextStyle.copyWith(fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: WorkoutsVideoPlayer(
            title: FasterWorkout.title,
            videoID: FasterWorkout.video,
            audioUrl: FasterWorkout.audio,
            timerRange: 90,
            onDone: () {
              FirebaseAnalyticsService.logEvent("5min_workout_start");
              Navigator.pushReplacementNamed(
                context,
                FasterWorkoutInfoScreen.ID,
              );
            },
          ),
        ),
      ),
    );
  }



  // void startTimer() {
  //   setState(() {
  //     Future.delayed(Duration(seconds: 1), () {
  //       if (mounted) {
  //         setState(() {
  //           secs--;
  //           if (secs < 00) {
  //             secs = 00;
  //             // mins++;
  //           }
  //         });
  //         startTimer();
  //       }
  //     });
  //   });
  // }
  //
  // stopTimer() {
  //   Future.delayed(Duration(seconds: 1), () {
  //     if (mounted) {
  //       setState(() {
  //         secs = 0;
  //         // mins = 0;
  //       });
  //     }
  //   });
  // }
}
