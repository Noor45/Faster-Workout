import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../auth/select_gender.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';
import '../utils/strings.dart';
import '../widgets/round_button.dart';

class StartScreen extends StatefulWidget {
  static String startScreenID = "/start_screen";
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              'Left just a',
              style: TextStyle(fontSize: 30, fontFamily: FontRefer.OpenSans, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 5),
            AutoSizeText(
              'little bit',
              style: TextStyle(fontSize: 30, fontFamily: FontRefer.OpenSans, fontWeight: FontWeight.w900),
            ),
            SizedBox(height: 10),
            AutoSizeText(
              StringRefer.kStartString,
              style: TextStyle(
                fontSize: 14.5,
                height: 1.3,
                fontFamily: FontRefer.OpenSans,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: 15, right: 15),
              child: ButtonWithIcon(
                  title: 'Let\'s Start',
                  buttonRadius: 5,
                  colour: ColorRefer.kOrangeColor,
                  height: 40,
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, SelectGender.ID);
                  }),
            ),
          ],
        ),
      )),
    );
  }
}
