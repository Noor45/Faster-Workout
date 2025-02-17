import 'package:flutter/material.dart';
import '../widgets/gradient.dart';
import 'colors.dart';
import 'fonts.dart';

class StyleRefer {
  static var kTextFieldDecoration = InputDecoration(
    hintStyle: TextStyle(
      color: ColorRefer.kDarkColor,
      fontSize: 12,
    ),
    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorRefer.kDarkColor)),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorRefer.kGreyColor)),
    focusColor: Colors.black,
    contentPadding: EdgeInsets.only(left: 0, top: 3),
  );

  static var kSliderDecoration = SliderThemeData(
    trackHeight: 2,
    thumbColor: Colors.white,
    activeTrackColor: ColorRefer.kOrangeColor,
    inactiveTrackColor: ColorRefer.kGreyColor,
    valueIndicatorColor: ColorRefer.kOrangeColor,
    showValueIndicator: ShowValueIndicator.onlyForContinuous,
    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
    valueIndicatorTextStyle: TextStyle(
      color: Colors.white,
    ),
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15, elevation: 3),
  );
  static var kWelcomeCardDecoration = BoxDecoration(
    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
    color: ColorRefer.kOrangeColor,
  );

  static TextStyle kTextStyle = TextStyle(fontFamily: FontRefer.OpenSans);

  static TextStyle kCheckBoxTextStyle = TextStyle(fontFamily: FontRefer.SansSerif, fontSize: 12);

  static LinearGradient gradient = LinearGradient(colors: <Color>[
    Color(0xffff5757),
    Color(0xfffffa23),
    Color(0xff86fe1a),
    Color(0xff09fe72),
  ]);
  static var kSliderBar = SliderThemeData(
    trackHeight: 25,
    thumbColor: Colors.white,
    showValueIndicator: ShowValueIndicator.never,
    trackShape: GradientRectSliderTrackShape(gradient: gradient, darkenInactive: false),
    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 15, elevation: 3),
  );
}
