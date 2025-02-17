import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../auth/select_gender.dart';
import '../functions/global_functions.dart';
import '../services/firebase_analytics.dart';
import '../utils/strings.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/dialogs.dart';
import '../auth/signin_screen.dart';
import '../shared_preferences/shared_preferences.dart';
import '../screens/intro_screen.dart';
import '../auth/select_date_screen.dart';
import '../screens/main_screen.dart';
import '../auth/chose_weight_screen.dart';
import '../models/user_model.dart';

class AuthController {
  static final facebookAppEvents = FacebookAppEvents();
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  static UserModel currentUser;

  //****************** Create User ******************

  Future<bool> signupWithCredentials(BuildContext context, File file, String password) async {
    try {
      UserCredential userCredential =
          await this._auth.createUserWithEmailAndPassword(email: currentUser.email, password: password);
      userCredential.user.sendEmailVerification();
      currentUser.uid = userCredential.user.uid;
      currentUser.createdAt = Timestamp.now();
      if (currentUser.workoutDate == null) {
        currentUser.workoutDate = Timestamp.now();
        currentUser.workoutWeeks = 0;
      }
      if (file != null) currentUser.profileImageUrl = await _uploadProfileImage(file);
      await _firestore.doc(FirebaseRef.USERS + "/" + currentUser.uid).set(currentUser.toMap());
      FirebaseAnalyticsService.logEvent('sign_up');
      return true;
    } on FirebaseException catch (e) {
      switch (e.code) {
        case FirebaseRef.EMAIL_ALREADY_EXISTS:
          AppDialog().showOSDialog(context, "Error", "Email already exists", "Ok", () {});
          break;
        case FirebaseRef.NO_CONNECTION:
          AppDialog().showOSDialog(context, "Error", StringRefer.kNoConnection, "Ok", () {});
          break;
      }
      print("Sign up Error: ${e.code}");
      return false;
    }
  }

  //****************** Login User ******************

  Future<void> loginWithCredentials(BuildContext context, String email, String password) async {
    try {
      UserCredential userCredential =
          await this._auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseAnalyticsService.logEvent('login_with_credentials');
      if (!userCredential.user.emailVerified) {
        AppDialog().showOSDialog(context, "Invalid",
            "Your email not verified yet, please verify your email and try again.", "Ok", () {});
      } else {
        await checkUserExists(context, uid: userCredential.user.uid, loginWithCredential: true);
      }
    } on FirebaseException catch (e) {
      switch (e.code) {
        case FirebaseRef.WRONG_PASSWORD:
          AppDialog().showOSDialog(context, "Error", "Invalid password", "Ok", () {});
          break;
        case FirebaseRef.USER_NOT_EXISTS:
          AppDialog().showOSDialog(context, "Error", "User not found", "Ok", () {});
          break;
        case FirebaseRef.NO_CONNECTION:
          AppDialog().showOSDialog(context, "Error", StringRefer.kNoConnection, "Ok", () {});
          break;
      }
      print("Login Error: ${e.code}");
      return;
    }
  }

  //****************** Login with Google ******************

  Future<void> loginWithGoogle(
    BuildContext context,
  ) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await this._auth.signInWithCredential(credential);
      final User user = authResult.user;

