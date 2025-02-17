import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../auth/select_gender.dart';
import '../models/user_model.dart';
import '../controllers/auth_controller.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/term_condition.dart';
import '../shared_preferences/shared_preferences.dart';
import '../widgets/dialogs.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/ImagePicker.dart';
import '../widgets/input_field.dart';
import '../widgets/round_button.dart';
import '../utils/style.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  static String signUpScreenID = "/sign_up_screen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  Color borderColor = Colors.transparent;
  bool _checkedValue = false;
  File _image;
  String _name;
  String _email;
  String _password;
  bool _isLoading = false;

  void _pickImage(ImageSource imageSource) async {
    PickedFile galleryImage = await _picker.getImage(source: imageSource, imageQuality: 40);
    setState(() {
      _image = File(galleryImage.path);
    });
  }

  Future<void> _signup() async {
    if (!formKey.currentState.validate()) return;
    setState(() {
      _isLoading = true;
    });
    formKey.currentState.save();
    AuthController.currentUser = UserModel(email: _email, name: _name);
    bool success = await AuthController().signupWithCredentials(context, _image, _password);
    if (success) {
      // await getAppData();
      // await getUserData();

      AppDialog().showOSDialog(
          context, "Verification", "Verification email has been sent to your email address", "Ok", () {
            Navigator.pop(context);

        // LocalPreferences.preferences.setString(LocalPreferences.LOGGED_IN, AuthController.currentUser.uid);
        // Navigator.pushNamed(context, SelectGender.ID);
      });
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: CircularProgressIndicator(
        backgroundColor: ColorRefer.kOrangeColor,
      ),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded)),
          title: Text(
            'Sign Up',
            style: TextStyle(fontFamily: FontRefer.OpenSans),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40),
                      AutoSizeText(
                        'Getting Started: Step 1 of 4',
                        style: TextStyle(
                          color: ColorRefer.kGreyColor,
                          fontSize: 15,
                          fontFamily: FontRefer.OpenSans,
                        ),
                      ),
                      SizedBox(height: 40),
                      Center(
                        child: InkWell(
                          onTap: () {
                            showImageDialogBox();
                          },
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                  height: 75,
                                  width: 75,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle, border: Border.all(color: borderColor)),
                                  child: _image != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(65),
                                          child: Image.file(
                                            _image,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : SvgPicture.asset('assets/icons/person.svg')),
                              Positioned(
                                  left: 65, top: 25, child: SvgPicture.asset('assets/icons/camera.svg'))
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      InputField(
                        textInputType: TextInputType.name,
                        label: 'Name',
                        validator: (String firstName) {
                          if (firstName.isEmpty) return "Name is required";
                          if (firstName.length < 3) return "Minimum three characters required";
                        },
                        onChanged: (value) => _name = value,
                      ),
                      SizedBox(height: 15),
                      InputField(
                        textInputType: TextInputType.emailAddress,
                        label: 'Email',
                        validator: kEmailValidator,
                        onChanged: (value) => _email = value,
                      ),
                      SizedBox(height: 15),
                      PasswordField(
                        label: 'Password',
                        textInputType: TextInputType.text,
                        obscureText: true,
                        validator: (String password) {
                          if (password.isEmpty) return "Password is required";
                          if (password.length < 6) return "Minimum 6 characters are required";
                        },
                        onChanged: (value) => _password = value,
                      ),
                      SizedBox(height: 15),
                      PasswordField(
                        label: 'Confirm Password',
                        textInputType: TextInputType.text,
                        obscureText: true,
                        validator: (String confirmPassword) {
                          if (confirmPassword.isEmpty || confirmPassword != _password)
                            return "Password does not match";
                        },
                        onChanged: (value) {},
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 25),
                  child: Row(
                    children: [
                      Container(
                        child: Checkbox(
                          value: _checkedValue,
                          activeColor: ColorRefer.kOrangeColor,
                          onChanged: (bool value) {
                            setState(() {
                              _checkedValue = value;
                            });
                          },
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'I agree to the ',
                                style: StyleRefer.kCheckBoxTextStyle
                                    .copyWith(color: ColorRefer.kGreyColor, fontSize: 13)),
                            TextSpan(
                                text: 'Terms of Services',
                                style: StyleRefer.kCheckBoxTextStyle
                                    .copyWith(color: ColorRefer.kOrangeColor, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, TermConditionScreen.termConditionID);
                                  }),
                            TextSpan(
                                text: ' & ',
                                style: StyleRefer.kCheckBoxTextStyle.copyWith(color: ColorRefer.kGreyColor)),
                            TextSpan(
                                text: 'Privacy Policy',
                                style: StyleRefer.kCheckBoxTextStyle
                                    .copyWith(color: ColorRefer.kOrangeColor, fontWeight: FontWeight.bold),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(context, PrivacyPolicyScreen.privacyPolicyID);
                                  }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      ButtonWithIcon(
                          title: 'Sign Up',
                          buttonRadius: 5,
                          colour: _checkedValue
                              ? ColorRefer.kOrangeColor
                              : ColorRefer.kOrangeColor.withOpacity(0.5),
                          height: 40,
                          onPressed: _checkedValue ? () => _signup() : null),
                      SizedBox(height: 22),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: FontRefer.OpenSans,
                              color: Colors.grey,
                            ),
                          ),
                          InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, SignInScreen.signInScreenID);
                              },
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: FontRefer.OpenSans,
                                    color: ColorRefer.kOrangeColor,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showImageDialogBox() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0xFF737373),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
              child: CameraGalleryBottomSheet(
                cameraClick: () => _pickImage(ImageSource.camera),
                galleryClick: () => _pickImage(ImageSource.gallery),
              ),
            ),
          );
        });
  }
}
