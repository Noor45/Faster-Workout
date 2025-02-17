import 'package:faster_workouts/controllers/video_controller.dart';
import 'package:faster_workouts/screens/fastest_workout_screen.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../cards/home_screen_card.dart';
import '../functions/global_functions.dart';
import '../controllers/auth_controller.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../utils/strings.dart';
import 'main_screen.dart';
import 'profile_screen.dart';
import 'quick_video_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _name;
  String _date;

  void _initData() {
    var formatter = new DateFormat('EEE dd MMMM');
    _date = formatter.format(DateTime.now());
    String userName = AuthController.currentUser.name;
    _name = userName ?? "User";
  }

  @override
  void initState() {
    _initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/day.svg',
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(width: 10),
                            AutoSizeText(_date,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: FontRefer.OpenSans,
                                    color: ColorRefer.kOrangeColor)),
                          ],
                        ),
                        SizedBox(height: 5),
                        AutoSizeText('Hi, ' + _name,
                            style: TextStyle(
                                fontSize: 23, fontFamily: FontRefer.OpenSans, fontWeight: FontWeight.w900)),
                      ],
                    ),
                    InkWell(
                      onTap: () async {
                        await Navigator.pushNamed(context, ProfileScreen.profileSCREEN);
                        setState(() {});
                      },
                      child: AuthController.currentUser.profileImageUrl != null
                          ? Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                      image: NetworkImage(AuthController.currentUser.profileImageUrl),
                                      fit: BoxFit.cover)),
                            )
                          : Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/user.png'), fit: BoxFit.cover)),
                            ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Welcome(
                  title: 'Welcome to Faster Workouts',
                  subTitle: StringRefer.kString,
                  cardHeight: width / 3.2,
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => MainScreen(
                          tab: 3,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 12),
                Column(
                  children: [
                    WorkOutsTab(
                      image: 'assets/images/launch.png',
                      title: 'Quict start video',
                      imageHeight: 50,
                      imageWidth: 50,
                      subTitle: StringRefer.kVideoPlayerString,
                      cardHeight: width / 3.2,
                      onPressed: () {
                        String videoID = getData('https://vimeo.com/566042837');
                        setState(() {
                          Constants.selectedVideoID = videoID;
                        });
                        Navigator.pushNamed(
                          context,
                          QuickVideo.quickVideoScreenID,
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    WorkOutsTab(
                      image: 'assets/images/fastest_workout.png',
                      title: 'Fastest Workout',
                      subTitle: StringRefer.kFastestWorkoutString,
                      cardHeight: width / 3.2,
                      imageHeight: 90,
                      imageWidth: 90,
                      onPressed: () async{
                        Constants.allow = false;
                        Constants.workoutType = Workouts.FastestWorkout;
                        await VideoDataController.getWorkoutVideos();
                        // Constants.fasterWorkoutValues = List.filled(6, 0);
                        Constants.fastestWorkoutValues = List.filled(6, 0);
                        Navigator.pushNamed(
                          context,
                          FastestWorkoutScreen.ID,
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    WorkOutsTab(
                      image: 'assets/images/faster_workout.png',
                      title: 'Faster Workout',
                      subTitle: StringRefer.kFasterWorkoutString,
                      cardHeight: width / 3.2,
                      imageHeight: 60,
                      imageWidth: 60,
                      onPressed: () async {
                        Constants.allow = false;
                        Constants.workoutType = Workouts.FasterWorkout;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => MainScreen(
                              tab: 3,
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
