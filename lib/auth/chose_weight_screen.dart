import 'package:auto_size_text/auto_size_text.dart';
import 'package:faster_workouts/auth/signin_screen.dart';
import 'package:faster_workouts/controllers/auth_controller.dart';
import 'package:faster_workouts/screens/main_screen.dart';
import 'package:faster_workouts/widgets/input_field.dart';
import 'package:toast/toast.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/round_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectWeightScreen extends StatefulWidget {
  static const String ID = "/select_weight_screen";
  @override
  _SelectWeightScreenState createState() => _SelectWeightScreenState();
}

class _SelectWeightScreenState extends State<SelectWeightScreen> {

  TextEditingController controller = TextEditingController();
  String gender;
  double _weight = 0;
  int slideIndex = 2;
  final formKey = GlobalKey<FormState>();
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
      if(AuthController.currentUser.weight != 0.0){
        controller.text = AuthController.currentUser.weight.toString();
        _weight = AuthController.currentUser.weight;
      }
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.light ?  Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
            child: Form(
              key: formKey,
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
                        children: [
                          AutoSizeText(
                            'Step 4',
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
                      'What is your body weight in pounds?',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: FontRefer.OpenSans,
                          fontWeight: FontWeight.w900),
                    ),
                      SizedBox(height: 20),
                        InputField(
                          label: 'Enter your weight (lbs)',
                          controller: controller,
                          validator: (String weight) {
                            print(_weight);
                            if (weight.isEmpty) return "Weight is required!";
                            if (weight == '') return "Weight is required!";
                            if(_weight<70.0 || _weight>500.0) return "Please enter a number between 70 and 500";
                          },
                          onChanged: (value){
                            setState(() {
                              if(value != '')
                                _weight = double.parse(value);
                              print(_weight);
                            });
                          },
                          textInputType: TextInputType.numberWithOptions(decimal: true),
                      ),
                      SizedBox(height: 30),
                      ButtonWithIcon(
                          title: 'Done',
                          buttonRadius: 5,
                          colour: _weight == 0
                              ? ColorRefer.kOrangeColor.withOpacity(0.5)
                              : ColorRefer.kOrangeColor,
                          height: 40,
                          onPressed: _weight == 0
                              ? null
                              : () {
                                  if (!formKey.currentState.validate()) return;
                                    formKey.currentState.save();
                                  AuthController.currentUser.weight =
                                      double.parse(_weight.toStringAsFixed(1));
                                  AuthController().updateUserFields();
                                  if(Constants.update == true){
                                    Toast.show("Updated", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
                                    Navigator.pop(context);
                                  }else{
                                    Navigator.pushReplacementNamed(
                                        context, MainScreen.MainScreenId);
                                  }

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
              ),
            )
        ),
      ),
    );
  }
}


