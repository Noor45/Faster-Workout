import '../models/user_exercise_data.dart';
import '../models/user_model.dart';
import '../models/video_model.dart';
import '../models/workout_video_model.dart';

int transitionDelay = 300;
Function kEmailValidator = (emailValue) {
  if (emailValue.isEmpty) {
    return 'Email is required';
  }
  String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+";
  RegExp regExp = new RegExp(p);
  if (regExp.hasMatch(emailValue)) {
    return null;
  } else {
    return 'Email Syntax is not Correct';
  }
};

enum Workouts { FastestWorkout, FasterWorkout }

class Constants {
  static int videoLimit = 10;
  static int moreVideoLimit = 10;
  static int historyLimit = 10;
  static String email = '';
  static bool allow = false;
  static Workouts workoutType;
  static UserModel currentUser;
  static List fastestWorkoutValues = List.filled(6, 0);
  // static List fasterWorkoutValues = List.filled(6, 0);
  static List<ExerciseModel> userExerciseData = [];
  static List<ExerciseModel> userExerciseGraphData = [];
  static List<WorkoutVideoModel> workoutVideos = [];
  static String mainVideoLink = '';
  static List<VideoModel> videosList = [];
  static List<VideoModel> moreVideoList = [];
  static List<UserModel> userList = [];
  static String selectedVideoID = '';
  static int selectedIndex = 0;
  static String selectedVideoTitle = '';
  static String selectedVideoSubtitle = '';
  static String selectedVideoLink = '';
  static bool update = false;
  static List historyWorkoutValues = List.filled(6, 0);
  static String selectedGraphExercise = 'Fastest Workout';
}

class WeeklyData {
  static List<ExerciseModel> sevenDaysRecord = [];

  static List<double> fastestWorkoutBagRecord = List.filled(7, 0);
  static List<double> fastestWorkoutBagPackRecord = List.filled(7, 0);

  static List<double> fasterWorkoutBagRecord = List.filled(7, 0);
  static List<double> fasterWorkoutBagPackRecord = List.filled(7, 0);
}

class MonthlyData {
  static List<ExerciseModel> monthlyRecord = [];

  static List<double> fastestWorkoutBagRecord = List.filled(5, 0);
  static List<double> fastestWorkoutBagPackRecord = List.filled(5, 0);

  static List<double> fasterWorkoutBagRecord = List.filled(5, 0);
  static List<double> fasterWorkoutBagPackRecord = List.filled(5, 0);
}

class ThreeMonthsData {
  static List<ExerciseModel> threeMonthsRecord = [];

  static List<double> fastestWorkoutBagRecord = List.filled(5, 0);
  static List<double> fastestWorkoutBagPackRecord = List.filled(5, 0);

  static List<double> fasterWorkoutBagRecord = List.filled(5, 0);
  static List<double> fasterWorkoutBagPackRecord = List.filled(5, 0);
}

class FastestWorkout {
  static int bicepReps = 0;
  static int bicepWt = 0;
  static int pushUpReps = 0;
  static int pushUpWt = 0;
  static int kettleReps = 0;
  static int kettleLbs = 0;
  // static int rowsReps = 0;
  // static int rowsWt = 0;
  // static int pushUpReps = 0;
  // static int pushUpWt = 0;
  static String video = '';
  static String title = '';
  static String audio = '';

}

class FasterWorkout {
  static int bicepReps = 0;
  static int bicepWt = 0;
  static int pushUpReps = 0;
  static int pushUpWt = 0;
  static int kettleReps = 0;
  static int kettleLbs = 0;
  static String video = '';
  static String title = '';
  static String audio = '';
}
