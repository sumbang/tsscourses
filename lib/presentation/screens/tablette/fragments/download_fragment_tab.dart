import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tsscourses/core/download.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/core/sql_service.dart';
import 'package:tsscourses/presentation/screens/commons/offline_player_screen.dart';
import 'package:tsscourses/presentation/screens/tablette/dashboard_screen_tab.dart';

class DownloadFragmentTab extends StatefulWidget {
  DownloadFragmentTab();

  @override
  DownloadFragmentTabState createState() => DownloadFragmentTabState();
}

class DownloadFragmentTabState extends State<DownloadFragmentTab> {
  DownloadFragmentTabState();

  ReceivePort _port = ReceivePort();

  List<int> data = [];
  int currentLength = 0;
  final int increment = 10;
  bool isLoading = false;
  late Future<List<Download>> _listDownload;
  List<Map> downloadsListMaps = [];


  Future task() async {
    List<DownloadTask>? getTasks = await FlutterDownloader.loadTasks();
    getTasks!.forEach((_task) {
      Map _map = Map();
      _map['status'] = _task.status;
      _map['progress'] = _task.progress;
      _map['id'] = _task.taskId;
      _map['filename'] = _task.filename;
      _map['savedDirectory'] = _task.savedDir;
      downloadsListMaps.add(_map);
    });
    setState(() {});
  }

  List<Widget> _buildData(List<Download> liste) {
  List<Widget> maliste = [];

  for (int i = 0; i < liste.length; i++) {
      maliste.add(Container(
          width: double.infinity,
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (liste[i].categorie == 1)
                  ? Flexible(
                      flex: 1,
                      child: IconButton(
                        icon: const Icon(Icons.play_circle),
                        onPressed: () {},
                        color: Colors.white,
                      ),
                    )
                  : Container(),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                flex: 9,
                child: GestureDetector(
                    onTap: () {},
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            liste[i].titre.toString(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Candara',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            height: 5,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ])),
              ),
              (liste[i].categorie == 2)
                  ? Flexible(
                      flex: 1,
                      child: IconButton(
                        icon: const Icon(Icons.keyboard_arrow_right),
                        onPressed: () {},
                        color: Colors.white,
                      ),
                    )
                  : Container()
            ],
          )));
    }

