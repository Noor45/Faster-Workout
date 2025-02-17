import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../functions/workout_message_functions.dart';
import '../utils/style.dart';

class FasterWorkoutMessageCard extends StatefulWidget {
  @override
  _FasterWorkoutMessageCardState createState() => _FasterWorkoutMessageCardState();
}

class _FasterWorkoutMessageCardState extends State<FasterWorkoutMessageCard> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(30, 0, 30, 0);
  final ScrollController _scrollController = ScrollController();
  String message1 = '';
  String message2 = '';

  calculateResult() {
    setState(() {
      message1 = FastestWorkoutMessageFunction.messageOne();
      message2 = FastestWorkoutMessageFunction.messageTwo();
    });
  }

  @override
  void initState() {
    calculateResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height / 2.5,
      // color: Colors.red,
      child: RawScrollbar(
        controller: _scrollController,
        radius: Radius.circular(20),
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                width: width,
                height: width / 3,
                padding: paddingValues,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xfff9f9f9).withOpacity(0.9),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: AutoSizeText(message1,
                    textAlign: TextAlign.center,
                    style: StyleRefer.kTextStyle
                        .copyWith(fontSize: 15, color: Colors.black54, letterSpacing: 0.5)),
              ),
              SizedBox(height: 20),
              Visibility(
                visible: message2 == '' ? false : true,
                child: Container(
                  width: width,
                  height: width / 2.7,
                  padding: paddingValues,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Color(0xfff9f9f9).withOpacity(0.9),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: AutoSizeText(message2,
                      textAlign: TextAlign.center,
                      style: StyleRefer.kTextStyle
                          .copyWith(fontSize: 15, color: Colors.black54, letterSpacing: 0.5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FastestWorkoutMessageCard extends StatefulWidget {
  @override
  _FastestWorkoutMessageCardState createState() => _FastestWorkoutMessageCardState();
}

class _FastestWorkoutMessageCardState extends State<FastestWorkoutMessageCard> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(15, 15, 15, 15);
  String message1 = '';
  String message2 = '';
  String message3 = '';
  calculateResult() {
    message1 = FastestWorkoutMessageFunction.messageOne();
    message2 = FastestWorkoutMessageFunction.messageTwo();
    message3 = FastestWorkoutMessageFunction.messageThree();
  }

  @override
  void initState() {
    calculateResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Visibility(
          visible: message1 == '' ? false : true,
          child: Container(
            width: width,
            // height: width / 3,
            padding: paddingValues,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xfff9f9f9).withOpacity(0.9),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: AutoSizeText(message1,
                textAlign: TextAlign.center,
                style: StyleRefer.kTextStyle.copyWith(fontSize: 15, color: Colors.black54, letterSpacing: 0.5)),
          ),
        ),
        SizedBox(height: 20),
        Visibility(
          visible: message2 == '' ? false : true,
          child: Container(
            width: width,
            // height: width / 2.7,
            padding: paddingValues,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xfff9f9f9).withOpacity(0.9),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: AutoSizeText(message2,
                textAlign: TextAlign.center,
                style:
                    StyleRefer.kTextStyle.copyWith(fontSize: 15, color: Colors.black54, letterSpacing: 0.5)),
          ),
        ),
        SizedBox(height: 20),
        Visibility(
          visible: message3 == '' ? false : true,
          child: Container(
            width: width,
            // height: width / 2.7,
            padding: paddingValues,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xfff9f9f9).withOpacity(0.9),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: AutoSizeText(message3,
                textAlign: TextAlign.center,
                style:
                StyleRefer.kTextStyle.copyWith(fontSize: 15, color: Colors.black54, letterSpacing: 0.5)),
          ),
        ),
      ],
    );
  }
}
