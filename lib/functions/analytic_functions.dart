import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import '../models/user_exercise_data.dart';
import '../utils/constants.dart';

class AnalyticsFunction {
  static String formatWeekDays(DateTime date) {
    final df = new DateFormat('EE');
    return df.format(date);
  }

  static String formatMonth(DateTime date) {
    final df = new DateFormat('MMMM');
    return df.format(date);
  }

  static String formatDate(DateTime date) {
    final df = new DateFormat('yyyy-MM-dd');
    return df.format(date);
  }

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  static List filterWeeklyData() {
    DateTime dateTime = DateTime.now();
    DateTime endDateTime = AnalyticsFunction.findLastDateOfTheWeek(dateTime);
    DateTime startDate = AnalyticsFunction.findFirstDateOfTheWeek(dateTime);
    endDateTime = new DateTime(endDateTime.year, endDateTime.month, endDateTime.day, 23, 59);
    startDate = new DateTime(startDate.year, startDate.month, startDate.day, 1, 1);
    WeeklyData.sevenDaysRecord = Constants.userExerciseGraphData
        .where((element) =>
            element.createdAt.toDate().isAfter(startDate) && element.createdAt.toDate().isBefore(endDateTime))
        .toList();
    List weekRecord = getWeeklyRecord(WeeklyData.sevenDaysRecord);
    return weekRecord;
  }

  static filterMonthlyData() {
    DateTime endDateTime = new DateTime(DateTime.now().year, DateTime.now().month + 1, 0, 23, 59);
    DateTime startDate = new DateTime(DateTime.now().year, DateTime.now().month, 1, 1, 1);

    MonthlyData.monthlyRecord = Constants.userExerciseGraphData
        .where((element) =>
            element.createdAt.toDate().isAfter(startDate) && element.createdAt.toDate().isBefore(endDateTime))
        .toList();

    List<ExerciseModel> firstWeekData;
    List<ExerciseModel> secondWeekData;
    List<ExerciseModel> thirdWeekData;
    List<ExerciseModel> fourthWeekData;
    List<ExerciseModel> fifthWeekData;

    DateTime firstWeekFirstDate = findFirstDateOfTheWeek(startDate);
    DateTime secondWeekFirstDate = findFirstDateOfTheWeek(startDate.add(Duration(days: 7)));
    DateTime thirdWeekFirstDate = findFirstDateOfTheWeek(startDate.add(Duration(days: 14)));
    DateTime fourthWeekFirstDate = findFirstDateOfTheWeek(startDate.add(Duration(days: 21)));
    DateTime fifthWeekFirstDate = findFirstDateOfTheWeek(startDate.add(Duration(days: 28)));

    DateTime firstWeekLastDate = findLastDateOfTheWeek(startDate);
    DateTime secondWeekLastDate = findLastDateOfTheWeek(startDate.add(Duration(days: 7)));
    DateTime thirdWeekLastDate = findLastDateOfTheWeek(startDate.add(Duration(days: 14)));
    DateTime fourthWeekLastDate = findLastDateOfTheWeek(startDate.add(Duration(days: 21)));
    DateTime fifthWeekLastDate = findLastDateOfTheWeek(startDate.add(Duration(days: 28)));

    firstWeekData = MonthlyData.monthlyRecord
        .where((element) =>
            element.createdAt.toDate().isAfter(firstWeekFirstDate) &&
            element.createdAt.toDate().isBefore(firstWeekLastDate))
        .toList();
    List<double> firstWeek = getMonthlyRecord(firstWeekData);

    secondWeekData = MonthlyData.monthlyRecord
        .where((element) =>
            element.createdAt.toDate().isAfter(secondWeekFirstDate) &&
            element.createdAt.toDate().isBefore(secondWeekLastDate))
        .toList();
    List<double> secondWeek = getMonthlyRecord(secondWeekData);

    thirdWeekData = MonthlyData.monthlyRecord
        .where((element) =>
            element.createdAt.toDate().isAfter(thirdWeekFirstDate) &&
            element.createdAt.toDate().isBefore(thirdWeekLastDate))
        .toList();
    List<double> thirdWeek = getMonthlyRecord(thirdWeekData);

    fourthWeekData = MonthlyData.monthlyRecord
        .where((element) =>
            element.createdAt.toDate().isAfter(fourthWeekFirstDate) &&
            element.createdAt.toDate().isBefore(fourthWeekLastDate))
        .toList();
    List<double> fourthWeek = getMonthlyRecord(fourthWeekData);

    fifthWeekData = MonthlyData.monthlyRecord
        .where((element) =>
            element.createdAt.toDate().isAfter(fifthWeekFirstDate) &&
            element.createdAt.toDate().isBefore(fifthWeekLastDate))
        .toList();
    List<double> fifthWeek = getMonthlyRecord(fifthWeekData);

    List<double> fastestWorkBag = [firstWeek[0], secondWeek[0], thirdWeek[0], fourthWeek[0], fifthWeek[0]];
    List<double> fastestWorkBagPack = [
      firstWeek[1],
      secondWeek[1],
      thirdWeek[1],
      fourthWeek[1],
      fifthWeek[1]
    ];
    List<double> fasterWorkBag = [firstWeek[2], secondWeek[2], thirdWeek[2], fourthWeek[2], fifthWeek[2]];
    List<double> fasterWorkBagPack = [firstWeek[3], secondWeek[3], thirdWeek[3], fourthWeek[3], fifthWeek[3]];

    return [fastestWorkBag, fastestWorkBagPack, fasterWorkBagPack, fasterWorkBag];
  }

