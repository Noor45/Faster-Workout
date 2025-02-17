import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialMediaIcons extends StatefulWidget {
  SocialMediaIcons({this.icon, this.color, this.onPressed, this.backGroundColor = Colors.white});
  final Color color;
  final Color backGroundColor;

  final String icon;
  final Function onPressed;

  @override
  _SocialMediaIconsState createState() => _SocialMediaIconsState();
}

class _SocialMediaIconsState extends State<SocialMediaIcons> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: widget.onPressed,
      child: Card(
        color: widget.backGroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        child: Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.brightness == Brightness.dark ? Colors.black54 : Colors.white,
              shape: BoxShape.circle,
            ),
            child: Container(
                child: SvgPicture.asset(
              widget.icon,
              width: 20,
              height: 20,
            ))),
      ),
    );
  }
}
