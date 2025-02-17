import 'package:auto_size_text/auto_size_text.dart';
import 'package:faster_workouts/auth/select_date_screen.dart';
import 'package:faster_workouts/controllers/auth_controller.dart';
import 'package:faster_workouts/utils/colors.dart';
import 'package:faster_workouts/utils/constants.dart';
import 'package:faster_workouts/utils/fonts.dart';
import 'package:faster_workouts/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectGender extends StatefulWidget {
  static const String ID = "/select_gender_screen";
  @override
  _SelectGenderState createState() => _SelectGenderState();
}

class _SelectGenderState extends State<SelectGender> {
  int gender;
  int slideIndex = 0;
  Color femaleBoxColor = ColorRefer.kLightColor;
  Color maleBoxColor = ColorRefer.kLightColor;
  Color otherBoxColor = ColorRefer.kLightColor;
  Widget _buildPageIndicator(bool isCurrentPage, bool dark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: isCurrentPage ? 8.0 : 8.0,
      width: isCurrentPage ? 8.0 : 8.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCurrentPage ? dark == true ? Colors.white : Colors.black : dark == true ? Colors.white.withOpacity(0.3) : Colors.black.withOpacity(0.3),
      ),
    );
  }

  @override
  void initState() {
    if(Constants.update == true){
      if(AuthController.currentUser.gender != null)
        gender = AuthController.currentUser.gender;
      if(gender == 0)
        femaleBox();
      else if(gender == 1)
        maleBox();
      else if(gender == 2)
        otherBox();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final ThemeData theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light ?  Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
            child: Container(
            width: width,
            height: height,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: Constants.update == true ? false : true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoSizeText(
                        'Step 2',
                        style: TextStyle(
                          color: ColorRefer.kGreyColor,
                          fontSize: 15,
                          fontFamily: FontRefer.OpenSans,
                        ),
                      ),
                      SizedBox(height: 20),
                      AutoSizeText(
                        'Please tell us a little bit about yourself, so we can customized the experience to you.',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: FontRefer.OpenSans,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),

                AutoSizeText(
                  'What is your gender?',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: FontRefer.OpenSans,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        femaleBox();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: width / 3.6,
                            height: height / 7.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: femaleBoxColor,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: SvgPicture.asset('assets/icons/female.svg', height: 70, width: 70,),
                          ),
                          SizedBox(height: 6),
                          AutoSizeText('Female'),
                        ],
                      ),
                    ),
                    SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        maleBox();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: width / 3.6,
                            height: height / 7.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: maleBoxColor,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: SvgPicture.asset('assets/icons/male.svg', height: 70, width: 70,),
                          ),
                          SizedBox(height: 6),
                          AutoSizeText('Male'),
                        ],
                      ),
                    ),
                    SizedBox(width: 6),
                    InkWell(
                      onTap: () {
                        otherBox();
                      },
                      child: Column(
                        children: [
                          Container(
                            width: width / 3.6,
                            height: height / 7.5,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: otherBoxColor,
                              borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: SvgPicture.asset('assets/icons/other.svg', height: 70, width: 70,),
                          ),
                          SizedBox(height: 6),
                          AutoSizeText('Other'),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                ButtonWithIcon(
                    title: 'Next',
                    buttonRadius: 5,
                    colour: gender == null
                        ? ColorRefer.kOrangeColor.withOpacity(0.5)
                        : ColorRefer.kOrangeColor,
                    height: 40,
                    onPressed: gender == null
                        ? gender
                        : () {
                            AuthController.currentUser.gender = gender;
                            AuthController().updateUserFields();
                            Navigator.pushReplacementNamed(
                                context, SelectDateOfBirth.ID);
                          }),
                SizedBox(height: 30),
                Container(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        i == slideIndex
                            ? _buildPageIndicator(true, theme.brightness == Brightness.light ? false : true)
                            : _buildPageIndicator(false, theme.brightness == Brightness.light ? false : true),
                    ],
                  ),
                ),
              ],
            ),
        )),
      ),
    );
  }
  femaleBox(){
    setState(() {
      gender = 0;
      femaleBoxColor = ColorRefer.kOrangeColor.withOpacity(0.6);
      maleBoxColor = ColorRefer.kLightColor;
      otherBoxColor = ColorRefer.kLightColor;
    });
  }
  maleBox(){
    setState(() {
      gender = 1;
      maleBoxColor = ColorRefer.kOrangeColor.withOpacity(0.6);
      femaleBoxColor = ColorRefer.kLightColor;
      otherBoxColor = ColorRefer.kLightColor;
    });
  }
  otherBox(){
    setState(() {
      gender = 2;
      otherBoxColor = ColorRefer.kOrangeColor.withOpacity(0.6);
      femaleBoxColor = ColorRefer.kLightColor;
      maleBoxColor = ColorRefer.kLightColor;
    });
  }
}