      if (user != null) {
        FirebaseAnalyticsService.logEvent('login_with_google');
        await checkUserExists(context, uid: user.uid);
      }
    } catch (e) {
      print("Google Login Error: $e");
    }
  }

  //****************** Login with Apple ******************

  Future<void> signInWithApple(BuildContext context) async {
    try {
      final AppleSignInAvailable appleSignInAvailable = await AppleSignInAvailable.check();
      if (!appleSignInAvailable.isAvailable) {
        AppDialog().showOSDialog(context, "Error", "Apple Sign in not available", "Ok", () {});
        return;
      }
      final String _appleProvider = "apple.com";
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request credential for the currently signed in Apple account.
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an `OAuthCredential` from the credential returned by Apple.
      final oauthCredential = OAuthProvider(_appleProvider).credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      // Sign in the user with Firebase. If the nonce we generated earlier does
      // not match the nonce in `appleCredential.identityToken`, sign in will fail.
      final authResult = await this._auth.signInWithCredential(oauthCredential);
      final firebaseUser = authResult.user;
      if (firebaseUser != null) {
        FirebaseAnalyticsService.logEvent('login_with_apple');
        await checkUserExists(context, uid: firebaseUser.uid);
      }
    } on SignInWithAppleException catch (e) {
      print("Apple Login Error: $e");
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: $e");
    }
  }

  String _generateNonce([int length = 32]) {
    final charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  //****************** Upload Profile Image ******************

  Future<String> _uploadProfileImage(File file) async {
    try {
      await _firebaseStorage.ref(FirebaseRef.PROFILE_IMAGE + "/" + currentUser.uid).putFile(file);
      final downloadURL =
          await _firebaseStorage.ref(FirebaseRef.PROFILE_IMAGE + "/" + currentUser.uid).getDownloadURL();
      return downloadURL;
    } on FirebaseException catch (e) {
      print("File upload Error: $e");

      return null;
    }
  }

  //****************** Check User Exists ******************

  Future<void> checkUserExists(BuildContext context, {String uid, bool loginWithCredential = false}) async {
    User currentAuthUser = this._auth.currentUser;
    print("Current User: ${this._auth.currentUser}");
    if (currentAuthUser == null || currentAuthUser.emailVerified == false) {
      bool areOnBoardingScreensVisited = LocalPreferences.preferences.getBool(LocalPreferences.OnBoardingScreensVisited);
      Future.delayed(Duration(seconds: 1), () {
        Navigator.pushReplacementNamed(context, IntroScreens.introScreenID);
        Navigator.pushReplacementNamed(
            context,
            areOnBoardingScreensVisited != null && areOnBoardingScreensVisited
                ? SignInScreen.signInScreenID
                : IntroScreens.introScreenID);
      });
      return;
    }

    DocumentSnapshot snapshot =
        await _firestore.doc("${FirebaseRef.USERS}/${uid ?? currentAuthUser.uid}").get();
    if (!snapshot.exists) {
      if (!loginWithCredential) {
        currentUser = UserModel(
            name: currentAuthUser.displayName ?? "User",
            email: currentAuthUser.email,
            uid: currentAuthUser.uid);
        if (currentUser.workoutDate == null) {
          currentUser.workoutDate = Timestamp.now();
          currentUser.workoutWeeks = 0;
        }
        await _firestore.doc(FirebaseRef.USERS + '/' + currentUser.uid).set(currentUser.toMap());
        clearData();
        await getAppData();
        await getUserData();
        Navigator.pushReplacementNamed(context, SelectGender.ID);
      }
      return;
    }
    currentUser = UserModel.fromMap(snapshot.data());
    clearData();
    await getAppData();
    await getUserData();
    facebookAppEvents.setAdvertiserTracking(enabled: true);
    if (currentUser.gender == null) {
      Navigator.pushReplacementNamed(context, SelectGender.ID);
      return;
    }
    if (currentUser.dateOfBirth == null) {
      Navigator.pushReplacementNamed(context, SelectDateOfBirth.ID);
      return;
    }
    if (currentUser.weight == null) {
      Navigator.pushReplacementNamed(context, SelectWeightScreen.ID);
      return;
    }
    Navigator.pushReplacementNamed(context, MainScreen.MainScreenId);
  }

  //****************** Update User ******************

  Future<void> updateUserImages(File file) async {
    try {
      if (file != null) {
        currentUser.profileImageUrl = await _uploadProfileImage(file);

        await _firestore.doc(FirebaseRef.USERS + '/' + currentUser.uid).update(currentUser.toMap());
        FirebaseAnalyticsService.logEvent('profile_image_updated');
      }
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  Future<void> updateUserFields() async {
    print(" Update Current User: $currentUser}");
    try {
      await _firestore.doc(FirebaseRef.USERS + '/' + currentUser.uid).update(currentUser.toMap());
      FirebaseAnalyticsService.logEvent('user_data_updated');
    } on FirebaseException catch (e) {
      print("User update Error: $e");
    }
  }

  static Future<void> getUserInfo(String uid) async {
    try {
      DocumentSnapshot snapShot = await _firestore.collection('users').doc(uid).get();
      if (snapShot.data() != null) {
        currentUser = UserModel.fromMap(snapShot.data());
      }
      return;
    } on SocketException catch (error) {
      print("$error");
    } on FirebaseException catch (error) {
      print("$error");
    }
  }

//****************** Password Reset ******************

  Future<void> sendPasswordResetEmail(BuildContext context, String email) async {
    try {
      await this._auth.sendPasswordResetEmail(email: email);
      FirebaseAnalyticsService.logEvent('password_reset_email_sent');
      AppDialog().showOSDialog(context, "Success", "Password reset email sent successfully", "Ok", () {
        Navigator.pushNamedAndRemoveUntil(context, SignInScreen.signInScreenID, (route) => false);
      });
    } on FirebaseException catch (e) {
      print("Password Reset Error: $e");
    }
  }
}

class FirebaseRef {
  static const String USERS = "users";
  static const String PROFILE_IMAGE = "profile_image";
  static const String WRONG_PASSWORD = "wrong-password";
  static const String USER_NOT_EXISTS = "user-not-found";
  static const String EMAIL_ALREADY_EXISTS = "email-already-in-use";
  static const String NO_CONNECTION = "network-request-failed";
}

class AppleSignInAvailable {
  AppleSignInAvailable(this.isAvailable);
  final bool isAvailable;

  static Future<AppleSignInAvailable> check() async {
    return AppleSignInAvailable(await SignInWithApple.isAvailable());
  }
}