    return maliste;
  }

  Future<List<Download>> getMovies() async {
    // Get a reference to the database.
 final Database database = await SqlLiteService().database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await database.query('Download');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
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
  }

  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }

    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status =  DownloadTaskStatus.fromInt(data[1]);
      int progress = data[2];
      var task =  downloadsListMaps.where((element) => element['id'] == id);
      task.forEach((element) {
        element['progress'] = progress;
        element['status'] = status;
        setState(() {});
      });
    });
  }


  void initState() {
    _listDownload = getMovies();
    super.initState();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback);
    task();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  void _unbindBackgroundIsolate() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
  }

  void dispose() {
    _unbindBackgroundIsolate();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
// your codes
  }

  Widget downloadStatusWidget(DownloadTaskStatus _status) {
    return _status == DownloadTaskStatus.canceled
        ? Text(AppLocalizations.of(context)!.downlod_t1,
            style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Candara',
                fontWeight: FontWeight.normal,
                fontSize: 12.0))
        : _status == DownloadTaskStatus.complete
            ? Text(AppLocalizations.of(context)!.downlod_t2,
                style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Candara',
                    fontWeight: FontWeight.normal,
                    fontSize: 12.0))
            : _status == DownloadTaskStatus.failed
                ? Text(AppLocalizations.of(context)!.downlod_t3,
                    style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Candara',
                        fontWeight: FontWeight.normal,
                        fontSize: 12.0))
                : _status == DownloadTaskStatus.paused
                    ? Text(AppLocalizations.of(context)!.downlod_t4,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Candara',
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0))
                    : _status == DownloadTaskStatus.running
                        ? Text(AppLocalizations.of(context)!.downlod_t5,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Candara',
                                fontWeight: FontWeight.normal,
                                fontSize: 12.0))
                        : Text(AppLocalizations.of(context)!.downlod_t6,
                            style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Candara',
                                fontWeight: FontWeight.normal,
                                fontSize: 12.0));
  }

  Widget buttons(
    DownloadTaskStatus _status,
    String taskid,
    int index,
    int movie,
    String filename,
    String directory,
    BuildContext context,
  ) {

    Future<void> changeTaskID(String taskid, String newTaskID) async {
      Map? task = downloadsListMaps.firstWhere((element) => element['id'] == taskid);

      // downloadsListMaps.firstWhereOrNull((element) => element['id'] == taskid);

      task!['id'] = newTaskID;

    // Get a reference to the database.
      final Database database = await SqlLiteService().database;
      //print("mise a jour du download");
      await database.rawUpdate(
          'UPDATE Download SET taskid = ? WHERE id= ? ', [newTaskID, movie]);
     setState(() {
        _listDownload = getMovies();
      });
    }

    Future<void> deleteTaskID(String taskid) async {

       final ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible:false);
      pr.style(message: AppLocalizations.of(context)!.wait_title);
      await pr.show();

      downloadsListMaps.removeAt(index);
      FlutterDownloader.remove(taskId: taskid, shouldDeleteContent: true);

  
    // Get a reference to the database.
      final Database database = await SqlLiteService().database;
      //print("mise a jour du download");
      await database.rawDelete('DELETE FROM Download WHERE taskid= ? ', [taskid]);

        pr.hide().then((isHidden) {
          print(isHidden);
        });
    
       Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardScreenTab(2)), );
        
    }

    return _status == DownloadTaskStatus.canceled
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                child: const Icon(Icons.cached, size: 20, color: Colors.green),
                onTap: () {
                  //print("refresh");
                  FlutterDownloader.retry(taskId: taskid).then((newTaskID) {
                    changeTaskID(taskid, newTaskID!);
                  });
                },
              ),
              GestureDetector(
                child: const Icon(Icons.delete, size: 25, color: Colors.red),
                onTap: () {
                  //print("supprime");
                  deleteTaskID(taskid);
                  setState(() {});
                },
              )
            ],
          )
        : _status == DownloadTaskStatus.failed
            ? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: const Icon(Icons.cached, size: 25, color: Colors.green),
                    onTap: () {
                      FlutterDownloader.retry(taskId: taskid).then((newTaskID) {
                        changeTaskID(taskid, newTaskID!);
                      });
                    },
                  ),
                  GestureDetector(
                    child: const Icon(Icons.delete, size: 25, color: Colors.red),
                    onTap: () {
                      deleteTaskID(taskid);
                      setState(() {});
                    },
                  )
                ],
              )
            : _status == DownloadTaskStatus.paused
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        child: const Icon(Icons.restart_alt,
                            size: 25, color: Colors.blue),
                        onTap: () {
                          FlutterDownloader.resume(taskId: taskid).then(
                            (newTaskID) => changeTaskID(taskid, newTaskID!),
                          );
                        },
                      ),
                      GestureDetector(
                        child: const Icon(Icons.close, size: 25, color: Colors.red),
                        onTap: () {
                                  deleteTaskID(taskid);
                                  setState(() {});
                        },
                      )
                    ],
                  )
                : _status == DownloadTaskStatus.running
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          GestureDetector(
                            child: const Icon(Icons.pause,
                                size: 25, color: Colors.green),
                            onTap: () {
                              FlutterDownloader.pause(taskId: taskid);
                            },
                          ),
                          GestureDetector(
                            child:
                                const Icon(Icons.close, size: 25, color: Colors.red),
                            onTap: () {
                                  deleteTaskID(taskid);
                                  setState(() {});
                            },
                          )
                        ],
                      )
                    : _status == DownloadTaskStatus.complete
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              GestureDetector(
                                child: const Icon(Icons.play_circle,
                                    size: 25, color: Colors.blue),
                                onTap: () {
                                
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => OfflinePlayerScreen(
                                            directory, filename)),
                                  );
                                },
                              ),
                              GestureDetector(
                                child: const Icon(Icons.delete,
                                    size: 25, color: Colors.red),
                                onTap: () {
                                  deleteTaskID(taskid);
                                  setState(() {});
                                },
                              )
                            ],
                          )
                        : Container();
  }

  
  @override
  Widget build(BuildContext context) {

    return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child :  Padding(
                padding: const EdgeInsets.all(2),
                  child: FutureBuilder<List<Download>>(
                     future: _listDownload,
                     builder: (context, snapshot) {
                       if (snapshot.hasData) {
                         if (snapshot.data!.length != 0) {
                           List<Widget> maliste = [];
                  
                           int dedans = 0;
                            Map _vide = Map();
                            _vide['status'] = null;
                            _vide['progress'] = 0;
                            _vide['id'] = null;
                            _vide['filename'] = null;
                            _vide['savedDirectory'] = null; 
                  
                           for (int i = 0; i < snapshot.data!.length; i++) {
                  
                  
                             Map? task = downloadsListMaps.firstWhere(
                                 (element) => element['id'] == snapshot.data![i].taskid , orElse: () => _vide);
                  
                             if (task['id'] != null) {
                  
                               dedans++;
                               String? _filename = task['filename'];
                               int? _progress = task['progress'];
                               DownloadTaskStatus? _status = task['status'];
                               String? _id = task['id'];
                               String? _savedDirectory = task['savedDirectory'];
                  
                               maliste.add(Card(
                                 elevation: 10,
                                 color: Setting.bottomNavBarbg,
                                 shape: const RoundedRectangleBorder(
                                     borderRadius: BorderRadius.all(Radius.circular(8))),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: <Widget>[
                                     ListTile(
                                       isThreeLine: false,
                                       title: Text(snapshot.data![i].titre,
                                           style:  TextStyle(
                                               color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white  ,
                                               fontFamily: 'Candara',
                                               fontWeight: FontWeight.bold,
                                               fontSize: 16.0)),
                                       subtitle: downloadStatusWidget(_status!),
                                       trailing: SizedBox(
                                         width: 60,
                                         child: buttons(
                                             _status,
                                             _id!,
                                             i,
                                             snapshot.data![i].id,
                                             _filename!,
                                             _savedDirectory!,
                                             context),
                                       ),
                                     ),
                                     _status == DownloadTaskStatus.complete
                                         ? Container()
                                         : const SizedBox(height: 5),
                                     _status == DownloadTaskStatus.complete
                                         ? Container()
                                         : Padding(
                                             padding: const EdgeInsets.all(8.0),
                                             child: Column(
                                               mainAxisAlignment: MainAxisAlignment.end,
                                               crossAxisAlignment:
                                                   CrossAxisAlignment.end,
                                               children: <Widget>[
                                                 Text('$_progress%',
                                                     style:  TextStyle(
                                                         color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white  ,
                                                         fontFamily: 'Candara',
                                                         fontWeight: FontWeight.normal,
                                                         fontSize: 13.0)),
                                                 const SizedBox(height: 5),
                                                 Row(
                                                   children: <Widget>[
                                                     Expanded(
                                                       child: LinearProgressIndicator(
                                                           value: _progress! / 100,
                                                           valueColor:
                                                               const AlwaysStoppedAnimation<
                                                                   Color>(Colors.purple),
                                                           color: Setting.primaryColor),
                                                     ),
                                                   ],
                                                 ),
                                               ],
                                             ),
                                           ),
                                     const SizedBox(height: 10)
                                   ],
                                 ),
                               ));
                             }
                  
                             /*if (dedans == 0) {
                               maliste.add(Center(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   mainAxisAlignment: MainAxisAlignment.start,
                                   mainAxisSize: MainAxisSize.max,
                                   children: [
                                     const SizedBox(
                                       height: 50,
                                     ),
                                      Align(
                                       alignment: Alignment.center,
                                       child: Icon(
                                         Icons.download,
                                         color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white  ,
                                         size: 140,
                                       ),
                                     ),
                                     const SizedBox(
                                       height: 10,
                                     ),
                                     Align(
                                         alignment: Alignment.center,
                                         child: Padding(
                                           padding: const EdgeInsets.all(10),
                                           child: Text(
                                               AppLocalizations.of(context)!.tele_1,
                                               style:  TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   fontFamily: 'Candara',
                                                   fontSize: 17.0,
                                                   color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white  )),
                                         )),
                                     const SizedBox(
                                       height: 15,
                                     ),
                                     Align(
                                         alignment: Alignment.center,
                                         child: Padding(
                                           padding: const EdgeInsets.all(10),
                                           child: Text(
                                              AppLocalizations.of(context)!.tele_2,
                                               textAlign: TextAlign.center,
                                               style:  TextStyle(
                                                   fontWeight: FontWeight.normal,
                                                   fontFamily: 'Candara',
                                                   fontSize: 15.0,
                                                   color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white  )),
                                         )),
                                     const SizedBox(
                                       height: 15,
                                     ),
                                   ],
                                 ),
                               ));
                             }*/
                  
                            
                           }
                  
                           return ListView(
                             padding: const EdgeInsets.all(8),
                             children: maliste,
                           );
                         } else { //return Container();
                           return Center(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.start,
                               mainAxisSize: MainAxisSize.max,
                               children: [
                                 const SizedBox(
                                   height: 50,
                                 ),
                                 Align(
                                   alignment: Alignment.center,
                                   child: Icon(
                                     Icons.download,
                                     color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white  ,
                                     size: 140,
                                   ),
                                 ),
                                 const SizedBox(
                                   height: 10,
                                 ),
                                 Align(
                                     alignment: Alignment.center,
                                     child: Padding(
                                       padding: const EdgeInsets.all(10),
                                       child: Text(
                                          AppLocalizations.of(context)!.tele_1,
                                           style:  TextStyle(
                                               fontWeight: FontWeight.bold,
                                               fontFamily: 'Candara',
                                               fontSize: 17.0,
                                               color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white  )),
                                     )),
                                 const SizedBox(
                                   height: 15,
                                 ),
                                 Align(
                                     alignment: Alignment.center,
                                     child: Padding(
                                       padding: const EdgeInsets.all(10),
                                       child: Text(
                                           AppLocalizations.of(context)!.tele_2,
                                           textAlign: TextAlign.center,
                                           style:  TextStyle(
                                               fontWeight: FontWeight.normal,
                                               fontFamily: 'Candara',
                                               fontSize: 15.0,
                                               color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white   )),
                                     )),
                                 const SizedBox(
                                   height: 15,
                                 ),
                               ],
                             ),
                           );
                         }
                       } else {
                         return const Center(
                           child: Center(
                             child: CircularProgressIndicator(color: Setting.primaryColor),
                           ),
                         );
                       }
                     })));  


 
  }
  

}