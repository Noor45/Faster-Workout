import 'package:faster_workouts/services/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../utils/colors.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'how_to_workout_screen.dart';
import 'progress_screen.dart';

class MainScreen extends StatefulWidget {
  static const MainScreenId = 'main_screen';
  MainScreen({this.tab});
  final int tab;
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GlobalKey globalKey = new GlobalKey(debugLabel: 'btm_app_bar');
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool showSpinner = false;
  final List<dynamic> tabs = [
    HomeScreen(),
    ProgressScreen(),
    HistoryScreen(),
    HowToWorkOutScreen(),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.tab == null) {
      Constants.selectedIndex = 0;
    } else {
      Constants.selectedIndex = widget.tab;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
          key: _scaffoldKey,
          body: tabs[Constants.selectedIndex],
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: theme.brightness == Brightness.light ? Colors.white : Colors.white10,
              primaryColor: ColorRefer.kOrangeColor,
            ),
            child: BottomNavigationBar(
              key: globalKey,
              currentIndex: Constants.selectedIndex,
              unselectedItemColor: Colors.grey,
              selectedItemColor: ColorRefer.kOrangeColor,
              selectedIconTheme: Theme.of(context).primaryIconTheme.copyWith(color: ColorRefer.kOrangeColor),
              unselectedLabelStyle: TextStyle(fontFamily: FontRefer.OpenSans, fontSize: 11),
              selectedLabelStyle: TextStyle(fontFamily: FontRefer.OpenSans, fontSize: 11),
              selectedFontSize: 10,
              unselectedFontSize: 10,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 3, bottom: 3),
                    child: SvgPicture.asset(
                      'assets/icons/home.svg',
                      color: Constants.selectedIndex == 0 ? ColorRefer.kOrangeColor : ColorRefer.kGreyColor,
                    ),
                  ),
                  label: 'Home',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 3, bottom: 6),
                    child: SvgPicture.asset(
                      'assets/icons/progress.svg',
                      color: Constants.selectedIndex == 1 ? ColorRefer.kOrangeColor : ColorRefer.kGreyColor,
                    ),
                  ),
                  label: 'Progress',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 3, bottom: 6),
                    child: SvgPicture.asset(
                      'assets/icons/history.svg',
                      color: Constants.selectedIndex == 2 ? ColorRefer.kOrangeColor : ColorRefer.kGreyColor,
                    ),
                  ),
                  label: 'History',
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(top: 3, bottom: 6),
                    child: SvgPicture.asset(
                      'assets/icons/film.svg',
                      color: Constants.selectedIndex == 3 ? ColorRefer.kOrangeColor : ColorRefer.kGreyColor,
                    ),
                  ),

                  label: 'How to',
                  backgroundColor: Colors.white,
                ),
              ],
              onTap: (index) {
                switch (index) {
                  case 0:
                    FirebaseAnalyticsService.logEvent("home_screen");
                    break;
                  case 1:
                    FirebaseAnalyticsService.logEvent("progress_screen");
                    break;
                  case 2:
                    FirebaseAnalyticsService.logEvent("history_screen");
                    break;
                  case 3:
                    FirebaseAnalyticsService.logEvent("howto_screen");
                    break;
                }
                setState(() {
                  Constants.selectedIndex = index;
                });
              },
            ),
          )),
    );
  }
}
