import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import '../controllers/auth_controller.dart';
import '../controllers/exercise_controller.dart';
import '../controllers/video_controller.dart';
import '../utils/constants.dart';
import 'package:recursive_regex/recursive_regex.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<String> getThumbnail({String videoLink}) async {
  var jsonData = await thumbnail(videoLink);
  if(jsonData['thumbnail_url'] == null){
    String thumbnailUrl = 'assets/images/placeholder.jpg';
    return thumbnailUrl;
  }else{
    String thumbnailUrl = jsonData['thumbnail_url'] + '.png';
    return thumbnailUrl;
  }
}

thumbnail(String videoLink) async {
  try {
    String embedUrl = "https://noembed.com/embed?url=$videoLink&format=json";
    Uri myUri = Uri.parse(embedUrl);
    var res = await http.get(myUri);
    if (res.statusCode == 200)
      return json.decode(res.body);
    else
      return null;
  } on FormatException catch (e) {
    print('invalid JSON' + e.toString());
    return null;
  }
}

clearData() {
  Constants.email = '';
  Constants.userExerciseData = [];
  Constants.fastestWorkoutValues = List.filled(6, 0);
  // Constants.fasterWorkoutValues = List.filled(6, 0);
  Constants.videosList = [];
  Constants.selectedVideoID = '';
  Constants.selectedVideoTitle = '';
  Constants.selectedVideoSubtitle = '';
  Constants.selectedVideoLink = '';
  Constants.selectedGraphExercise = 'Fastest Workout';
  Constants.mainVideoLink = '';
  Constants.update = false;
  WeeklyData.sevenDaysRecord = [];
  Constants.userExerciseGraphData = [];
  Constants.moreVideoList = [];
  Constants.videoLimit = 10;
  Constants.moreVideoLimit = 10;
  Constants.historyLimit = 10;

  WeeklyData.fastestWorkoutBagRecord = List.filled(7, 0);
  WeeklyData.fastestWorkoutBagPackRecord = List.filled(7, 0);

  WeeklyData.fasterWorkoutBagRecord = List.filled(7, 0);
  WeeklyData.fasterWorkoutBagPackRecord = List.filled(7, 0);
}

String getData(String videoLink) {
  final input = videoLink + '.';
  String videoID = '';
  final regex = RecursiveRegex(
    startDelimiter: RegExp(r'https://vimeo.com/'),
    endDelimiter: RegExp(r'[.]'),
    captureGroupName: 'value',
    caseSensitive: true,
  );
  regex.getMatches(input).forEach((element) {
    String id = element.namedGroup('value');
    if (id.contains('/')) {
      List word = id.split('/');
      videoID = word[0];
    } else {
      videoID = id;
    }
  });
  return videoID;
}

checkWorkoutStreak() async {
  DateTime now = new DateTime.now();
  DateTime workoutDate = AuthController.currentUser.workoutDate.toDate();
  if (now.difference(workoutDate).inHours > 336) {
    AuthController.currentUser.workoutWeeks = 0;
    AuthController().updateUserFields();
    await AuthController.getUserInfo(AuthController.currentUser.uid);
  }
}

updateWorkoutStreak() async {
  DateTime now = new DateTime.now();
  DateTime workoutDate = AuthController.currentUser.workoutDate.toDate();
  if (now.difference(workoutDate).inHours > 168) {
    AuthController.currentUser.workoutDate = Timestamp.now();
    AuthController.currentUser.workoutWeeks = AuthController.currentUser.workoutWeeks + 1;
    AuthController().updateUserFields();
    await AuthController.getUserInfo(AuthController.currentUser.uid);
  } else if (now.difference(workoutDate).inHours < 168) {
    if (AuthController.currentUser.workoutWeeks == 0) {
      AuthController.currentUser.workoutDate = Timestamp.now();
      AuthController.currentUser.workoutWeeks = AuthController.currentUser.workoutWeeks + 1;
      AuthController().updateUserFields();
      await AuthController.getUserInfo(AuthController.currentUser.uid);
    }
  }
}

Future getUserData() async {
  await AuthController.getUserInfo(_auth.currentUser.uid);
  await ExerciseDataController.getUserExerciseData(Constants.historyLimit);
  await ExerciseDataController.getUser(Constants.moreVideoLimit);
  await ExerciseDataController.getUserExerciseGraphData();
  await checkWorkoutStreak();
}

Future getAppData() async {
  await VideoDataController.getMainVideos();
  await VideoDataController.getVideos(Constants.videoLimit);
  await VideoDataController.getMoreVideos(Constants.moreVideoLimit);
  await VideoDataController.getWorkoutVideos();
}
