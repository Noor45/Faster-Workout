// import 'package:faster_workouts/services/firebase_analytics.dart';
// import 'package:flutter/material.dart';
// import '../controllers/video_controller.dart';
// import '../screens/fastest_workout_info_screen.dart';
// import '../utils/constants.dart';
// import '../widgets/workout_player.dart';
// import '../utils/style.dart';
//
// class FastestWorkoutScreen extends StatefulWidget {
//   static const String ID = 'fastest_workout_screen';
//   @override
//   _FastestWorkoutScreenState createState() => _FastestWorkoutScreenState();
// }
//
// class _FastestWorkoutScreenState extends State<FastestWorkoutScreen> {
//   @override
//   void initState() {
//     super.initState();
//     () async {
//       await VideoDataController.getWorkoutVideos();
//     }();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text(
//           'Fastest Workout',
//           style: StyleRefer.kTextStyle.copyWith(fontSize: 16),
//         ),
//       ),
//       body: SafeArea(
//           child: Container(
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               WorkoutsVideoPlayer(
//                 title: FastestWorkout.title,
//                 videoID: FastestWorkout.video,
//                 timerRange: 3,
//                 onDone: () {
//                   FirebaseAnalyticsService.logEvent("3min_workout_start");
//                   Navigator.pushReplacementNamed(
//                     context,
//                     FastestWorkoutInfoScreen.ID,
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       )),
//     );
//   }
// }


import 'package:faster_workouts/screens/fastest_workout_info_screen.dart';
import 'package:faster_workouts/services/firebase_analytics.dart';
import 'package:faster_workouts/utils/colors.dart';
import 'package:flutter/material.dart';
import '../controllers/video_controller.dart';
import '../utils/constants.dart';
import '../widgets/workout_player.dart';
import '../utils/style.dart';
import 'faster_workout_info_screen.dart';

class FastestWorkoutScreen extends StatefulWidget {
  static const String ID = 'fastest_workout_screen';
  @override
  _FastestWorkoutScreenState createState() => _FastestWorkoutScreenState();
}

class _FastestWorkoutScreenState extends State<FastestWorkoutScreen> {
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
          'Fastest Workout',
          style: StyleRefer.kTextStyle.copyWith(fontSize: 16),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: WorkoutsVideoPlayer(
            title: FastestWorkout.title,
            videoID: FastestWorkout.video,
            audioUrl: FastestWorkout.audio,
            timerRange: 90,
            onDone: () {
              FirebaseAnalyticsService.logEvent("5min_workout_start");
              Navigator.pushReplacementNamed(
                context,
                FastestWorkoutInfoScreen.ID,
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

