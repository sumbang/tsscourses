import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tsscourses/core/download.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tsscourses/core/sql_service.dart';
import 'package:tsscourses/presentation/screens/commons/offline_player_screen.dart';
import 'package:tsscourses/presentation/screens/pc/dashboard_screen_pc.dart';

class DownloadFragmentPc extends StatefulHookConsumerWidget {  
  
  DownloadFragmentPc();

  @override
  DownloadFragmentPcState createState() => DownloadFragmentPcState();
}

class DownloadFragmentPcState extends ConsumerState<DownloadFragmentPc> {


 late Future<List<Download>> _listDownload;
 var downloadManager = DownloadManager();
 var savedDir = "";

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

    void initState() {
    _listDownload = getMovies();
    super.initState();
    getApplicationSupportDirectory().then((value) => savedDir = value.path);
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
                       if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(color: Setting.primaryColor),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Erreur: ${snapshot.error}"),
                          );
                        } else if (snapshot.hasData) {
                         if (snapshot.data!.length != 0) {
                           List<Widget> maliste = [];
                  
                           for (int i = 0; i < snapshot.data!.length; i++) {
                  
                              maliste.add(ListItem(
                                  onDownloadPlayPausedPressed: (url) async {
                                    setState(() {
                                      var task = downloadManager.getDownload(url);

                                      if (task != null && !task.status.value.isCompleted) {
                                        switch (task.status.value) {
                                          case DownloadStatus.downloading:
                                            downloadManager.pauseDownload(url);
                                            break;
                                          case DownloadStatus.paused:
                                            downloadManager.resumeDownload(url);
                                            break;
                                          case DownloadStatus.queued:
                                            // TODO: Handle this case.
                                          case DownloadStatus.completed:
                                            // TODO: Handle this case.
                                          case DownloadStatus.failed:
                                            // TODO: Handle this case.
                                          case DownloadStatus.canceled:
                                            // TODO: Handle this case.
                                        }
                                      } else {
                                        downloadManager.addDownload(url,
                                            "$savedDir/${downloadManager.getFileNameFromUrl(url)}");
                                      }
                                    });
                                  },
                                  onDelete: (url) async {
                                    var fileName = "$savedDir/${snapshot.data![i].filename}";
                                    var file = File(fileName);
                                    file.delete();

                                    downloadManager.removeDownload(url);

                                    // Get a reference to the database.
                                    final Database database = await SqlLiteService().database;
                                    //print("mise a jour du download");
                                    await database.rawDelete('DELETE FROM Download WHERE movie= ? ', [snapshot.data![i].movie]);

                                    Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardScreenPc(2)), );
                                  },
                                  download: snapshot.data![i],
                                  downloadTask: downloadManager.getDownload(snapshot.data![i].lien)));
                          
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
                       }
                      
                      return const SizedBox.shrink(); // Par défaut, si aucun état ne correspond

                     })));  

  }


}

class ListItem extends StatelessWidget {
  final Function(String) onDownloadPlayPausedPressed;
  final Function(String) onDelete;
  DownloadTask? downloadTask;
  Download download;

  ListItem(
      {Key? key,
      required this.download,
      required this.onDownloadPlayPausedPressed,
      required this.onDelete,
      this.downloadTask})
      : super(key: key);
  

 var savedDir = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.amber,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      download.titre,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (downloadTask != null)
                      ValueListenableBuilder(
                          valueListenable: downloadTask!.status,
                          builder: (context, value, child) {
                            return Container();
                            /*return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text("$value",
                                  style: TextStyle(fontSize: 16)),
                            );*/
                          }),
                  ],
                )),
                downloadTask != null
                    ? ValueListenableBuilder(
                        valueListenable: downloadTask!.status,
                        builder: (context, value, child) {
                          switch (downloadTask!.status.value) {
                            case DownloadStatus.downloading:
                              return IconButton(
                                  onPressed: () {
                                    onDownloadPlayPausedPressed(download.lien);
                                  },
                                  icon: const Icon(Icons.pause));
                            case DownloadStatus.paused:
                              return IconButton(
                                  onPressed: () {
                                    onDownloadPlayPausedPressed(download.lien);
                                  },
                                  icon: const Icon(Icons.cached));
                            case DownloadStatus.completed:
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.play_circle),
                                    onPressed: () {
                                      Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => OfflinePlayerScreen(
                                                        savedDir, download.filename)),
                                              );
                                    },
                                  ),
                                  const SizedBox(width: 5,), 
                                  IconButton(
                                  onPressed: () {
                                    onDelete(download.lien);
                                  },
                                  icon: const Icon(Icons.delete))
                              ],);
                            case DownloadStatus.failed:
                            case DownloadStatus.canceled:
                              return IconButton(
                                  onPressed: () {
                                    onDownloadPlayPausedPressed(download.lien);
                                  },
                                  icon: const Icon(Icons.restart_alt));
                            case DownloadStatus.queued:
                              // TODO: Handle this case.
                          }
                          return Text("$value", style: TextStyle(fontSize: 16));
                        })
                    : Row(crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.play_circle),
                                    onPressed: () {
                                      Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) => OfflinePlayerScreen(
                                                        savedDir, download.filename)),
                                              );
                                    },
                                  ),
                                  const SizedBox(width: 5,), 
                                  IconButton(
                                  onPressed: () {
                                    onDelete(download.lien);
                                  },
                                  icon: const Icon(Icons.delete))
                              ],)
              ],
            ), // if (widget.item.isDownloadingOrPaused)
            if (downloadTask != null && !downloadTask!.status.value.isCompleted)
              ValueListenableBuilder(
                  valueListenable: downloadTask!.progress,
                  builder: (context, value, child) {
                    return (downloadTask!.status.value == DownloadStatus.completed) ? Container() : Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: LinearProgressIndicator(
                        value: value,
                        color:
                            downloadTask!.status.value == DownloadStatus.paused
                                ? Colors.grey
                                : Colors.amber,
                      ),
                    );
                  }),
             /*if (downloadTask != null)
              FutureBuilder<DownloadStatus>(
                  future: downloadTask!.whenDownloadComplete(),
                  builder: (BuildContext context,
                      AsyncSnapshot<DownloadStatus> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Text(
                            'I will wait till this download has been completed');
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text('Result: ${snapshot.data}');
                        }
                    }
                  }) */
          ],
        ),
      ),
    );
  }
}