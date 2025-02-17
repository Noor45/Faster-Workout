import 'package:flutter/material.dart';
import '../utils/colors.dart';
import '../utils/style.dart';

class VideoTab extends StatefulWidget {
  VideoTab({this.onPressed, this.videoLink, this.title, this.thumbnail, this.subtitle});
  final String videoLink;
  final String title;
  final String thumbnail;
  final String subtitle;
  final Function onPressed;
  @override
  _VideoTabState createState() => _VideoTabState();
}

class _VideoTabState extends State<VideoTab> {
  String subTitle = '';
  @override
  void initState() {
    if (widget.subtitle.length > 50) {
      subTitle = widget.subtitle.substring(0, 50) + '...';
    } else {
      subTitle = widget.subtitle;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: widget.onPressed,
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: width / 4.3,
                  width: width / 2.7,
                  color: ColorRefer.kGreyColor,
                  child: widget.thumbnail.contains('assets/images/') == true  ?
                  Image.asset(
                    widget.thumbnail,
                    fit: BoxFit.fill,
                  ) : FadeInImage.assetNetwork(
                    placeholder: 'assets/images/image_placeholder.jpg',
                    image: widget.thumbnail,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: width / 1.9,
                      child: Text(
                        widget.title,
                        softWrap: true,
                        style: StyleRefer.kTextStyle.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    SizedBox(height: 2),
                    Container(
                      width: width / 2,
                      child: Text(
                        subTitle,
                        style: StyleRefer.kTextStyle.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
