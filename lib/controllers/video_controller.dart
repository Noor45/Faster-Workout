import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../functions/global_functions.dart';
import '../models/main_video_model.dart';
import '../models/video_model.dart';
import '../models/workout_video_model.dart';
import '../utils/constants.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

class VideoDataController {
  //****************** Get Exercise Videos ******************

  static Future<void> getVideos(int limit) async {
    try {
      QuerySnapshot snapShot = await _firestore.collection('videos').orderBy('created_at').limit(limit).get();
      Constants.videosList = [];
      await Future.wait(snapShot.docs.map((element) async {
        VideoModel videoModelList = VideoModel.fromMap(element.data());
        videoModelList.thumbnail = await getThumbnail(videoLink: videoModelList.videoLink);
        Constants.videosList.add(videoModelList);
      }));
      Constants.videosList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return;
    } on SocketException catch (error) {
      print("$error");
    } on FirebaseException catch (error) {
      print("$error");
    }
  }

  static Future<void> getMoreVideos(int limit) async {
    try {
      QuerySnapshot snapShot = await _firestore.collection('videos').orderBy('created_at').limit(limit).get();
      Constants.moreVideoList = [];
      await Future.wait(snapShot.docs.map((element) async {
        VideoModel videoModelList = VideoModel.fromMap(element.data());
        videoModelList.thumbnail = await getThumbnail(videoLink: videoModelList.videoLink);
        Constants.moreVideoList.add(videoModelList);
      }));
      Constants.moreVideoList.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return;
    } on SocketException catch (error) {
      print("$error");
    } on FirebaseException catch (error) {
      print("$error");
    }
  }

  //****************** Get Main Videos ******************

  static Future<void> getMainVideos() async {
    try {
      QuerySnapshot snapShot = await _firestore.collection('main_video').get();
      snapShot.docs.forEach((element) async {
        MainVideoModel videoModelList = MainVideoModel.fromMap(element.data());
        Constants.mainVideoLink = videoModelList.videoLink;
      });
      return;
    } on SocketException catch (error) {
      print("$error");
    } on FirebaseException catch (error) {
      print("$error");
    }
  }

  //****************** Get workout Videos ******************

  static Future<void> getWorkoutVideos() async {
    try {
      QuerySnapshot snapShot = await _firestore.collection('workouts').get();
      Constants.workoutVideos = [];
      snapShot.docs.forEach((element) async {
        WorkoutVideoModel workoutVideoList = WorkoutVideoModel.fromMap(element.data());
        Constants.workoutVideos.add(workoutVideoList);
      });
      print(Constants.workoutVideos);
      Constants.workoutVideos.forEach((element) {
        if (element.exerciseType == 'Fastest Workout') {
          FastestWorkout.title = element.title;
          FastestWorkout.audio = element.audioLink;
          String videoID = getData(element.videoLink);
          FastestWorkout.video = videoID;
        } else if (element.exerciseType == 'Faster Workout') {
          FasterWorkout.title = element.title;
          FasterWorkout.audio = element.audioLink;
          String videoID = getData(element.videoLink);
          FasterWorkout.video = videoID;
        }
      });
      return;
    } on SocketException catch (error) {
      print("$error");
    } on FirebaseException catch (error) {
      print("$error");
    }
  }
}
