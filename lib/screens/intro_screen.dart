import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../auth/signin_screen.dart';
import '../shared_preferences/shared_preferences.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../widgets/round_button.dart';
import '../models/slider_model.dart';

class IntroScreens extends StatefulWidget {
  static String introScreenID = "/intro_screen";
  @override
  _IntroScreensState createState() => _IntroScreensState();
}

class _IntroScreensState extends State<IntroScreens> {
  List<SliderModel> mySlides;
  int slideIndex = 0;
  PageController controller;

  Future<void> _initIntroScreens() async {
    mySlides = getSlides();
    controller = new PageController();
    await LocalPreferences.preferences.setBool(LocalPreferences.OnBoardingScreensVisited, true);
  }

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: isCurrentPage ? 11.0 : 11.0,
      width: isCurrentPage ? 11.0 : 11.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.white : Colors.white.withOpacity(0.6),
      ),
    );
  }

  @override
  void initState() {
    _initIntroScreens();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    slideIndex = index;
                  });
                },
                children: <Widget>[
                  SlideTile(
                    imagePath: mySlides[0].getImageAssetPath(),
                    title: mySlides[0].getTitle(),
                    desc: mySlides[0].getDesc(),
                    showButton: false,
                  ),
                  SlideTile(
                    imagePath: mySlides[1].getImageAssetPath(),
                    title: mySlides[1].getTitle(),
                    desc: mySlides[1].getDesc(),
                    showButton: false,
                  ),
                  SlideTile(
                    imagePath: mySlides[2].getImageAssetPath(),
                    title: mySlides[2].getTitle(),
                    desc: mySlides[2].getDesc(),
                    showButton: true,
                  ),
                ],
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 1.10,
              child: Container(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (int i = 0; i < 3; i++)
                            i == slideIndex ? _buildPageIndicator(true) : _buildPageIndicator(false),
                        ],
                      ),
                    ),
                    Container(
                        child: slideIndex != 2
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    if (slideIndex == 0)
                                      controller.animateToPage(1,
                                          duration: Duration(milliseconds: 300), curve: Curves.linear);
                                    else if (slideIndex == 1)
                                      controller.animateToPage(2,
                                          duration: Duration(milliseconds: 300), curve: Curves.linear);
                                  });
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/arrow.svg',
                                  width: 13,
                                  height: 13,
                                  color: Colors.white,
                                ))
                            : InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, SignInScreen.signInScreenID);
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Text(
                                    'Done',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 14, fontFamily: FontRefer.OpenSans),
                                  ),
                                ),
                              ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SlideTile extends StatelessWidget {
  String imagePath, title, desc;
  bool showButton;
  Color backColor;

  SlideTile({
    this.imagePath,
    this.title,
    this.showButton,
    this.desc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(imagePath),
        fit: BoxFit.fill,
        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
      )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontFamily: FontRefer.OpenSans,
                fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 20),
          AutoSizeText(
            desc,
            style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontFamily: FontRefer.OpenSans,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Visibility(
              visible: showButton,
              child: RoundedButton(
                  title: 'GET STARTED',
                  buttonRadius: 5,
                  colour: ColorRefer.kOrangeColor.withOpacity(0.8),
                  height: 40,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, SignInScreen.signInScreenID);
                  }),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 7),
        ],
      ),
    );
  }
}
