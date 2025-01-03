import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:tsscourses/core/sizeconfig.dart';

class Setting {

  static const String appName = 'Tss Performance';
  static const String appName_web = 'Tss Performance, A chacun son tableau de bord';
  static const String currenversion = '1.0.1';
  static const String plateforme = '1';
  static const String plateforme_web = '2';

  static const mobileWidth = 600;
  static const desktopWidth = 1400;
  static const int paiement = 1; //1 desactive les paiements, 0 laisser les paiements
  
  static const version_name_short = '1.0.1';
  static const version_name = 'Version 1.0.1 - © 2024 Tss Performance';

  static String getDate(String jour) {
    List<String> dat1 = jour.split(" ");
    List<String> dat2 = dat1[0].split("-");
    return "${dat2[2]}/${dat2[1]}/${dat2[0]}";
  }

  static String getDate2(String jour) {
    List<String> dat2 = jour.split("-");
    return "${dat2[2]}/${dat2[1]}/${dat2[0]}";
  }

  static String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  }

  static const int cacheTimeout = 1 * 60 * 1000; // 1 hour

  static const bgColor = Color(0xFF000000);
  static const primaryColor = Color(0xFFd60d0d);  
  static const white = Color(0xFFFFFFFF);
  static const bottomNavBarbg = Color(0xFFd5bcbc);
  static const gris = Color(0xFF541010);
  static const secondColor = Color(0xFFd5bcbc);
  static const tailleRequest = 30;
  static const encryptKey = "WELCOMEONWOURITV";
  static const ivKey = "fedcba9876543210";

  static String ArrayToString(List<String> list) {
    String retour = "";
    for(int i = 0; i < list.length; i++) {
      if(i != list.length - 1) {
        retour+= "${list[i].trim()}, ";
      } else {
        retour+= list[i].trim();
      }
    }
    return retour;
  }


 static String formatedTime(int timeInSecond) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
}

static int goodSize() {
  if(SizeConfig.taille == 1) return 1;
  else if(SizeConfig.taille == 2) return 2;
  else if(SizeConfig.taille == 3) return 3;
  else if(SizeConfig.taille == 4) return 4;
  else return 5;
}


}