import 'dart:io';
import 'package:faster_workouts/services/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/services.dart';
import '../utils/strings.dart';
import '../widgets/dialogs.dart';
import '../controllers/auth_controller.dart';
import '../shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static String splashScreenId = "/splash_screen";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _initApp() async {
    await LocalPreferences.initLocalPreferences();
    FirebaseAnalyticsService.logEvent("app_open");
    bool result = await DataConnectionChecker().hasConnection;
    if (result == true) {
      AuthController().checkUserExists(context);
      return;
    } else {
      AppDialog().showOSDialog(context, StringRefer.Error, StringRefer.kNoConnection, StringRefer.Ok, () {
        exit(0);
      });
      return;
    }
  }

  @override
  void initState() {
    _initApp();
    super.initState();
  }

  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width / 1.8,
              height: MediaQuery.of(context).size.width / 1.8,
            ),
          ],
        ),
      ),
    );
  }
}
