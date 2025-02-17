class MainVideoModel {
  String videoLink;
  String id;

  MainVideoModel({
    this.videoLink,
  });

  Map<String, dynamic> toMap() {
    return {
      MainVideoModelFields.VIDEO_LINK: this.videoLink,
      MainVideoModelFields.ID: this.id,

    };
  }

  MainVideoModel.fromMap(Map<String, dynamic> map) {
    this.videoLink = map[MainVideoModelFields.VIDEO_LINK];
    this.id = map[MainVideoModelFields.ID];

  }

  @override
  String toString() {
    return 'VideoModel{video_link: $videoLink, id: $id}';
  }
}

class MainVideoModelFields {
  static const String VIDEO_LINK = "video_link";
  static const String ID = "id";


}
