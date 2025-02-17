import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/fonts.dart';

class RoundedButton extends StatefulWidget {
  RoundedButton(
      {this.title, this.colour, this.height, this.fontSize, @required this.onPressed, this.buttonRadius});

  final Color colour;
  final String title;
  final double height;
  final Function onPressed;
  final double buttonRadius;
  final double fontSize;
  @override
  _RoundedButtonState createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.buttonRadius),
      ),
      highlightElevation: 0,
      height: widget.height,
      elevation: 0,
      color: widget.colour,
      minWidth: MediaQuery.of(context).size.width,
      child: Text(
        widget.title,
        style:
            TextStyle(color: Colors.white, fontSize: widget.fontSize ?? 13, fontFamily: FontRefer.OpenSans),
      ),
    );
  }
}

class ButtonWithIcon extends StatelessWidget {
  ButtonWithIcon({this.title, this.colour, this.height, @required this.onPressed, this.buttonRadius});

  final Color colour;
  final String title;
  final double height;
  final Function onPressed;
  final double buttonRadius;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      color: colour,
      borderRadius: BorderRadius.circular(buttonRadius),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: MediaQuery.of(context).size.width,
        child: Container(
          height: height,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                ' ',
                style: TextStyle(
                  color: ColorRefer.kOrangeColor,
                ),
              ),
              Text(
                title,
                style: TextStyle(color: Colors.white, fontFamily: FontRefer.OpenSans),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
                size: 15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