  static filterThreeMonthData() {
    List<ExerciseModel> firstMonthData;
    List<ExerciseModel> secondMonthData;
    List<ExerciseModel> thirdMonthData;

    var now = DateTime.now();
    var firstMonthDate = Jiffy(now).subtract(months: 3);
    var secondMonthDate = Jiffy(now).subtract(months: 2);
    var thirdMonthDate = Jiffy(now).subtract(months: 1);

    DateTime startDate = new DateTime(DateTime.now().year, firstMonthDate.month, 1, 1, 1);
    DateTime endDateTime = new DateTime(DateTime.now().year, thirdMonthDate.month + 1, 0, 23, 59);

    DateTime firstMonthFirstDate = DateTime(DateTime.now().year, firstMonthDate.month, 1, 1, 1);
    DateTime secondMonthFirstDate = DateTime(DateTime.now().year, secondMonthDate.month, 1, 1, 1);
    DateTime thirdMonthFirstDate = DateTime(DateTime.now().year, thirdMonthDate.month, 1, 1, 1);

    DateTime firstMonthLastDate = DateTime(DateTime.now().year, firstMonthDate.month + 1, 0, 23, 59);
    DateTime secondMonthLastDate = DateTime(DateTime.now().year, secondMonthDate.month + 1, 0, 23, 59);
    DateTime thirdMonthLastDate = DateTime(DateTime.now().year, thirdMonthDate.month + 1, 0, 23, 59);

    ThreeMonthsData.threeMonthsRecord = Constants.userExerciseGraphData
        .where((element) =>
            element.createdAt.toDate().isAfter(startDate) && element.createdAt.toDate().isBefore(endDateTime))
        .toList();

    firstMonthData = ThreeMonthsData.threeMonthsRecord
        .where((element) =>
            element.createdAt.toDate().isAfter(firstMonthFirstDate) &&
            element.createdAt.toDate().isBefore(firstMonthLastDate))
        .toList();
    List<double> firstMonth = getMonthlyRecord(firstMonthData);

    secondMonthData = ThreeMonthsData.threeMonthsRecord
        .where((element) =>
            element.createdAt.toDate().isAfter(secondMonthFirstDate) &&
            element.createdAt.toDate().isBefore(secondMonthLastDate))
        .toList();
    List<double> secondMonth = getMonthlyRecord(secondMonthData);

    thirdMonthData = ThreeMonthsData.threeMonthsRecord
        .where((element) =>
            element.createdAt.toDate().isAfter(thirdMonthFirstDate) &&
            element.createdAt.toDate().isBefore(thirdMonthLastDate))
        .toList();
    List<double> thirdMonth = getMonthlyRecord(thirdMonthData);

    List<double> fastestWorkBag = [firstMonth[0], secondMonth[0], thirdMonth[0]];
    List<double> fastestWorkBagPack = [firstMonth[1], secondMonth[1], thirdMonth[1]];
    List<double> fasterWorkBag = [firstMonth[2], secondMonth[2], thirdMonth[2]];
    List<double> fasterWorkBagPack = [firstMonth[3], secondMonth[3], thirdMonth[3]];

    return [fastestWorkBag, fastestWorkBagPack, fasterWorkBagPack, fasterWorkBag];
  }

