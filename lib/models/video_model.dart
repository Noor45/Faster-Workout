import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String videoLink;
  String videoId;
  String title;
  String subtitle;
  int videoNo;
  String thumbnail;
  Timestamp createdAt;

  VideoModel({
    this.videoLink,
    this.title,
    this.subtitle,
    this.videoNo,
    this.thumbnail,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      VideoModelFields.VIDEO_LINK: this.videoLink,
      VideoModelFields.VIDEO_ID: this.videoId,
      VideoModelFields.TITLE: this.title,
      VideoModelFields.SUBTITLE: this.subtitle,
      VideoModelFields.VIDEO_NO: this.videoNo,
      VideoModelFields.CREATED_AT: this.createdAt,
    };
  }

  VideoModel.fromMap(Map<String, dynamic> map) {
    this.videoLink = map[VideoModelFields.VIDEO_LINK];
    this.videoId = map[VideoModelFields.VIDEO_ID];
    this.title = map[VideoModelFields.TITLE];
    this.subtitle = map[VideoModelFields.SUBTITLE];
    this.videoNo = map[VideoModelFields.VIDEO_NO];
    this.createdAt = map[VideoModelFields.CREATED_AT];
  }

  @override
  String toString() {
    return 'VideoModel{video_link: $videoLink, id: $videoId, title: $title, subtitle: $subtitle, video_no: $videoNo, created_at: $createdAt}';
  }
}

class VideoModelFields {
  static const String VIDEO_LINK = "video_link";
  static const String VIDEO_ID = "id";
  static const String TITLE = "title";
  static const String SUBTITLE = "subtitle";
  static const String VIDEO_NO = "video_no";
  static const String CREATED_AT = "created_at";

}
