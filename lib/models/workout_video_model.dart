import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutVideoModel {
  String videoId;
  String videoLink;
  String audioLink;
  String title;
  String exerciseType;
  Timestamp createdAt;

  WorkoutVideoModel({
    this.videoLink,
    this.audioLink,
    this.title,
    this.videoId,
    this.exerciseType,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      WorkoutVideoModelFields.VIDEO_ID: this.videoId,
      WorkoutVideoModelFields.VIDEO_LINK: this.videoLink,
      WorkoutVideoModelFields.TITLE: this.title,
      WorkoutVideoModelFields.AUDIO_LINK: this.audioLink,
      WorkoutVideoModelFields.EXERCISE_TYPE: this.exerciseType,
      WorkoutVideoModelFields.CREATED_AT: this.createdAt,
    };
  }

  WorkoutVideoModel.fromMap(Map<String, dynamic> map) {
    this.videoLink = map[WorkoutVideoModelFields.VIDEO_LINK];
    this.title = map[WorkoutVideoModelFields.TITLE];
    this.videoId = map[WorkoutVideoModelFields.VIDEO_ID];
    this.exerciseType = map[WorkoutVideoModelFields.EXERCISE_TYPE];
    this.audioLink = map[WorkoutVideoModelFields.AUDIO_LINK];
    this.createdAt = map[WorkoutVideoModelFields.CREATED_AT];
  }

  @override
  String toString() {
    return 'WorkoutVideoModel{video_link: $videoLink, audio_link: $audioLink, title: $title, id: $videoId, exercise_type: $exerciseType, created_at: $createdAt}';
  }
}

class WorkoutVideoModelFields {
  static const String VIDEO_ID = "id";
  static const String VIDEO_LINK = "video_link";
  static const String TITLE = "title";
  static const String EXERCISE_TYPE = "exercise_type";
  static const String CREATED_AT = "created_at";
  static const String AUDIO_LINK = "audio_link";

}
