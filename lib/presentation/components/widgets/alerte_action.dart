import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tsscourses/core/setting.dart';

class AlerteAction extends StatelessWidget   {

  final String label;
  final VoidCallback onTap;

  const AlerteAction({
    required this.label,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
       
       if(kIsWeb) {
        return  TextButton(
            child: Text(label,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,fontFamily: 'Candara', color: Setting.primaryColor)),
            onPressed: onTap,
          );
       }

       else {
        if(Platform.isIOS) {
        return  CupertinoDialogAction(
            child: Text(label,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,fontFamily: 'Candara', color: Setting.primaryColor)),
            onPressed: onTap,
          );
        }
        else {
         return  TextButton(
            child: Text(label,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0,fontFamily: 'Candara', color: Setting.primaryColor)),
            onPressed: onTap,
          );
        }
       }
       }

  }