import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  static SharedPreferences preferences;
  static const String OnBoardingScreensVisited = "on_boarding_visited";
  static const String LOGGED_IN = "loggedIn";

  static Future<void> initLocalPreferences() async {
    preferences = await SharedPreferences.getInstance();
  }
}
