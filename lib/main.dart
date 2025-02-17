import 'package:faster_workouts/screens/learn_more_screen.dart';
import 'package:faster_workouts/screens/profile_screen.dart';
import 'package:faster_workouts/screens/quick_video_screen.dart';
import 'package:faster_workouts/utils/fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'auth/chose_weight_screen.dart';
import 'auth/select_date_screen.dart';
import 'auth/select_gender.dart';
import 'auth/signin_screen.dart';
import 'auth/signup_screen.dart';
import 'auth/start_screen.dart';
import 'screens/fastest_workout_info_screen.dart';
import 'screens/faster_workout_info_screen.dart';
import 'auth/forget_password_screen.dart';
import 'screens/history_detail_screen.dart';
import 'screens/intro_screen.dart';
import 'screens/main_screen.dart';
import 'screens/progress_matrices.dart';
import 'screens/faster_workout_screen.dart';
import 'screens/video_screen.dart';
import 'screens/workout_message_screen.dart';
import 'screens/fastest_workout_screen.dart';
import 'screens/term_condition.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/workout_summery_screen.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        appBarTheme: AppBarTheme(
          color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
          titleTextStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
              fontFamily: FontRefer.OpenSans,
              fontSize: 18),
          iconTheme: IconThemeData(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.splashScreenId,
      routes: {
        SplashScreen.splashScreenId: (context) => SplashScreen(),
        IntroScreens.introScreenID: (context) => IntroScreens(),
        SignUpScreen.signUpScreenID: (context) => SignUpScreen(),
        SignInScreen.signInScreenID: (context) => SignInScreen(),
        StartScreen.startScreenID: (context) => StartScreen(),
        ForgetPasswordScreen.ID: (_) => ForgetPasswordScreen(),
        SelectGender.ID: (context) => SelectGender(),
        SelectDateOfBirth.ID: (context) => SelectDateOfBirth(),
        SelectWeightScreen.ID: (context) => SelectWeightScreen(),
        MainScreen.MainScreenId: (context) => MainScreen(),
        ProfileScreen.profileSCREEN: (context) => ProfileScreen(),
        FastestWorkoutScreen.ID: (context) => FastestWorkoutScreen(),
        FasterWorkoutScreen.ID: (context) => FasterWorkoutScreen(),
        FastestWorkoutInfoScreen.ID: (context) => FastestWorkoutInfoScreen(),
        FasterWorkoutInfoScreen.ID: (context) => FasterWorkoutInfoScreen(),
        WorkoutSummaryScreen.workoutSummaryScreenID: (context) => WorkoutSummaryScreen(),
        WorkoutMessageScreen.workoutMessageScreenID: (context) => WorkoutMessageScreen(),
        VideoScreen.videoScreenId: (context) => VideoScreen(),
        LearnMoreScreen.learnMoreScreenID: (context) => LearnMoreScreen(),
        QuickVideo.quickVideoScreenID: (context) => QuickVideo(),
        TermConditionScreen.termConditionID: (context) => TermConditionScreen(),
        PrivacyPolicyScreen.privacyPolicyID: (context) => PrivacyPolicyScreen(),
        ProgressGraphScreen.progressGraphScreenID: (context) => ProgressGraphScreen(),
        HistoryDetailScreen.historyDetailScreenID: (context) => HistoryDetailScreen(),
      },
    );
  }
}
