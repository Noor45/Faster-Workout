import 'package:auto_size_text/auto_size_text.dart';
import 'package:faster_workouts/utils/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:recursive_regex/recursive_regex.dart';
import '../cards/video_screen_card.dart';
import '../controllers/video_controller.dart';
import '../utils/constants.dart';
import '../utils/colors.dart';
import '../utils/style.dart';

class VideoScreen extends StatefulWidget {
  static const videoScreenId = 'video_screen';
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  GlobalKey _scaffoldKey;
  bool isLoadingVertical = false;
  Future _loadMoreVertical() async {
    Constants.moreVideoLimit = Constants.videoLimit + 10;
    () async {
      setState(() {
        isLoadingVertical = true;
      });
      await VideoDataController.getMoreVideos(Constants.moreVideoLimit);
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
    Constants.moreVideoLimit = 10;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(Constants.selectedVideoTitle, style: StyleRefer.kTextStyle.copyWith(fontSize: 16)),
      ),
      body: SafeArea(
          child: Container(
        color: theme.brightness == Brightness.light ? ColorRefer.kDarkGreyColor : Colors.black12,
        width: width,
        height: height,
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            Container(
              child: PlayerCard(
                videoID: Constants.selectedVideoID,
              ),
            ),
            Container(
              width: width,
              color: theme.brightness == Brightness.light ? ColorRefer.kLightColor : Colors.black38,
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Constants.selectedVideoTitle,
                    style: StyleRefer.kTextStyle.copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 2),
                  Text(
                    Constants.selectedVideoSubtitle,
                    style: StyleRefer.kTextStyle.copyWith(
                      fontSize: 13,
                      color: theme.brightness == Brightness.light ? Colors.black54 : Colors.white60,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Text(
                'More',
                style: StyleRefer.kTextStyle.copyWith(
                  fontSize: 15,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
            ),
            LazyLoadScrollView(
              isLoading: isLoadingVertical,
              scrollOffset: 20,
              onEndOfPage: () => _loadMoreVertical(),
              child: SizedBox(
                height: height / 2.5,
                child: Constants.moreVideoList.length == null || Constants.moreVideoList.length == 0
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
                ) :
                    ListView(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: Constants.moreVideoLimit > Constants.moreVideoList.length
                          ? Constants.moreVideoList.length
                          : Constants.moreVideoLimit,
                      itemBuilder: (context, position) {
                        return Constants.moreVideoList[position].videoLink == Constants.selectedVideoLink
                            ? Container()
                            : MoreVideoTab(
                                title: Constants.moreVideoList[position].title,
                                subtitle: Constants.moreVideoList[position].subtitle,
                                videoLink: Constants.moreVideoList[position].videoLink,
                                thumbnail: Constants.moreVideoList[position].thumbnail == null
                                    ? ''
                                    : Constants.moreVideoList[position].thumbnail,
                                onPressed: () async {
                                  String videoID = await getData(Constants.moreVideoList[position].videoLink);
                                  setState(() {
                                    Constants.selectedVideoID = videoID;
                                    Constants.selectedVideoTitle = Constants.moreVideoList[position].title;
                                    Constants.selectedVideoSubtitle =
                                        Constants.moreVideoList[position].subtitle;
                                    Constants.selectedVideoLink = Constants.moreVideoList[position].videoLink;
                                  });
                                  await Navigator.pushReplacement(context,  PageRouteBuilder(
                                    pageBuilder: (_, __, ___) => VideoScreen(),

                                    transitionDuration: Duration(seconds: 0),
                                  ));
                                  // await Navigator.pushReplacementNamed(context, VideoScreen.videoScreenId);
                                },
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
          ],
        ),
      )),
    );
  }

  Future<String> getData(String videoLink) async {
    final input = videoLink + '.';
    String videoID = '';
    final regex = RecursiveRegex(
      startDelimiter: RegExp(r'https://vimeo.com/'),
      endDelimiter: RegExp(r'[.]'),
      captureGroupName: 'value',
      caseSensitive: true,
    );
    regex.getMatches(input).forEach((element) {
      String id = element.namedGroup('value');
      if (id.contains('/')) {
        List word = id.split('/');
        videoID = word[0];
      } else {
        videoID = id;
      }
    });
    return videoID;
  }
}
