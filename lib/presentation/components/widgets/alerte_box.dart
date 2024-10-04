
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/presentation/components/widgets/alerte_action.dart';


Future<dynamic> AlerteBox({
  required BuildContext context,
  required String title,
  required String description,
  required List<AlerteAction> actions
}) async {

   if(kIsWeb) {

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title,style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,fontFamily: 'Candara', color: Colors.orange)),
          content: Text(description,style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0,fontFamily: 'Candara',height: 1.5,  color: Colors.orange)),
          actions: actions,
        ),
    );
    

   }

   else {

         
   if(Platform.isIOS)  {

    return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text(title,style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,fontFamily: 'Candara', color: Colors.orange)),
          content: Text(description,style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0,fontFamily: 'Candara',height: 1.5,  color: Colors.orange)),
          actions: actions,
        ),
    );

   }
   
   else {

    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title,style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0,fontFamily: 'Candara', color: Colors.orange)),
          content: Text(description,style: const TextStyle(fontWeight: FontWeight.normal, fontSize: 18.0,fontFamily: 'Candara',height: 1.5,  color: Colors.orange)),
          actions: actions,
        ),
    );

   }

   }

}