import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pod_player/pod_player.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsscourses/core/popup_singleton.dart';
import 'package:tsscourses/core/refresh_singleton.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/core/vimeo_file.dart';
import 'package:tsscourses/data/models/requests/logout_request.dart';
import 'package:tsscourses/domain/entities/message.dart';
import 'package:tsscourses/main_web.dart';
import 'package:tsscourses/presentation/components/view_models/data_view_model.dart';

class PlayerOnlineWebScreen extends StatefulHookConsumerWidget {
  
  VimeoFile content;
  String titre;
  String lesson;
  String chapitre;
  String formation;
  PlayerOnlineWebScreen(this.content, this.titre, this.chapitre, this.lesson, this.formation);

  @override
  PlayerOnlineWebScreenState createState() => PlayerOnlineWebScreenState(content, titre, chapitre, lesson, formation);
}


class PlayerOnlineWebScreenState extends ConsumerState<PlayerOnlineWebScreen> {

  VimeoFile content;
  String titre;
  String lesson;
  String chapitre;
  String formation;

  PlayerOnlineWebScreenState(this.content, this.titre, this.chapitre, this.lesson, this.formation);

  late final PodPlayerController controller;

  @override
  void initState() {
    controller = PodPlayerController(
      playVideoFrom: PlayVideoFrom.network(content.link),
      podPlayerConfig: const PodPlayerConfig(
        autoPlay: true,
        isLooping: false,
      )
    )..initialise();
    super.initState();
    controller.addListener(checkVideo);
    startTopic();
    _checker();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  startTopic () async {
    Future<Message> retour = ref.read(dataViewModelProvider).setStartTopic(int.parse(formation), int.parse(lesson), int.parse(chapitre));
    await retour.then((result) {
             RefreshSingleton mySingleton = RefreshSingleton();
         mySingleton.setRefresh(true);
     }).catchError((e) {
      print(e.message);
      });
  }

  endTopic () async {
    Future<Message> retour = ref.read(dataViewModelProvider).setCompleteTopic(int.parse(formation), int.parse(lesson), int.parse(chapitre));
    await retour.then((result) {
             RefreshSingleton mySingleton = RefreshSingleton();
         mySingleton.setRefresh(true);
     }).catchError((e) {
      print(e.message);
      });
  }

  _checkifToken() async {

    final prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("authKey") ?? "";
    
    LogoutRequest logoutRequest = LogoutRequest(
        token: token
    );

    String connected = "0";
    bool etat = true;
    Future<Message> retour = ref.read(dataViewModelProvider).setCheck(logoutRequest);

    await retour.then((result) {
      connected = "1";
    }).catchError((e) {});

    if(token.isEmpty){ if(mounted)  setState(() {  etat = false; }); }
    else {
      if(connected == "1") { if(mounted)  setState(() {  etat = true; });  }
      else {
         if(mounted) {
           setState(() {
            prefs.remove('authKey');
            prefs.remove('nom');
            prefs.remove('email');
            prefs.remove('id');
            prefs.remove('statut');
            prefs.remove('abonnement');
            etat = false;
          });
         }
      }
    }

    if(!etat) {

      if (controller.isVideoPlaying) {  controller.pause(); }

      Fluttertoast.showToast(
          msg: AppLocalizations.of(context)!.logout_message,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white);
         
      Navigator.push(  context,MaterialPageRoute(builder: (_) => MyApp()),);     
    }

    else {
      _checker();
    }

}
  
  _checker () {
    //print("delete mise a jour du temps de lecture");
    Future.delayed(const Duration(minutes: 5), () {
         if(mounted) _checkifToken();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void checkVideo(){
    if (controller.isVideoPlaying) {
      if(controller.videoPlayerValue!.position.inSeconds >= controller.videoPlayerValue!.duration.inSeconds) {
          controller.pause(); 
          // marquer la video comme terminée
          endTopic();

          if(_scaffoldKey.currentContext != null) Navigator.of(_scaffoldKey.currentContext!).pop();
              
      }
    }
  }
  

  @override
  Widget build(BuildContext context) {

     return PopScope(
     canPop: false, 
      child:     Scaffold( 
      key: _scaffoldKey,
      backgroundColor: Setting.bgColor,
      body : Stack(
            children: <Widget>[
                Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black,
                        child: PodVideoPlayer(controller: controller,
                        podPlayerLabels: const PodPlayerLabels(
                          play: "Play",
                          pause: "Pause",
                        ),),
                ),

                Positioned(
                  top: 10.0,
                  right: 20.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                        
                    Container(
                      padding: const EdgeInsets.all(0),
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Setting.primaryColor, 
                        shape: BoxShape.circle,
                      ),
                      child : IconButton(
                              icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                              ), onPressed: () {
                  
                                if (controller.isVideoPlaying) {
                                  controller.pause();
                                }
                  
                                PopupSingleton mySingleton = PopupSingleton();
                                int total = int.parse(mySingleton.getPage.toString());
                  
                                for(int i = 0; i< total; i++ ) {
                                    if(_scaffoldKey.currentContext != null) Navigator.of(_scaffoldKey.currentContext!).pop();
                                }
                  
                                mySingleton.setPage(0);
                                
                        },)),
                  
                  
                    ],
                  ) 
                ),

            ]
          
     ) ));

  }

}