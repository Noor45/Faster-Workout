import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../screens/main_screen.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../utils/style.dart';
import '../widgets/round_button.dart';

class WorkOutsTab extends StatefulWidget {
  WorkOutsTab(
      {this.onPressed,
      this.title,
      this.image,
      this.subTitle,
      this.cardHeight,
      this.imageHeight,
      this.imageWidth});
  final String title;
  final String subTitle;
  final String image;
  final double imageHeight;
  final double imageWidth;
  final double cardHeight;
  final Function onPressed;
  @override
  _WorkOutsTabState createState() => _WorkOutsTabState();
}

class _WorkOutsTabState extends State<WorkOutsTab> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: widget.onPressed,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          width: width,
          padding: EdgeInsets.only(left: 15, right: 10),
          height: widget.cardHeight,
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.light ? ColorRefer.kLightColor : Colors.white10,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                widget.image,
                height: widget.imageWidth,
                width: widget.imageHeight,
              ),
              Container(
                width: width / 1.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AutoSizeText(widget.title,
                        style: StyleRefer.kTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w900)),
                    SizedBox(height: 6),
                    Text(widget.subTitle,
                        softWrap: true, style: StyleRefer.kTextStyle.copyWith(fontSize: 11, height: 1.5)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class WelcomeCard extends StatefulWidget {
  WelcomeCard({this.width});
  final double width;
  @override
  _WelcomeCardState createState() => _WelcomeCardState();
}

class _WelcomeCardState extends State<WelcomeCard> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Card(
      elevation: 5,
      child: Container(
        height: widget.width / 1.9,
        width: widget.width,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.brightness == Brightness.light ? Colors.white : Colors.white10,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 5,
              height: widget.width / 1.9,
              decoration: StyleRefer.kWelcomeCardDecoration,
            ),
            Container(
              width: widget.width / 1.2,
              height: widget.width / 1.9,
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(0, 8, 9, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome to',
                      style: StyleRefer.kTextStyle
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w900, color: ColorRefer.kGreyColor)),
                  SizedBox(height: 3),
                  AutoSizeText('Faster Workouts',
                      style: StyleRefer.kTextStyle.copyWith(
                          fontSize: 16, fontWeight: FontWeight.w900, color: ColorRefer.kOrangeColor)),
                  SizedBox(height: 4),
                  Text(StringRefer.kString,
                      style: StyleRefer.kTextStyle.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: theme.brightness == Brightness.light ? Colors.black38 : ColorRefer.kGreyColor,
                      )),
                  SizedBox(height: 2),
                  Container(
                    padding: EdgeInsets.only(right: widget.width / 2),
                    child: RoundedButton(
                        height: 32,
                        colour: ColorRefer.kOrangeColor,
                        title: 'Learn More',
                        buttonRadius: 4,
                        fontSize: 12,
                        onPressed: () async {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => MainScreen(
                                tab: 3,
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Welcome extends StatefulWidget {
  Welcome({this.onPressed, this.title, this.subTitle, this.cardHeight});
  final String title;
  final String subTitle;
  final double cardHeight;
  final Function onPressed;
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: widget.onPressed,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Container(
          width: width,
          padding: EdgeInsets.only(left: 20, right: 20),
          height: widget.cardHeight,
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.light ? ColorRefer.kLightColor : Colors.white10,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Container(
            width: width / 1.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AutoSizeText(widget.title,
                    style: StyleRefer.kTextStyle.copyWith(fontSize: 16, fontWeight: FontWeight.w900)),
                SizedBox(height: 6),
                Text(widget.subTitle,
                    softWrap: true, style: StyleRefer.kTextStyle.copyWith(fontSize: 11, height: 1.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
