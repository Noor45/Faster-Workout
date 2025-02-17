import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import '../utils/colors.dart';
import '../utils/style.dart';
import '../widgets/quality_links.dart';
import '../widgets/fullscreen_player.dart';

class PlayerCard extends StatefulWidget {
  PlayerCard({this.videoID});
  final String videoID;
  @override
  _PlayerCardState createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  VideoPlayerController controller;
  Future<void> initFuture;
  bool autoPlay = false;
  bool looping = false;
  bool _overlay = true;
  QualityLinks _quality;
  Map _qualityValues;
  var _qualityValue;
  int position = 0;
  bool call = false;
  bool show = false;
  double videoHeight;
  double videoWidth;
  double videoMargin;
  bool _seek = false;
  double doubleTapRMargin = 36;
  double doubleTapRWidth = 400;
  double doubleTapRHeight = 160;
  double doubleTapLMargin = 10;
  double doubleTapLWidth = 400;
  double doubleTapLHeight = 160;
  void initState() {
    _quality = QualityLinks(widget.videoID);
    _quality.getQualitiesSync().then((value) {
      _qualityValues = value;
      _qualityValue = value[value.lastKey()];
      controller = VideoPlayerController.network(_qualityValue);
      controller.setLooping(looping);
      if (autoPlay) controller.play();
      initFuture = controller.initialize();
      if (mounted)
        setState(() {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
        });
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.initState();
  }

  Future<void> _disposeVideoPlayer() async {
    if (show == true) {
      controller.pause();
      await controller.dispose();
    }
  }

  @override
  void dispose() {
    _disposeVideoPlayer();
    super.dispose();
  }

  dismissOverlay() {
    setState(() {
      if (controller.value.isPlaying) {
        print(controller.value.position.inSeconds > 3);
        _overlay = false;
      }
    });
  }

  void startTimer(int sec) {
    setState(() {
      call = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              print(sec);
              if (sec <= 0) {
                _overlay = false;
                call = false;
                return;
              } else {
                if (controller.value.isPlaying) {
                  sec--;
                  startTimer(sec);
                }
              }
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        children: [
          GestureDetector(
            child: FutureBuilder(
                future: initFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    show = true;
                    double delta = MediaQuery.of(context).size.width -
                        MediaQuery.of(context).size.height * controller.value.aspectRatio;
                    if (MediaQuery.of(context).orientation == Orientation.portrait || delta < 0) {
                      videoHeight = MediaQuery.of(context).size.width / controller.value.aspectRatio;
                      videoWidth = MediaQuery.of(context).size.width;
                      videoMargin = 0;
                    } else {
                      videoHeight = MediaQuery.of(context).size.height;
                      videoWidth = videoHeight * controller.value.aspectRatio;
                      videoMargin = (MediaQuery.of(context).size.width - videoWidth) / 2;
                    }
                    if (_seek && controller.value.duration.inSeconds > 2) {
                      controller.seekTo(Duration(seconds: position));
                      _seek = false;
                    }
                    return Stack(
                      children: <Widget>[
                        Container(
                          height: videoHeight,
                          width: videoWidth,
                          margin: EdgeInsets.only(left: videoMargin),
                          child: VideoPlayer(controller),
                        ),
                        _videoOverlay(),
                      ],
                    );
                  } else {
                    return Center(
                        heightFactor: 6,
                        child: CircularProgressIndicator(
                          backgroundColor: ColorRefer.kOrangeColor,
                          strokeWidth: 4,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                        ));
                  }
                }),
            onTap: () {
              setState(() {
                _overlay = !_overlay;
                if (_overlay) {
                  if (controller.value.isPlaying == true) {
                    if (call == false) {
                      startTimer(3);
                    }
                  } else {
                    call = false;
                  }
                  doubleTapRHeight = videoHeight - 36;
                  doubleTapLHeight = videoHeight - 10;
                  doubleTapRMargin = 36;
                  doubleTapLMargin = 10;
                } else if (!_overlay) {
                  doubleTapRHeight = videoHeight + 36;
                  doubleTapLHeight = videoHeight + 16;
                  doubleTapRMargin = 0;
                  doubleTapLMargin = 0;
                }
              });
            },
          ),
        ],
      ),
    );
  }

