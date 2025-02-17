import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../cards/video_screen_card.dart';
import '../controllers/video_controller.dart';
import '../utils/strings.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/round_button.dart';
import '../utils/style.dart';

class LearnMoreScreen extends StatefulWidget {
  static String learnMoreScreenID = "/learn_more_screen";

  @override
  _LearnMoreScreenState createState() => _LearnMoreScreenState();
}

class _LearnMoreScreenState extends State<LearnMoreScreen> {
  @override
  void initState() {
    super.initState();
    () async {
      await VideoDataController.getMainVideos();
    }();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    String videoId = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded)),
        title: Text(
          'Learn Faster Workouts',
          style: TextStyle(fontFamily: FontRefer.OpenSans),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: PlayerCard(
                  videoID: videoId,
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText('Faster Workouts',
                            style: StyleRefer.kTextStyle.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w900, color: ColorRefer.kOrangeColor)),
                        SizedBox(height: 5),
                        AutoSizeText(StringRefer.kMainVideoScreenString,
                            textAlign: TextAlign.justify,
                            style: StyleRefer.kTextStyle.copyWith(
                                fontSize: 10, fontWeight: FontWeight.w700, color: ColorRefer.kGreyColor)),
                        SizedBox(height: 10),
                        RoundedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          title: 'Done',
                          buttonRadius: 8,
                          height: 50,
                          colour: ColorRefer.kOrangeColor,
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
