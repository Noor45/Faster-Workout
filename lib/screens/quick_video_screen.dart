import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:faster_workouts/utils/strings.dart';
import 'package:faster_workouts/utils/style.dart';
import 'package:flutter/material.dart';
import '../cards/video_screen_card.dart';
import '../utils/constants.dart';

class QuickVideo extends StatefulWidget {
  static String quickVideoScreenID = "/quick_screen";
  @override
  _QuickVideoState createState() => _QuickVideoState();
}

class _QuickVideoState extends State<QuickVideo> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title: Text(
          'Quick Start Video',
          style: StyleRefer.kTextStyle.copyWith(fontSize: 16),
        ),
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded)),
      ),
      body: SafeArea(
          child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.only(top: width / 6),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: AutoSizeText(StringRefer.kQuickVideoString,
                      textAlign: TextAlign.center, style: StyleRefer.kTextStyle.copyWith(fontSize: 13)),
                ),
                SizedBox(height: 30),
                PlayerCard(
                  videoID: Constants.selectedVideoID,
                ),
              ],
        ),
      )),
    );
  }
}
