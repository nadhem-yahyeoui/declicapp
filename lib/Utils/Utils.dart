import '../enum/UserR.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

class Utils {
  static int getUserRoleNum(UserR userR) {
    switch (userR) {
      case UserR.ADMIN:
        return 0;
      case UserR.TRANS:
        return 1;
      case UserR.SUPER:
        return 2;
      default:
        return 3;
    }
  }

  static UserR getUserRfromNum(int numero) {
    switch (numero) {
      case 0:
        return UserR.ADMIN;
      case 1:
        return UserR.TRANS;
      case 2:
        return UserR.SUPER;
      default:
        return UserR.ANIMA;
    }
  }

  static String getFonctionName(int roleNum) {
    switch (roleNum) {
      case 0:
        return "ADMIN";
      case 1:
        return "Transporteur";
      case 2:
        return "Superviseur";
      default:
        return "Animatrice";
    }
  }

  static UserR getRoleFromEmail(String string) {
    final int myroleNum = int.parse(string.split("@")[0].split("_")[0]);
    return getUserRfromNum(myroleNum);
  }

  static String getCinFromEmail(String string) {
    final String myemail = string.split("@")[0].split("_")[1];
    return myemail;
  }

  static String getCustomDatefromTimeStamp(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return "${date.day.toString()}/${date.month.toString()}/${date.year.toString()}";
  }

  static String getCustomDatefromTimeS(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return "${date.day.toString()}${date.month.toString()}${date.year.toString()}";
  }

  static String getCustomDate2FromTimeS(Timestamp timestamp) {
    final DateTime date = timestamp.toDate();
    return "${date.day.toString()}/${date.month.toString()}/${date.year.toString()} ${date.hour}:${date.minute > 9 ? date.minute.toString() : "0" + date.minute.toString()}";
  }
}
