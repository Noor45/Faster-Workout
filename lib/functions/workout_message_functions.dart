import '../utils/constants.dart';
import '../utils/strings.dart';

// class FastestWorkoutMessageFunction {
//   static String messageOne() {
//     String message1;
//     if (FastestWorkout.rowsReps < 6)
//       message1 = FastestWorkoutMessage.rows_reps_message1;
//     else if (FastestWorkout.rowsReps > 5 && FastestWorkout.rowsReps < 10)
//       message1 = FastestWorkoutMessage.rows_reps_message2;
//     else if (FastestWorkout.rowsReps > 9) message1 = FastestWorkoutMessage.rows_reps_message3;
//     return message1;
//   }
//
//   static String messageTwo() {
//     String message2;
//     if (FastestWorkout.pushUpReps < 6)
//       message2 = FastestWorkoutMessage.pushup_reps_message1;
//     else if (FastestWorkout.pushUpReps > 5 && FastestWorkout.pushUpReps < 10)
//       message2 = FastestWorkoutMessage.pushup_reps_message2;
//     else if (FastestWorkout.pushUpReps > 9) message2 = FastestWorkoutMessage.pushup_reps_message3;
//     return message2;
//   }
// }

class FastestWorkoutMessageFunction {
  static String messageOne() {
    String message1;
    if (FasterWorkout.bicepReps < 6)
      message1 = FastestWorkoutMessage.bicep_reps_message1;
    else if (FasterWorkout.bicepReps > 5 && FasterWorkout.bicepReps < 10)
      message1 = FastestWorkoutMessage.bicep_reps_message2;
    else if (FasterWorkout.bicepReps > 9) message1 = FastestWorkoutMessage.bicep_reps_message3;
    return message1;
  }

  static String messageTwo() {
    String message2;
    if (FasterWorkout.pushUpReps < 6)
      message2 = FastestWorkoutMessage.pushup_reps_message1;
    else if (FasterWorkout.pushUpReps > 5 && FasterWorkout.pushUpReps < 10)
      message2 = FastestWorkoutMessage.pushup_reps_message2;
    else if (FasterWorkout.pushUpReps > 9) message2 = FastestWorkoutMessage.pushup_reps_message3;
    return message2;
  }

  static String messageThree() {
    String message3;
    if (FasterWorkout.kettleReps < 13)
      message3 = FastestWorkoutMessage.kettle_reps_message1;
    else if (FasterWorkout.kettleReps > 12 && FasterWorkout.kettleReps < 20)
      message3 = FastestWorkoutMessage.kettle_reps_message2;
    else if (FasterWorkout.kettleReps > 19) message3 = FastestWorkoutMessage.kettle_reps_message3;
    return message3;
  }
}

class Message {
  static clear() {
    FastestWorkout.bicepReps = 0;
    FastestWorkout.bicepWt = 0;
    FastestWorkout.pushUpReps = 0;
    FastestWorkout.pushUpWt = 0;

    FasterWorkout.bicepReps = 0;
    FasterWorkout.bicepWt = 0;
    FasterWorkout.pushUpReps = 0;
    FasterWorkout.pushUpWt = 0;
  }
}
