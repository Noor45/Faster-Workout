import 'dart:io';

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'forget_password_screen.dart';
import 'signup_screen.dart';
import '../controllers/auth_controller.dart';
import '../cards/signin_screen_card.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../widgets/input_field.dart';
import '../widgets/round_button.dart';

class SignInScreen extends StatefulWidget {
  static String signInScreenID = "/sign_in_screen";
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  bool _isLoading = false;
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
          title: Text(
            'Login',
            style: TextStyle(fontFamily: FontRefer.OpenSans),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                  Center(
                    child: AutoSizeText(
                      'Welcome Back!',
                      style: TextStyle(fontSize: 25, fontFamily: FontRefer.OpenSans),
                    ),
                  ),
                  SizedBox(height: 40),
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
                      if (password.isEmpty) return "Password is required!";
                    },
                    onChanged: (value) => _password = value,
                  ),
                  SizedBox(height: 30),
                  RoundedButton(
                      title: 'Login',
                      buttonRadius: 5,
                      colour: ColorRefer.kOrangeColor,
                      height: 48,
                      onPressed: () async {
                        if (!formKey.currentState.validate()) return;
                        formKey.currentState.save();
                        setState(() {
                          _isLoading = true;
                        });
                        await AuthController().loginWithCredentials(context, _email, _password);
                        setState(() {
                          _isLoading = false;
                        });
                      }),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, ForgetPasswordScreen.ID),
                    child: Center(
                      child: AutoSizeText(
                        'Forgot Password?',
                        style: TextStyle(
                            fontSize: 13, fontFamily: FontRefer.OpenSans, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Center(
                    child: Text(
                      "or login with",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: FontRefer.OpenSans,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: Platform.isIOS ? true : false,
                        child: SocialMediaIcons(
                            color: Colors.black,
                            icon: 'assets/icons/apple.svg',
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await AuthController().signInWithApple(context);
                              setState(() {
                                _isLoading = false;
                              });
                            }),
                      ),
                      Visibility(
                          visible: Platform.isIOS == true ? true : false,
                          child: SizedBox(width: 20)
                      ),
                      SocialMediaIcons(
                          color: Colors.redAccent,
                          icon: 'assets/icons/google.svg',
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });
                            await AuthController().loginWithGoogle(context);
                            setState(() {
                              _isLoading = false;
                            });
                          }),
                    ],
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: FontRefer.OpenSans,
                          color: Colors.grey,
                        ),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, SignUpScreen.signUpScreenID);
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: FontRefer.OpenSans,
                                color: ColorRefer.kOrangeColor,
                                fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
