import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String uid;
  String name;
  String email;
  int gender;
  String profileImageUrl;
  Timestamp dateOfBirth;
  double weight;
  Timestamp workoutDate;
  int workoutWeeks;
  Timestamp createdAt;

  UserModel({
    this.uid,
    this.name,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.weight,
    this.createdAt,
    this.profileImageUrl,
    this.workoutDate,
    this.workoutWeeks,
  });

  Map<String, dynamic> toMap() {
    return {
      UserModelFields.UID: this.uid,
      UserModelFields.NAME: this.name,
      UserModelFields.EMAIL: this.email,
      UserModelFields.DATE_OF_BIRTH: this.dateOfBirth,
      UserModelFields.GENDER: this.gender,
      UserModelFields.WEIGHT: this.weight,
      UserModelFields.PROFILE_IMAGE_URL: this.profileImageUrl,
      UserModelFields.WORKOUT_DATE: this.workoutDate,
      UserModelFields.CREATED_AT: this.createdAt,
      UserModelFields.WORKOUT_WEEKS: this.workoutWeeks,
    };
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    this.uid = map[UserModelFields.UID];
    this.name = map[UserModelFields.NAME];
    this.email = map[UserModelFields.EMAIL];
    this.gender = map[UserModelFields.GENDER];
    this.dateOfBirth = map[UserModelFields.DATE_OF_BIRTH];
    this.weight = map[UserModelFields.WEIGHT];
    this.createdAt = map[UserModelFields.CREATED_AT];
    this.profileImageUrl = map[UserModelFields.PROFILE_IMAGE_URL];
    this.workoutDate = map[UserModelFields.WORKOUT_DATE];
    this.workoutWeeks = map[UserModelFields.WORKOUT_WEEKS];
  }

  @override
  String toString() {
    return 'UserModel{uid: $uid, name: $name, email: $email, gender: $gender, profileImageUrl: $profileImageUrl, dateOfBirth: $dateOfBirth, weight: $weight, workout_weeks: $workoutWeeks, createdAt: $createdAt,} ';
  }
}

class UserModelFields {
  static const String UID = "uid";
  static const String NAME = "name";
  static const String EMAIL = "email";
  static const String GENDER = "gender";
  static const String DATE_OF_BIRTH = "date_of_birth";
  static const String WEIGHT = "weight";
  static const String CREATED_AT = "created_at";
  static const String PROFILE_IMAGE_URL = "profile_image_url";
  static const String WORKOUT_DATE = "workout_date";
  static const String WORKOUT_WEEKS = "workout_weeks";
}
