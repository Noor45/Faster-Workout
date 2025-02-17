import 'package:cloud_firestore/cloud_firestore.dart';

class ExerciseModel {
  String uid;
  String exerciseType;
  List data;
  Timestamp createdAt;

  ExerciseModel({
    this.uid,
    this.exerciseType,
    this.data,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
    ExerciseModelFields.UID: this.uid,
    ExerciseModelFields.EXERCISE_TYPE: this.exerciseType,
    ExerciseModelFields.DATA: this.data,
    ExerciseModelFields.CREATED_AT: this.createdAt,
    };
  }

  ExerciseModel.fromMap(Map<String, dynamic> map) {
    this.uid = map[ExerciseModelFields.UID];
    this.exerciseType = map[ExerciseModelFields.EXERCISE_TYPE];
    this.data = map[ExerciseModelFields.DATA];
    this.createdAt = map[ExerciseModelFields.CREATED_AT];
  }

  @override
  String toString() {
    return 'ExerciseModel{uid: $uid, exercise_type: $exerciseType, data: $data, created_at: $createdAt}';
  }
}

class ExerciseModelFields {
  static const String UID = "uid";
  static const String EXERCISE_TYPE = "exercise_type";
  static const String DATA = "data";
  static const String CREATED_AT = "created_at";

}
