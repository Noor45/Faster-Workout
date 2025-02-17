import '../utils//strings.dart';

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = [];
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc(StringRefer.kIntroSubtitle);
  sliderModel.setTitle(StringRefer.kIntroTitle1);
  sliderModel.setImageAssetPath(StringRefer.artwork1);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc(StringRefer.kIntroSubtitle2);
  sliderModel.setTitle(StringRefer.kIntroTitle2);
  sliderModel.setImageAssetPath(StringRefer.artwork2);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc(StringRefer.kIntroSubtitle3);
  sliderModel.setTitle(StringRefer.kIntroTitle3);
  sliderModel.setImageAssetPath(StringRefer.artwork3);
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
