import 'dart:ui';
import '../models/role.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyConst {
  static const String adminUid = "00000000";
  static const String passUid = "00000000";

  static const List<Role> roles = [
    Role("Transporteur", 1, Color(0xffF38E34)),
    Role("Superviseur", 2, Color(0xff1492E6)),
    Role("Animatrice", 3, Color(0xffFF56C7))
  ];

  static const String noImageProfile =
      "https://www.pikpng.com/pngl/m/80-805068_my-profile-icon-blank-profile-picture-circle-clipart.png";
}
