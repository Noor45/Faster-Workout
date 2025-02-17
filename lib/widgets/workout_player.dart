import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:chewie_audio/chewie_audio.dart';
import 'package:toast/toast.dart';
import '../utils/colors.dart';
import '../utils/style.dart';
import 'fullscreen_player.dart';
import 'quality_links.dart';
import 'round_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';


class WorkoutsVideoPlayer extends StatefulWidget {
  WorkoutsVideoPlayer({this.videoID, this.timerRange, this.audioUrl, this.title, this.onDone});
  final String videoID;
  final String audioUrl;
  final int timerRange;
  final String title;
  final Function onDone;
  @override
  _WorkoutsVideoPlayerState createState() => _WorkoutsVideoPlayerState();
}

class _WorkoutsVideoPlayerState extends State<WorkoutsVideoPlayer> {
  Duration audioDuration = Duration(), audioPosition = Duration();
  Duration videoPosition = Duration(), videoDuration = Duration();
  VideoPlayerController videoController, audioController;
  ChewieAudioController _chewieAudioController;
  int secs = 0, min = 0;
  Future<void> initFuture; QualityLinks videoQuality; Map videoQualityValues; var videoQualityValue;
  bool call = false, timer = false, show = false, autoPlay = false, looping = false,
  _overlay = true, _seek = false, isAudio = false;
  double videoHeight, videoWidth, videoMargin, doubleTapRMargin = 36, doubleTapRWidth = 400,
  doubleTapRHeight = 160, doubleTapLMargin = 10, doubleTapLWidth = 400, doubleTapLHeight = 160, volume = 1.0;

  void initVideoPlayer() {
    min = widget.timerRange;
    videoQuality = QualityLinks(widget.videoID);
    videoQuality.getQualitiesSync().then((value) {
      videoQualityValues = value;
      videoQualityValue = value[value.lastKey()];
      videoController = VideoPlayerController.network(videoQualityValue);
      audioController  = VideoPlayerController.network(videoQualityValue);
      initFuture = videoController.initialize();
      audioController.initialize();
      videoController.addListener(() {
          WidgetsBinding.instance
              .addPostFrameCallback((_) => setState(() {
            audioPosition = videoController.value.position;
            audioDuration = videoController.value.duration;
          }));
      });
      _chewieAudioController = ChewieAudioController(
        videoPlayerController: audioController,
      );
      setState(() {
        audioDuration = _chewieAudioController.videoPlayerController.value.duration;
      });
      _chewieAudioController.addListener(() {
        WidgetsBinding.instance
            .addPostFrameCallback((_) => setState(() {
          videoPosition = _chewieAudioController.videoPlayerController.value.position;
          videoDuration = _chewieAudioController.videoPlayerController.value.duration;
        }));
      });
      if (mounted)
        setState(() {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
        });
    });
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
  }

  dismissOverlay() {
    setState(() {
      Future.delayed(Duration(seconds: 3), () {
        setState(() {
          _overlay = false;
        });
      });
    });
  }