  //================================ OVERLAY ================================//
  Widget _videoOverlay() {
    return _overlay
        ? Stack(
            children: <Widget>[
              GestureDetector(
                child: Center(
                  child: Container(
                    width: videoWidth,
                    height: videoHeight,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [const Color(0x662F2C47), const Color(0x662F2C47)],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: IconButton(
                    padding: EdgeInsets.only(top: videoHeight / 2 - 30, bottom: videoHeight / 2 - 30),
                    icon: controller.value.isPlaying
                        ? Icon(Icons.pause, color: ColorRefer.kOrangeColor, size: 60.0)
                        : Icon(Icons.play_arrow, color: ColorRefer.kOrangeColor, size: 60.0),
                    onPressed: () {
                      setState(() {
                        controller.value.isPlaying ? controller.pause() : controller.play();
                        if (controller.value.isPlaying == true) {
                          if (call == false) {
                            startTimer(3);
                          }
                        } else {
                          call = false;
                        }
                        // if(controller.value.isPlaying == true)  {
                        //   Future.delayed(Duration(seconds: 5), (){
                        //     _overlay = false;
                        //   });
                        // }
                      });
                      // dismissOverlay();
                    }),
              ),
              Container(
                margin: EdgeInsets.only(left: videoWidth + videoMargin - 48),
                child: IconButton(
                    icon: Icon(Icons.settings, size: 26.0),
                    onPressed: () {
                      position = controller.value.position.inSeconds;
                      _seek = true;
                      controller.pause();
                      _settingModalBottomSheet(context);
                      setState(() {});
                    }),
              ),
              Container(
                margin: EdgeInsets.only(top: videoHeight - 26, left: videoMargin), //CHECK IT
                child: _videoOverlaySlider(),
              )
            ],
          )
        : Center(
            child: Container(
              height: 5,
              width: videoWidth,
              margin: EdgeInsets.only(top: videoHeight - 5),
              child: VideoProgressIndicator(
                controller,
                allowScrubbing: true,
                colors: VideoProgressColors(
                  playedColor: ColorRefer.kOrangeColor,
                  backgroundColor: Color(0x5515162B),
                  bufferedColor: Color(0x5583D8F7),
                ),
                padding: EdgeInsets.only(top: 2),
              ),
            ),
          );
  }

  //=================== ПОЛЗУНОК ===================//
  Widget _videoOverlaySlider() {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, VideoPlayerValue value, child) {
        if (!value.hasError && value.isInitialized) {
          return Row(
            children: <Widget>[
              Container(
                width: 33,
                alignment: Alignment.centerRight,
                child: Text(
                  value.position.inMinutes.toString() +
                      ':' +
                      (value.position.inSeconds - value.position.inMinutes * 60).toString(),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 3, right: 3),
                child: Text(
                  '/',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                width: 35,
                alignment: Alignment.centerLeft,
                child: Text(
                  value.duration.inMinutes.toString() +
                      ':' +
                      (value.duration.inSeconds - value.duration.inMinutes * 60).toString(),
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ),
              Container(
                height: 20,
                width: videoWidth - 110,
                child: VideoProgressIndicator(
                  controller,
                  allowScrubbing: true,
                  colors: VideoProgressColors(
                    playedColor: ColorRefer.kOrangeColor,
                    backgroundColor: Color(0x5515162B),
                    bufferedColor: Color(0x5583D8F7),
                  ),
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                ),
              ),
              Container(
                width: 30,
                child: InkWell(
                    onTap: () async {
                      setState(() {
                        controller.pause();
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        position = await Navigator.push(
                            context,
                            PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (BuildContext context, _, __) => FullscreenPlayer(
                                    id: widget.videoID,
                                    autoPlay: true,
                                    controller: controller,
                                    position: controller.value.position.inSeconds,
                                    initFuture: initFuture,
                                    qualityValue: _qualityValue),
                                transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(scale: animation, child: child),
                                  );
                                }));
                        controller.play();
                        _seek = true;
                      });
                    },
                    child: Icon(Icons.fullscreen, size: 20.0)),
              ),
            ],
          );
        } else {
          return Container();
        }
      },
    );
  }

  //================================ Quality ================================//
  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          //Формирования списка качества
          final children = <Widget>[];
          _qualityValues.forEach((elem, value) {
            if (elem.toString().contains('240p') == true) {
            } else {
              children.add(
                new ListTile(
                    title: new Text(" ${elem.toString()} fps"),
                    onTap: () => {
                          setState(() {
                            _qualityValue = value;
                            controller = VideoPlayerController.network(_qualityValue);
                            controller.setLooping(true);
                            _seek = true;
                            initFuture = controller.initialize();
                            controller.play();
                            dismissOverlay();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pop(context);
                            });
                          }),
                        }),
              );
            }
          });
          //Вывод элементов качество списком
          return Container(
            child: Wrap(
              children: children,
            ),
          );
        });
  }
}

class MoreVideoTab extends StatefulWidget {
  MoreVideoTab({this.onPressed, this.videoLink, this.thumbnail, this.title, this.subtitle});
  final String videoLink;
  final String title;
  final String subtitle;
  final String thumbnail;
  final Function onPressed;
  @override
  _MoreVideoTabState createState() => _MoreVideoTabState();
}

class _MoreVideoTabState extends State<MoreVideoTab> {
  String subTitle = '';
  @override
  void initState() {
    if (widget.subtitle.length > 50) {
      subTitle = widget.subtitle.substring(0, 50) + '...';
    } else {
      subTitle = widget.subtitle;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: width / 4.3,
                  width: width / 2.7,
                  color: ColorRefer.kGreyColor,
                  child: widget.thumbnail.contains('assets/images/') == true  ?
                  Image.asset(
                    widget.thumbnail,
                    fit: BoxFit.fill,
                  ) : FadeInImage.assetNetwork(
                    placeholder: 'assets/images/image_placeholder.jpg',
                    image: widget.thumbnail,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width / 1.9,
                      child: Text(
                        widget.title,
                        softWrap: true,
                        style: StyleRefer.kTextStyle
                            .copyWith(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      width: width / 2,
                      child: Text(
                        subTitle,
                        style: StyleRefer.kTextStyle
                            .copyWith(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
