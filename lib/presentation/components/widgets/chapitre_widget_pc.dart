import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tsscourses/core/popup_singleton.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/core/vimeo.dart';
import 'package:tsscourses/domain/entities/chapitre.dart';
import 'package:tsscourses/domain/entities/formation.dart';
import 'package:tsscourses/domain/entities/lesson.dart';
import 'package:tsscourses/presentation/components/view_models/data_view_model.dart';
import 'package:tsscourses/presentation/screens/commons/player_online_screen.dart';

class ChapitreWidgetPc extends StatefulHookConsumerWidget {

 final Chapitre item;
 final Lesson lesson;
 final Formation formation;

 ChapitreWidgetPc({required this.item, required this.lesson, required this.formation});

  @override
 ChapitreWidgetPcState createState() => ChapitreWidgetPcState(item : item, lesson: lesson, formation: formation);
}

class ChapitreWidgetPcState  extends ConsumerState<ChapitreWidgetPc>  {

 final Chapitre item;
 final Lesson lesson;
 final Formation formation;

 ChapitreWidgetPcState({
    required this.item,
    required this.lesson,
    required this.formation
  }): super();

 ReceivePort _port = ReceivePort();
 String currentUser = "";

 getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentUser = (prefs.getString("id") ?? "");
    });
 }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  void dispose() {
  super.dispose();
  }


playerLinkGenerator(String video) async {

   final ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible:false);
      pr.style(message: AppLocalizations.of(context)!.wait_title);
    
   await pr.show();
   
   Future<Vimeo> retour = ref.read(dataViewModelProvider).getVimeo(video);

   retour.then((result) {

        pr.hide().then((isHidden) {
          print(isHidden);
        });

      showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.read_3, style: const TextStyle(fontSize: 16.0, fontFamily: 'Candara', fontWeight: FontWeight.bold ),),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              children: result.files.map((e) => GestureDetector(onTap:(){ 
                 Navigator.of(context).pop();
                 PopupSingleton mySingleton = PopupSingleton(); mySingleton.setPage(1);
                 Navigator.push(context,MaterialPageRoute(builder: (_) => PlayerOnlineScreen(e,item.titre, item.id, lesson.id, formation.id.toString())), ); 
                }, 
              child: ListTile(title : Text("${e.quality} ${e.publicName} - ${e.sizeShort} ".toUpperCase(), style: const TextStyle(fontFamily: 'Candara', fontWeight: FontWeight.normal, height: 1.5, fontSize: 15.0),textAlign: TextAlign.left)))).toList(),
            ),
          ),
        );
      });


   }).catchError((e) {

                  pr.hide().then((isHidden) {
                      print(isHidden);
                    });

                  Fluttertoast.showToast(
                  msg: e.message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
   }); 

}


@override
Widget build(BuildContext context) {

    return   Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                             IconButton(
                                    icon: (item.students.contains(currentUser)) ? const Icon(Icons.circle_rounded, color: Colors.green, size: 15,) :  const Icon(Icons.circle_rounded, color: Colors.grey, size: 15,),
                                    onPressed: () {},
                                    color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white,
                                    iconSize: 20,
                                  ),

                            
                          ]),  
                        ) ,

                        Expanded(
                        flex: 5,
                        child: GestureDetector(
                          onTap: () {
                             playerLinkGenerator(item.video);
                          },
                          child: Column(
                          children: [
                             Padding(
                              padding: const EdgeInsets.only(top: 0, left: 10),
                              child: Align(alignment: Alignment.centerLeft, child: Text(item.titre, style:  TextStyle( color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white,fontFamily: 'Candara', fontWeight: FontWeight.normal, height: 1.5, fontSize: 15.0),textAlign: TextAlign.left,)))
                          ]),  
                        )) ,

                         Expanded(
                          flex: 1,
                          child: Center(
                          child:  (kIsWeb) ? Container() : IconButton(
                                    icon: const Icon(Icons.play_arrow),
                                    onPressed: () {
                                      playerLinkGenerator(item.video);
                                    },
                                    color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white,
                                    iconSize: 25,
                                  )  ),  
                        ) ,

                      ]
           
        );

}


}