  startTimer(int sec) {
    setState(() {
      call = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              if (sec <= 0) {
                _overlay = false;
                call = false;
                return;
              } else {
                if (videoController.value.isPlaying) {
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

  disposeVideoPlayer() async {
    if (show == true) {
      videoController.removeListener((){});
      videoController.pause();
      await videoController.dispose();
    }
  }

  disposeAudioPlayer() {
    if (show == true) {
      // audioPlayer.stop();
      _chewieAudioController.pause();
      _chewieAudioController.dispose();
    }
  }

  @override
  void initState() {
    initVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    disposeVideoPlayer();
    disposeAudioPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(15, 25, 15, 15),
            child: AutoSizeText(widget.title, textAlign: TextAlign.center, style: StyleRefer.kTextStyle.copyWith(fontSize: 13)),
          ),
          SizedBox(height: 8),
          Container(
            color: Colors.black,
            child: GestureDetector(
              child: FutureBuilder(
                  future: initFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      show = true;
                      double delta = MediaQuery.of(context).size.width -
                          MediaQuery.of(context).size.height * videoController.value.aspectRatio;
                      if (MediaQuery.of(context).orientation == Orientation.portrait || delta < 0) {
                        videoHeight = MediaQuery.of(context).size.width / videoController.value.aspectRatio;
                        videoWidth = MediaQuery.of(context).size.width;
                        videoMargin = 0;
                      } else {
                        videoHeight = MediaQuery.of(context).size.height;
                        videoWidth = videoHeight * videoController.value.aspectRatio;
                        videoMargin = (MediaQuery.of(context).size.width - videoWidth) / 2;
                      }
                      if (_seek && videoController.value.duration.inSeconds > 2) {
                        videoController.seekTo(videoPosition);
                        _seek = false;
                      }
                      return Stack(
                        children: <Widget>[
                          Container(
                            height: videoHeight,
                            width: videoWidth,
                            margin: EdgeInsets.only(left: videoMargin),
                            child: VideoPlayer(videoController),
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
                    if (videoController.value.isPlaying == true) {
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
                  }
                  else if (!_overlay) {
                    doubleTapRHeight = videoHeight + 36;
                    doubleTapLHeight = videoHeight + 16;
                    doubleTapRMargin = 0;
                    doubleTapLMargin = 0;
                  }
                });
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 30, right: 30, top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    VideoPlayerButton(
                      onPress: () async {
                        if (show == true) {
                          await videoController.seekTo(Duration.zero);
                          setState(() {
                            videoController.play();
                            secs = 0;
                            min = widget.timerRange;
                            timer = true;
                          });
                        }
                      },
                      buttonColor: theme.brightness == Brightness.light
                          ? ColorRefer.kVideoPlayerButtonColor
                          : Colors.white10,
                      buttonSize: 40,
                      iconSize: 22,
                      iconColor: Color(0xffc3c6d6),
                      icon: CupertinoIcons.refresh_thick,
                    ),
                    SizedBox(width: 10),
                    VideoPlay(
                      onPress: () async {
                        if (show == true) {
                          setState(() {
                            videoPosition = Duration(seconds: videoController.value.position.inSeconds - 10);
                            _seek = true;
                          });
                        }
                      },
                      buttonColor: theme.brightness == Brightness.light
                          ? ColorRefer.kVideoPlayerButtonColor
                          : Colors.white10,
                      iconColor: Color(0xffc3c6d6),
                      buttonSize: 40,
                      iconSize: 23,
                      icon: 'assets/icons/reverse.svg',
                    ),
                  ],
                ),
                SizedBox(width: 5),
                VideoPlayerButton(
                  onPress: () {
                    setState(() {
                      if (show == true) {
                        if (videoController.value.isPlaying == true) {
                          if (call == false) {
                            startTimer(3);
                          }
                        } else {
                          call = false;
                        }
                        videoController.addListener(() async{
                          audioPosition = videoController.value.position;
                          audioDuration = videoController.value.duration;
                        });
                        setState(() {
                          if(videoController.value.isPlaying == false){
                            videoController.seekTo(audioPosition);
                            convertAudio(false);
                          }
                          videoController.value.isPlaying ? videoController.pause() : videoController.play();
                        });
                      }
                    });
                  },
                  buttonSize: 55,
                  iconSize: 35,
                  iconColor: Colors.white,
                  icon: show == false ? Icons.play_arrow_rounded : videoController.value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  buttonColor: ColorRefer.kGraph1Color,
                ),
                SizedBox(width: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    VideoPlay(
                      onPress: () async {
                        if (show == true) {
                          setState(() {
                            videoPosition = Duration(seconds: videoController.value.position.inSeconds + 10);
                            _seek = true;
                          });
                          videoController.addListener(() async{
                            audioPosition = videoController.value.position;
                            audioDuration = videoController.value.duration;
                          });
                        }
                      },
                      buttonColor: theme.brightness == Brightness.light
                          ? ColorRefer.kVideoPlayerButtonColor
                          : Colors.white10,
                      iconColor: Color(0xffc3c6d6),
                      buttonSize: 40,
                      iconSize: 23,
                      icon: 'assets/icons/forword.svg',
                    ),
                    SizedBox(width: 10),
                    VideoPlayerButton(
                      onPress: () {
                        if (show == true) {
                          if (isAudio == false){
                            convertAudio(true);
                            playAudio();
                            Toast.show("Voice mode only", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          }
                          else if (isAudio == true){
                            convertAudio(false);
                            playVideo();
                            Toast.show("Video mode", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          }
                        }
                      },
                      buttonColor: theme.brightness == Brightness.light
                          ? isAudio == true ? Color(0xff3098DD) : ColorRefer.kVideoPlayerButtonColor
                          : isAudio == true ? Color(0xff3098DD) : Colors.white10,
                      iconColor: Color(0xffc3c6d6),
                      buttonSize: 40,
                      iconSize: 23,
                      icon: show == false
                          ? Icons.headset_off
                          : isAudio == false
                              ? Icons.headset_off
                              : Icons.headset
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, right: 25, top: 50),
            child: RoundedButton(
              title: 'I’m Done the Workout!',
              buttonRadius: 8,
              colour: ColorRefer.kOrangeColor,
              height: 40,
              onPressed: () {
                if (show == true) {
                  videoController.pause();
                  widget.onDone.call();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future playVideo() async {
    if (show == true) {
      await _chewieAudioController.pause();
      await videoController.seekTo(_chewieAudioController.videoPlayerController.value.position);
      await videoController.play();
    }
  }

  Future convertAudio(bool convert) async {
    setState(() {
      isAudio = convert;
    });
  }

  Future playAudio() async {
    if (show == true) {
      await videoController.pause();
      await _chewieAudioController.seekTo((videoController.value.position));
      await _chewieAudioController.play();
    }
  }

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
              Container(
                margin: EdgeInsets.only(left: videoWidth + videoMargin - 48),
                child: IconButton(
                    icon: Icon(Icons.settings, size: 20.0),
                    onPressed: () {
                      videoPosition = Duration(seconds: videoController.value.position.inSeconds);
                      _seek = true;
                      videoController.pause();
                      _settingModalBottomSheet(context);
                      setState(() {});
                    }),
              ),
              Container(
                margin: EdgeInsets.only(top: videoHeight - 26, left: videoMargin),
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
                videoController,
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

  Widget _videoOverlaySlider() {
    return ValueListenableBuilder(
      valueListenable: videoController,
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
                  videoController,
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
                        videoController.pause();
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        int position = 0 ;
                        position = await Navigator.push(
                            context,
                            PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (BuildContext context, _, __) => FullscreenPlayer(
                                    id: widget.videoID,
                                    autoPlay: true,
                                    controller: videoController,
                                    position: videoController.value.position.inSeconds,
                                    initFuture: initFuture,
                                    qualityValue: videoQualityValue),
                                transitionsBuilder: (___, Animation<double> animation, ____, Widget child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: ScaleTransition(scale: animation, child: child),
                                  );
                                }));
                        setState(() {
                          videoPosition = Duration(seconds: position);
                          videoController.play();
                          _seek = true;
                        });
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

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          final children = <Widget>[];
          videoQualityValues.forEach((elem, value) {
            if (elem.toString().contains('240p') == true) {
            } else {
              children.add(
                new ListTile(
                    title: new Text(" ${elem.toString()} fps"),
                    onTap: () => {
                          setState(() {
                            videoQualityValue = value;
                            videoController = VideoPlayerController.network(videoQualityValue);
                            videoController.setLooping(true);
                            _seek = true;
                            initFuture = videoController.initialize();
                            videoController.play();
                            dismissOverlay();
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pop(context);
                            });
                          }),
                        }),
              );
            }
          });
          return Container(
            child: Wrap(
              children: children,
            ),
          );
        });
  }

}

class VideoPlayerButton extends StatelessWidget {
  final double buttonSize;
  final double iconSize;
  final Color buttonColor;
  final Function onPress;
  final IconData icon;
  final Color iconColor;

  const VideoPlayerButton(
      {Key key, this.buttonSize, this.iconSize, this.buttonColor, this.onPress, this.icon, this.iconColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.buttonSize,
      width: this.buttonSize,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: this.buttonColor ?? ColorRefer.kVideoPlayerButtonColor),
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.buttonSize / 2),
        ),
        onPressed: this.onPress,
        child: Center(
          child: Icon(
            this.icon,
            color: this.iconColor ?? ColorRefer.kGreyColor,
            size: this.iconSize,
          ),
        ),
      ),
    );
  }
}

class VideoPlay extends StatelessWidget {
  final double buttonSize;
  final double iconSize;
  final Color buttonColor;
  final Function onPress;
  final String icon;
  final Color iconColor;

  const VideoPlay(
      {Key key, this.buttonSize, this.iconSize, this.buttonColor, this.onPress, this.icon, this.iconColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.buttonSize,
      width: this.buttonSize,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: this.buttonColor ?? ColorRefer.kVideoPlayerButtonColor),
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.buttonSize / 2),
        ),
        onPressed: this.onPress,
        child: Center(
          child: SvgPicture.asset(
            this.icon,
            color: this.iconColor ?? ColorRefer.kGreyColor,
            height: this.iconSize,
            width: this.iconSize,
          ),
        ),
      ),
    );
  }
}