  static List<double> getMonthlyRecord(List data) {
    int f1 = 0;
    int f2 = 0;
    double fastestWorkoutBagRecord = 0;
    double fastestWorkoutBagPackRecord = 0;
    double fasterWorkoutBagRecord = 0;
    double fasterWorkoutBagPackRecord = 0;
    List<ExerciseModel> fastestWorkoutRecord =
        data.where((element) => element.exerciseType == 'Fastest Workout').toList();
    List<ExerciseModel> fasterWorkoutRecord =
        data.where((element) => element.exerciseType == 'Faster Workout').toList();
    if (fastestWorkoutRecord.length != 0) {
      fastestWorkoutRecord.forEach((element) {
        fastestWorkoutBagRecord = fastestWorkoutBagRecord + element.data[1];
        fastestWorkoutBagPackRecord = fastestWorkoutBagPackRecord + element.data[3];
        f1++;
      });
      fastestWorkoutBagRecord = (fastestWorkoutBagRecord / f1).roundToDouble();
      fastestWorkoutBagPackRecord = (fastestWorkoutBagPackRecord / f1).roundToDouble();
    }

    if (fasterWorkoutRecord.length != 0) {
      fasterWorkoutRecord.forEach((element) {
        fasterWorkoutBagRecord = fasterWorkoutBagRecord + element.data[1];
        fasterWorkoutBagPackRecord = fasterWorkoutBagPackRecord + element.data[3];
        f2++;
      });
      fasterWorkoutBagRecord = (fasterWorkoutBagRecord / f2).roundToDouble();
      fasterWorkoutBagPackRecord = (fasterWorkoutBagPackRecord / f2).roundToDouble();
    }

    return [
      fastestWorkoutBagRecord,
      fastestWorkoutBagPackRecord,
      fasterWorkoutBagRecord,
      fasterWorkoutBagPackRecord,
    ];
  }

