import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/colors.dart';
import '../utils/style.dart';

class WorkoutInfoCard extends StatefulWidget {
  WorkoutInfoCard({this.title, this.onChanged, this.slideValue, this.max});
  final String title;
  final double slideValue;
  final Function onChanged;
  final double max;
  @override
  _WorkoutInfoCardState createState() => _WorkoutInfoCardState();
}

class _WorkoutInfoCardState extends State<WorkoutInfoCard> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(20, 0, 20, 0);
  double maxValue;
  @override
  Widget build(BuildContext context) {
    maxValue = widget.max;
    double width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: paddingValues,
            child: AutoSizeText(widget.title,
                textAlign: TextAlign.start,
                style: StyleRefer.kTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w500)),
          ),
          Container(
            width: width,
            child: SliderTheme(
              data: StyleRefer.kSliderDecoration,
              child: Slider(
                min: 0.0,
                max: widget.max,
                label: widget.slideValue.round().toString(),
                value: widget.slideValue,
                onChanged: widget.onChanged,
              ),
            ),
          ),
          Container(
            padding: paddingValues,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText('Range 0-' + maxValue.round().toString(),
                    textAlign: TextAlign.start,
                    style: StyleRefer.kTextStyle
                        .copyWith(fontSize: 12, fontWeight: FontWeight.w400, color: ColorRefer.kGreyColor)),
                AutoSizeText(widget.slideValue.round().toString(),
                    textAlign: TextAlign.start,
                    style: StyleRefer.kTextStyle
                        .copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: ColorRefer.kGreyColor))
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShowWorkoutInfoCard extends StatefulWidget {
  ShowWorkoutInfoCard({this.title, this.value});
  final String title;
  final String value;
  @override
  _ShowWorkoutInfoCardState createState() => _ShowWorkoutInfoCardState();
}

class _ShowWorkoutInfoCardState extends State<ShowWorkoutInfoCard> {
  EdgeInsets paddingValues = EdgeInsets.fromLTRB(40, 0, 20, 0);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 15),
              Icon(
                FontAwesomeIcons.solidCheckCircle,
                color: ColorRefer.kOrangeColor,
                size: 15,
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    child: AutoSizeText(widget.title,
                        textAlign: TextAlign.start,
                        style: StyleRefer.kTextStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w800)),
                  ),
                  SizedBox(height: 10),
                  AutoSizeText(widget.value == 'null' ? '0' : widget.value,
                      textAlign: TextAlign.start,
                      style: StyleRefer.kTextStyle
                          .copyWith(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.blueAccent)),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Container(padding: paddingValues, child: Divider())
        ],
      ),
    );
  }
}
