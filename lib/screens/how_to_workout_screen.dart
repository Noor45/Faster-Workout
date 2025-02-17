import 'package:faster_workouts/services/firebase_analytics.dart';
import 'package:faster_workouts/utils/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import '../cards/video_list_card.dart';
import '../controllers/video_controller.dart';
import '../functions/global_functions.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/style.dart';
import 'video_screen.dart';

final FirebaseFirestore fireStore = FirebaseFirestore.instance;

class HowToWorkOutScreen extends StatefulWidget {
  @override
  _HowToWorkOutScreenState createState() => _HowToWorkOutScreenState();
}

class _HowToWorkOutScreenState extends State<HowToWorkOutScreen> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(15, 15, 5, 0);
  bool isLoadingVertical = false;
  Future _loadMoreVertical() async {
    () async {
      Constants.videoLimit = Constants.videoLimit + 10;
      setState(() {
        isLoadingVertical = true;
      });
      await VideoDataController.getVideos(Constants.videoLimit);
      setState(() {
        isLoadingVertical = false;
      });
    }();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Constants.videoLimit = 10;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          padding: paddingValues,
          child: ListView(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            children: [
              SizedBox(height: 15),
              AutoSizeText('Learn more about Faster Workouts and how to do them',
                  style: StyleRefer.kTextStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w900)),
              SizedBox(height: 15),
              LazyLoadScrollView(
                isLoading: isLoadingVertical,
                scrollOffset: 20,
                onEndOfPage: () => _loadMoreVertical(),
                child: SizedBox(
                  height: height / 1.35,
                  child: Constants.videosList.length == null || Constants.videosList.length == 0
                      ? Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height / 1.8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                CupertinoIcons.square_list,
                                color: theme.brightness == Brightness.light ? ColorRefer.kDarkGreyColor : ColorRefer.kGreyColor,
                                size: 50,
                              ),
                              SizedBox(height: 6),
                              AutoSizeText(
                                'Nothing to show',
                                style: TextStyle(
                                    color: theme.brightness == Brightness.light ? ColorRefer.kDarkGreyColor : ColorRefer.kGreyColor,
                                    fontFamily: FontRefer.OpenSans,
                                    fontSize: 20),
                              )
                            ],
                          ),
                  ) : ListView(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: Constants.videoLimit > Constants.videosList.length
                            ? Constants.videosList.length
                            : Constants.videoLimit,
                        itemBuilder: (context, position) {
                          return Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: VideoTab(
                              title: Constants.videosList[position].title,
                              subtitle: Constants.videosList[position].subtitle,
                              videoLink: Constants.videosList[position].videoLink,
                              thumbnail: Constants.videosList[position].thumbnail == null
                                  ? ''
                                  : Constants.videosList[position].thumbnail,
                              onPressed: () {
                                FirebaseAnalyticsService.logEvent("open_video");
                                Constants.moreVideoLimit = 10;
                                String videoID = getData(Constants.videosList[position].videoLink);
                                setState(() {
                                  Constants.selectedVideoID = videoID;
                                  Constants.selectedVideoTitle = Constants.videosList[position].title;
                                  Constants.selectedVideoSubtitle = Constants.videosList[position].subtitle;
                                  Constants.selectedVideoLink = Constants.videosList[position].videoLink;
                                });
                                Navigator.pushNamed(context, VideoScreen.videoScreenId);
                              },
                            ),
                          );
                        },
                      ),
                      isLoadingVertical == true
                          ? Center(
                              child: CircularProgressIndicator(
                                backgroundColor: ColorRefer.kOrangeColor,
                              ),
                            )
                          : SizedBox(
                              width: 0,
                              height: 0,
                            )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