  static List getWeeklyRecord(List data) {
    List<double> fastestWorkoutBagRecord = List.filled(7, 0);
    List<double> fastestWorkoutBagPackRecord = List.filled(7, 0);
    List<double> fasterWorkoutBagRecord = List.filled(7, 0);
    List<double> fasterWorkoutBagPackRecord = List.filled(7, 0);
    List<ExerciseModel> fastestWorkoutSevenDaysRecord =
        data.where((element) => element.exerciseType == 'Fastest Workout').toList();
    List<ExerciseModel> fasterWorkoutSevenDaysRecord =
        data.where((element) => element.exerciseType == 'Faster Workout').toList();
    String trackDay;
    fastestWorkoutSevenDaysRecord.forEach((element) {
      trackDay = formatWeekDays(element.createdAt.toDate());
      switch (trackDay) {
        case "Mon":
          {
            if (fastestWorkoutBagRecord[0] != 0) {
              fastestWorkoutBagRecord[0] = double.parse(element.data[1].toString());
              if (fastestWorkoutBagRecord[0] >= 100) {
                fastestWorkoutBagRecord[0] = 100;
              }
            } else
              fastestWorkoutBagRecord[0] = double.parse(element.data[1].toString());

            if (fastestWorkoutBagPackRecord[0] != 0) {
              fastestWorkoutBagPackRecord[0] = double.parse(element.data[3].toString());
              if (fastestWorkoutBagPackRecord[0] >= 100) {
                fastestWorkoutBagPackRecord[0] = 100;
              }
            } else
              fastestWorkoutBagPackRecord[0] = double.parse(element.data[3].toString());
          }
          break;
        case "Tue":
          {
            if (fastestWorkoutBagRecord[1] != 0) {
              fastestWorkoutBagRecord[1] = double.parse(element.data[1].toString());
              if (fastestWorkoutBagRecord[1] >= 100) {
                fastestWorkoutBagRecord[1] = 100;
              }
            } else
              fastestWorkoutBagRecord[1] = double.parse(element.data[1].toString());

            if (fastestWorkoutBagPackRecord[1] != 0) {
              fastestWorkoutBagPackRecord[1] = double.parse(element.data[3].toString());
              if (fastestWorkoutBagPackRecord[1] >= 100) {
                fastestWorkoutBagPackRecord[1] = 100;
              }
            } else
              fastestWorkoutBagPackRecord[1] = double.parse(element.data[3].toString());
          }
          break;
        case "Wed":
          {
            if (fastestWorkoutBagRecord[2] != 0) {
              fastestWorkoutBagRecord[2] = double.parse(element.data[1].toString());
              if (fastestWorkoutBagRecord[2] >= 100) {
                fastestWorkoutBagRecord[2] = 100;
              }
            } else
              fastestWorkoutBagRecord[2] = double.parse(element.data[1].toString());

            if (fastestWorkoutBagPackRecord[2] != 0) {
              fastestWorkoutBagPackRecord[2] = double.parse(element.data[3].toString());
              if (fastestWorkoutBagPackRecord[2] >= 100) {
                fastestWorkoutBagPackRecord[2] = 100;
              }
            } else
              fastestWorkoutBagPackRecord[2] = double.parse(element.data[3].toString());
          }
          break;
        case "Thu":
          {
            if (fastestWorkoutBagRecord[3] != 0) {
              fastestWorkoutBagRecord[3] = double.parse(element.data[1].toString());
              if (fastestWorkoutBagRecord[3] >= 100) {
                fastestWorkoutBagRecord[3] = 100;
              }
            } else
              fastestWorkoutBagRecord[3] = double.parse(element.data[1].toString());

            if (fastestWorkoutBagPackRecord[3] != 0) {
              fastestWorkoutBagPackRecord[3] = double.parse(element.data[3].toString());
              if (fastestWorkoutBagPackRecord[3] >= 100) {
                fastestWorkoutBagPackRecord[3] = 100;
              }
            } else
              fastestWorkoutBagPackRecord[3] = double.parse(element.data[3].toString());
          }
          break;
        case "Fri":
          {
            if (fastestWorkoutBagRecord[4] != 0) {
              fastestWorkoutBagRecord[4] =
                  fastestWorkoutBagRecord[4] + double.parse(element.data[1].toString());
              if (fastestWorkoutBagRecord[4] >= 100) {
                fastestWorkoutBagRecord[4] = 100;
              }
            } else
              fastestWorkoutBagRecord[4] = double.parse(element.data[1].toString());

            if (fastestWorkoutBagPackRecord[4] != 0) {
              fastestWorkoutBagPackRecord[4] = double.parse(element.data[3].toString());
              if (fastestWorkoutBagPackRecord[4] >= 100) {
                fastestWorkoutBagPackRecord[4] = 100;
              }
            } else
              fastestWorkoutBagPackRecord[4] = double.parse(element.data[3].toString());
          }
          break;
        case "Sat":
          {
            if (fastestWorkoutBagRecord[5] != 0) {
              fastestWorkoutBagRecord[5] = double.parse(element.data[1].toString());
              if (fastestWorkoutBagRecord[5] >= 100) {
                fastestWorkoutBagRecord[5] = 100;
              }
            } else
              fastestWorkoutBagRecord[5] = double.parse(element.data[1].toString());

            if (fastestWorkoutBagPackRecord[5] != 0) {
              fastestWorkoutBagPackRecord[5] = double.parse(element.data[3].toString());
              if (fastestWorkoutBagPackRecord[5] >= 100) {
                fastestWorkoutBagPackRecord[5] = 100;
              }
            } else
              fastestWorkoutBagPackRecord[5] = double.parse(element.data[3].toString());
          }
          break;
        case "Sun":
          {
            if (fastestWorkoutBagRecord[6] != 0) {
              fastestWorkoutBagRecord[6] = double.parse(element.data[1].toString());
              if (fastestWorkoutBagRecord[6] >= 100) {
                fastestWorkoutBagRecord[6] = 100;
              }
            } else
              fastestWorkoutBagRecord[6] = double.parse(element.data[1].toString());

            if (fastestWorkoutBagPackRecord[6] != 0) {
              fastestWorkoutBagPackRecord[6] = double.parse(element.data[3].toString());
              if (fastestWorkoutBagPackRecord[6] >= 100) {
                fastestWorkoutBagPackRecord[6] = 100;
              }
            } else
              fastestWorkoutBagPackRecord[6] = double.parse(element.data[3].toString());
          }
          break;
      }
    });

    fasterWorkoutSevenDaysRecord.forEach((element) {
      trackDay = formatWeekDays(element.createdAt.toDate());
      switch (trackDay) {
        case "Mon":
          {
            if (fasterWorkoutBagRecord[0] != 0) {
              fasterWorkoutBagRecord[0] = double.parse(element.data[1].toString());
              if (fasterWorkoutBagRecord[0] >= 100) {
                fasterWorkoutBagRecord[0] = 100;
              }
            } else
              fasterWorkoutBagRecord[0] = double.parse(element.data[1].toString());

            if (fasterWorkoutBagPackRecord[0] != 0) {
              fasterWorkoutBagPackRecord[0] = double.parse(element.data[3].toString());
              if (fasterWorkoutBagPackRecord[0] >= 100) {
                fasterWorkoutBagPackRecord[0] = 100;
              }
            } else
              fasterWorkoutBagPackRecord[0] = double.parse(element.data[3].toString());
          }
          break;
        case "Tue":
          {
            if (fasterWorkoutBagRecord[1] != 0) {
              fasterWorkoutBagRecord[1] = double.parse(element.data[1].toString());
              if (fasterWorkoutBagRecord[1] >= 100) {
                fasterWorkoutBagRecord[1] = 100;
              }
            } else
              fasterWorkoutBagRecord[1] = double.parse(element.data[1].toString());

            if (fasterWorkoutBagPackRecord[1] != 0) {
              fasterWorkoutBagPackRecord[1] = double.parse(element.data[3].toString());
              if (fasterWorkoutBagPackRecord[1] >= 100) {
                fasterWorkoutBagPackRecord[1] = 100;
              }
            } else
              fasterWorkoutBagPackRecord[1] = double.parse(element.data[3].toString());
          }
          break;
        case "Wed":
          {
            if (fasterWorkoutBagRecord[2] != 0) {
              fasterWorkoutBagRecord[2] = double.parse(element.data[1].toString());
              if (fasterWorkoutBagRecord[2] >= 100) {
                fasterWorkoutBagRecord[2] = 100;
              }
            } else
              fasterWorkoutBagRecord[2] = double.parse(element.data[1].toString());

            if (fasterWorkoutBagPackRecord[2] != 0) {
              fasterWorkoutBagPackRecord[2] = double.parse(element.data[3].toString());
              if (fasterWorkoutBagPackRecord[2] >= 100) {
                fasterWorkoutBagPackRecord[2] = 100;
              }
            } else
              fasterWorkoutBagPackRecord[2] = double.parse(element.data[3].toString());
          }
          break;
        case "Thu":
          {
            if (fasterWorkoutBagRecord[3] != 0) {
              fasterWorkoutBagRecord[3] = double.parse(element.data[1].toString());
              if (fasterWorkoutBagRecord[3] >= 100) {
                fasterWorkoutBagRecord[3] = 100;
              }
            } else
              fasterWorkoutBagRecord[3] = double.parse(element.data[1].toString());

            if (fasterWorkoutBagPackRecord[3] != 0) {
              fasterWorkoutBagPackRecord[3] = double.parse(element.data[3].toString());
              if (fasterWorkoutBagPackRecord[3] >= 100) {
                fasterWorkoutBagPackRecord[3] = 100;
              }
            } else
              fasterWorkoutBagPackRecord[3] = double.parse(element.data[3].toString());
          }
          break;
        case "Fri":
          {
            if (fasterWorkoutBagRecord[4] != 0) {
              fasterWorkoutBagRecord[4] = double.parse(element.data[1].toString());
              if (fasterWorkoutBagRecord[4] >= 100) {
                fasterWorkoutBagRecord[4] = 100;
              }
            } else
              fasterWorkoutBagRecord[4] = double.parse(element.data[1].toString());

            if (fasterWorkoutBagPackRecord[4] != 0) {
              fasterWorkoutBagPackRecord[4] = double.parse(element.data[3].toString());
              if (fasterWorkoutBagPackRecord[4] >= 100) {
                fasterWorkoutBagPackRecord[4] = 100;
              }
            } else
              fasterWorkoutBagPackRecord[4] = double.parse(element.data[3].toString());
          }
          break;
        case "Sat":
          {
            if (fasterWorkoutBagRecord[5] != 0) {
              fasterWorkoutBagRecord[5] = double.parse(element.data[1].toString());
              if (fasterWorkoutBagRecord[4] >= 100) {
                fasterWorkoutBagRecord[4] = 100;
              }
            } else
              fasterWorkoutBagRecord[5] = double.parse(element.data[1].toString());

            if (fasterWorkoutBagPackRecord[5] != 0) {
              fasterWorkoutBagPackRecord[5] = double.parse(element.data[3].toString());
              if (fasterWorkoutBagPackRecord[5] >= 100) {
                fasterWorkoutBagPackRecord[5] = 100;
              }
            } else
              fasterWorkoutBagPackRecord[5] = double.parse(element.data[3].toString());
          }
          break;
        case "Sun":
          {
            if (fasterWorkoutBagRecord[6] != 0) {
              fasterWorkoutBagRecord[6] = double.parse(element.data[1].toString());
              if (fasterWorkoutBagRecord[6] >= 100) {
                fasterWorkoutBagRecord[6] = 100;
              }
            } else
              fasterWorkoutBagRecord[6] = double.parse(element.data[1].toString());

            if (fasterWorkoutBagPackRecord[6] != 0) {
              fasterWorkoutBagPackRecord[6] = double.parse(element.data[3].toString());
              if (fasterWorkoutBagPackRecord[6] >= 100) {
                fasterWorkoutBagPackRecord[6] = 100;
              }
            } else
              fasterWorkoutBagPackRecord[6] = double.parse(element.data[3].toString());
          }
          break;
      }
    });

    return [
      fastestWorkoutBagRecord,
      fastestWorkoutBagPackRecord,
      fasterWorkoutBagRecord,
      fasterWorkoutBagPackRecord
    ];
  }
}
