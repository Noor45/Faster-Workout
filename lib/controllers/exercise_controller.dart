import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_exercise_data.dart';
import '../services/firebase_analytics.dart';
import '../utils/constants.dart';
import '../models/user_model.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class ExerciseDataController {
  static ExerciseModel data = ExerciseModel();
  static UserModel currentUser;

  //****************** Save Exercise Data ******************

  static Future<void> saveUserExerciseData(String type, List exerciseData) async {
    try {
      data.uid = _auth.currentUser.uid;
      data.exerciseType = type;
      data.createdAt = Timestamp.now();
      data.data = exerciseData;
      await _firestore.collection('user_exercise_data').add(data.toMap());
      await getUserExerciseData(Constants.historyLimit);
      await getUserExerciseGraphData();
      FirebaseAnalyticsService.logEvent("user_exercise_data_added");
      return;
    } on SocketException catch (error) {
      print("$error");
    } on FirebaseException catch (error) {
      print("$error");
    }
  }

  //****************** Get Exercise Data ******************

  static Future<void> getUserExerciseData(int limit) async {
    try {
      QuerySnapshot snapShot = await _firestore
          .collection('user_exercise_data')
          .where("uid", isEqualTo: _auth.currentUser.uid)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .get();
      Constants.userExerciseData = [];
      snapShot.docs.forEach((element) {
        print(element.data());
        ExerciseModel trackModelList = ExerciseModel.fromMap(element.data());
        Constants.userExerciseData.add(trackModelList);
        print(Constants.userExerciseData);
      });
      return;
    } on SocketException catch (error) {
      print("$error");
    } on FirebaseException catch (error) {
      print("$error");
    }
  }

  static Future<void> getUserExerciseGraphData() async {
    try {
      QuerySnapshot snapShot = await _firestore
          .collection('user_exercise_data')
          .where("uid", isEqualTo: _auth.currentUser.uid)
          .orderBy('created_at', descending: false)
          .get();
      Constants.userExerciseGraphData = [];
      snapShot.docs.forEach((element) {
        ExerciseModel trackModelList = ExerciseModel.fromMap(element.data());
        Constants.userExerciseGraphData.add(trackModelList);
      });
      return;
    } on SocketException catch (error) {
      print("$error");
    } on FirebaseException catch (error) {
      print("$error");
    }
  }

  static Future<void> getUser(int limit) async {
    try {
      QuerySnapshot snapShot = await _firestore.collection('users').limit(limit).get();
      Constants.userList = [];
      snapShot.docs.forEach((element) {
        UserModel trackModelList = UserModel.fromMap(element.data());
        Constants.userList.add(trackModelList);
      });
      return;
    } on SocketException catch (error) {
      print("$error");
    } on FirebaseException catch (error) {
      print("$error");
    }
  }
}
