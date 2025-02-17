import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:email_launcher/email_launcher.dart';
import '../auth/select_gender.dart';
import '../auth/signin_screen.dart';
import '../functions/global_functions.dart';
import '../controllers/auth_controller.dart';
import '../services/firebase_analytics.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';
import '../utils/fonts.dart';
import '../utils/style.dart';
import '../widgets/dialogs.dart';
import '../widgets//ImagePicker.dart';
import 'term_condition.dart';
import 'privacy_policy_screen.dart';
import 'learn_more_screen.dart';

FirebaseAuth _auth = FirebaseAuth.instance;

class ProfileScreen extends StatefulWidget {
  static String profileSCREEN = "/profile_screen";

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File image;
  bool _isLoading = false;
  final picker = ImagePicker();

  void initState() {
    print(AuthController.currentUser.profileImageUrl);
    super.initState();
  }

  Future<void> _launchEmail() async {
    Email email = Email(to: ['chris@fasterworkouts.com']);
    await EmailLauncher.launch(email);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          // elevation: 0,
          title: Text(
            'Profile',
            style: StyleRefer.kTextStyle.copyWith(fontSize: 18),
          ),
          leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: Icon(Platform.isIOS ? Icons.arrow_back_ios_sharp : Icons.arrow_back_rounded)),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(height: 25),
                InkWell(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            color: Color(0xFF737373),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).canvasColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                              ),
                              child: CameraGalleryBottomSheet(
                                cameraClick: () => pickImage(ImageSource.camera),
                                galleryClick: () => pickImage(ImageSource.gallery),
                              ),
                            ),
                          );
                        });
                  },
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: image != null
                            ? Image.file(
                                image,
                                width: 95,
                                height: 95,
                                fit: BoxFit.cover,
                              )
                            : AuthController.currentUser.profileImageUrl != null
                                ? Image.network(
                                    AuthController.currentUser.profileImageUrl,
                                    width: 95,
                                    height: 95,
                                    fit: BoxFit.cover,
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/person.svg',
                                    width: 95,
                                    height: 95,
                                    fit: BoxFit.fill,
                                  ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 65, top: 60),
                        child: Material(
                          // color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          elevation: 3,
                          child: Container(
                            alignment: Alignment.center,
                            width: 30,
                            height: 30,
                            child: SvgPicture.asset(
                              'assets/icons/cameraFill.svg',
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                SettingTabs(
                  icon: 'assets/icons/personal_info.svg',
                  title: 'Update Profile',
                  onTap: () {
                    Constants.update = true;
                    Navigator.pushNamed(context, SelectGender.ID);
                  },
                ),
                SizedBox(height: 10),
                SettingTabs(
                  icon: 'assets/icons/about.svg',
                  title: 'How To?',
                  onTap: () {
                    String videoID = getData('https://vimeo.com/566042837');
                    Navigator.pushNamed(context, LearnMoreScreen.learnMoreScreenID, arguments: videoID);
                  },
                ),
                SizedBox(height: 10),
                SettingTabs(
                  icon: 'assets/icons/contact.svg',
                  title: 'Contact Us',
                  onTap: () async{
                   await  _launchEmail();
                  },
                ),
                SizedBox(height: 10),
                SettingTabs(
                  icon: 'assets/icons/privacy_policy.svg',
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.pushNamed(context, PrivacyPolicyScreen.privacyPolicyID);
                  },
                ),
                SizedBox(height: 10),
                SettingTabs(
                  icon: 'assets/icons/term_condition.svg',
                  title: 'Terms and Conditions',
                  onTap: () {
                    Navigator.pushNamed(context, TermConditionScreen.termConditionID);
                  },
                ),
                // SizedBox(height: 10),
                // SettingTabs(
                //   icon: 'assets/icons/rate_us.svg',
                //   title: 'Rate Us',
                //   onTap: (){},
                // ),
                SizedBox(height: 10),
                SettingTabs(
                  icon: 'assets/icons/logout.svg',
                  title: 'Logout',
                  onTap: () {
                    AppDialog().showOSDialog(
                        context, "Logout", "Are you sure you want to logout now?", "Logout", () {
                      clearData();
                      _auth.signOut();
                      FirebaseAnalyticsService.logEvent("logout");
                      Navigator.pushNamedAndRemoveUntil(
                          context, SignInScreen.signInScreenID, (route) => false);
                    }, secondButtonText: "Cancel", secondCallback: () {});
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pickImage(ImageSource imageSource) async {
    PickedFile galleryImage = await picker.getImage(source: imageSource, imageQuality: 40);
    setState(() {
      image = File(galleryImage.path);
    });
    setState(() {
      _isLoading = true;
    });
    await AuthController().updateUserImages(image);
    setState(() {
      _isLoading = false;
    });
  }
}

class SettingTabs extends StatefulWidget {
  SettingTabs({this.title, this.onTap, this.icon});
  final String icon;
  final String title;
  final Function onTap;
  @override
  _SettingTabsState createState() => _SettingTabsState();
}

class _SettingTabsState extends State<SettingTabs> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        color: theme.brightness == Brightness.light ? ColorRefer.kBackgroundColor : Colors.white10,
        child: Container(
          width: width,
          height: 60,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 15),
          child: Row(
            children: [
              SvgPicture.asset(
                widget.icon,
                width: 20,
                height: 20,
                color: ColorRefer.kOrangeColor,
              ),
              SizedBox(width: 15),
              AutoSizeText(
                widget.title,
                style: TextStyle(fontSize: 14, fontFamily: FontRefer.OpenSans, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
