import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tsscourses/core/download.dart';
import 'package:tsscourses/core/popup_singleton.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/core/sql_service.dart';
import 'package:tsscourses/core/vimeo.dart';
import 'package:tsscourses/domain/entities/chapitre.dart';
import 'package:tsscourses/domain/entities/formation.dart';
import 'package:tsscourses/domain/entities/lesson.dart';
import 'package:tsscourses/presentation/components/view_models/data_view_model.dart';
import 'package:tsscourses/presentation/screens/commons/player_online_screen.dart';

class ChapitreWidget extends StatefulHookConsumerWidget {

 final Chapitre item;
 final Lesson lesson;
 final Formation formation;

 ChapitreWidget({required this.item, required this.lesson, required this.formation});

  @override
  ChapitreWidgetState createState() => ChapitreWidgetState(item : item, lesson: lesson, formation: formation);
}

class ChapitreWidgetState  extends ConsumerState<ChapitreWidget>  {

 final Chapitre item;
 final Lesson lesson;
 final Formation formation;

 ChapitreWidgetState({
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
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status =  DownloadTaskStatus.fromInt(data[1]);
      int progress = data[2];
      setState((){ });
    });

    FlutterDownloader.registerCallback(downloadCallback);

  }

  @override
  void dispose() {
  IsolateNameServer.removePortNameMapping('downloader_send_port');
  super.dispose();
  }

@pragma('vm:entry-point')
static void downloadCallback(String id, int status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send!.send([id, status, progress]);
}


download(String lien) async {

  PermissionStatus status;

  if(Platform.isAndroid) {
      final deviceinfo = await DeviceInfoPlugin().androidInfo;
      if (deviceinfo.version.sdkInt > 32) {
       status = await Permission.photos.request(); 
      }
      else {
        status = await Permission.storage.request(); 
      }
  }

  else {
     status = await Permission.storage.request(); 
  }   


 // var database = await openDatabase('wouri_bd.db');
  //final db = await database;
  final Database database = await SqlLiteService().database;
  final List<Map<String, dynamic>> maps = await database.rawQuery('SELECT * FROM Download WHERE movie=? ', [item.id]);

  List<Download> movie2 = List.generate(maps.length, (i) {
      return Download(
          id: maps[i]['id'],
          titre: maps[i]['titre'],
          description: maps[i]['description'],
          categorie: maps[i]['categorie'],
          taskid: maps[i]['taskid'],
          lien: maps[i]['lien'],
          filename: maps[i]['filename'],
          statut: maps[i]['statut'],
          movie: maps[i]['movie']);
  });

  if (movie2.isNotEmpty) {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.download_t9,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
  } else if (movie2.length == 50) {
      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.download_t10,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
  } else {

  
    if (status == PermissionStatus.granted) { 
     
      final externalDir = (Platform.isAndroid) ? await getExternalStorageDirectory() : await getApplicationSupportDirectory();
     // final dir = await getApplicationDocumentsDirectory();
      String title = "${lesson.titre} - ${item.titre}";

      var localPath = externalDir!.path;
      final savedDir = Directory(localPath);

      await savedDir.create(recursive: true).then((value) async {
         
          String? taskid = await FlutterDownloader.enqueue(
            url: lien,
            fileName: "$title.mp4",
            savedDir: localPath,
            showNotification: false,
            openFileFromNotification: false,
          );

          await database.rawInsert('INSERT INTO Download(titre, description, categorie, taskid, lien, filename, statut, movie) VALUES(?,?,?,?,?,?,?,?)',
              [title, formation.resume, int.parse(lesson.id), taskid.toString(),  lien,  "$title.mp4", 1, int.parse(item.id)]);

          Fluttertoast.showToast(
              msg: AppLocalizations.of(context)!.downlod_t7,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white);

      });    

    } else {
        Fluttertoast.showToast(
            msg: AppLocalizations.of(context)!.downlod_t8,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
      }
  }


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

downloadLinkGenerator(String video) async {

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
          title: Text(AppLocalizations.of(context)!.read_4, style: const TextStyle(fontSize: 16.0, fontFamily: 'Candara', fontWeight: FontWeight.bold ),),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListView(
              shrinkWrap: true,
              children: result.download.map((e) => GestureDetector(onTap:(){ 
                 Navigator.of(context).pop();
                 download(e.link);
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
                          child: IconButton(
                                    icon: const Icon(Icons.download_sharp),
                                    onPressed: () {
                                      downloadLinkGenerator(item.video);
                                    },
                                    color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white,
                                    iconSize: 25,
                                  )  ),  
                        ) ,

                      ]
           
        );

}


}