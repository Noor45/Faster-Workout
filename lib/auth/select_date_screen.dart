import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faster_workouts/auth/chose_weight_screen.dart';
import 'package:faster_workouts/controllers/auth_controller.dart';
import 'package:faster_workouts/utils/colors.dart';
import 'package:faster_workouts/utils/constants.dart';
import 'package:faster_workouts/utils/fonts.dart';
import 'package:faster_workouts/widgets/input_field.dart';
import 'package:faster_workouts/widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectDateOfBirth extends StatefulWidget {
  static const String ID = "/select_date_of_birth_screen";
  @override
  _SelectDateOfBirthState createState() => _SelectDateOfBirthState();
}

class _SelectDateOfBirthState extends State<SelectDateOfBirth> {
  int slideIndex = 1;
  DateTime _dateTime;
  TextEditingController controller = TextEditingController();
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
      controller.text = AuthController.currentUser.dateOfBirth.toDate().toString();
      _dateTime = AuthController.currentUser.dateOfBirth.toDate();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light ?  Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
            child: Container(
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
                        'Step 3',
                        style: TextStyle(
                          color: ColorRefer.kGreyColor,
                          fontSize: 15,
                          fontFamily: FontRefer.OpenSans,
                        ),
                      ),
                      SizedBox(height: 20),

                    ],
                  ),
                ),
                AutoSizeText(
                  'What is your Date of Birth?',
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: FontRefer.OpenSans,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 20),
                SelectDateField(
                  controller: controller,
                  hint: 'Select Date of Birth',
                  onChanged: (value) {
                    _dateTime = DateTime.parse(value);
                    print("Date: $_dateTime");
                  },
                ),
                SizedBox(height: 30),
                ButtonWithIcon(
                    title: 'Next',
                    buttonRadius: 5,
                    colour: ColorRefer.kOrangeColor,
                    height: 40,
                    onPressed: () {
                      if (_dateTime == null) return;
                      AuthController.currentUser.dateOfBirth =
                          Timestamp.fromDate(_dateTime);
                      AuthController().updateUserFields();
                      Navigator.pushReplacementNamed(
                          context, SelectWeightScreen.ID);
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
}
