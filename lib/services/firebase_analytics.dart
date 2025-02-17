import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseAnalyticsService {
  static final FirebaseAnalytics _firebaseAnalytics = FirebaseAnalytics();

  static Future<void> logEvent(String eventName) async {
    String eventNameWithOS = Platform.isIOS ? "ios_" + eventName : "android_" + eventName;
    await _firebaseAnalytics.logEvent(name: eventNameWithOS);
  }
}
