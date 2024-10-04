import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:tsscourses/core/popup_singleton.dart';
import 'package:tsscourses/core/refresh_singleton.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/core/sizeconfig.dart';
import 'package:tsscourses/core/vimeo_file.dart';
import 'package:tsscourses/data/models/requests/logout_request.dart';
import 'package:tsscourses/domain/entities/message.dart';
import 'package:tsscourses/main.dart';
import 'package:tsscourses/presentation/components/view_models/data_view_model.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class PlayerOnlinePcScreen extends StatefulHookConsumerWidget {

  VimeoFile content;
  String titre;
  String lesson;
  String chapitre;
  String formation;
  PlayerOnlinePcScreen(this.content, this.titre, this.chapitre, this.lesson, this.formation);

  @override
  PlayerOnlinePcScreenState createState() => PlayerOnlinePcScreenState(content, titre, chapitre, lesson, formation);
}

class PlayerOnlinePcScreenState extends ConsumerState<PlayerOnlinePcScreen> {
  
  VimeoFile content;
  String titre;
  String lesson;
  String chapitre;
  String formation;
  VideoPlayerController? _controller;

  PlayerOnlinePcScreenState(this.content, this.titre, this.chapitre, this.lesson, this.formation);

  bool _isContainerVisible = false;
  bool _isPlaying = false;
  String duree = "";
  String urlPlay = "";

  repeat() async {
      await _controller!.seekTo((await _controller!.position)! - const Duration(seconds: 10));
  }

  forward() async {
    await _controller!.seekTo((await _controller!.position)! + const Duration(seconds: 10));
  }

  hiddeButton() async {
      await Future.delayed(const Duration(seconds: 10));
      if (mounted) { setState(() {
        if(_isContainerVisible) {
          if(_isPlaying) {
            _isContainerVisible = false;
          } else {
            _isContainerVisible = true;
          }
        } 
      }); }
      
  }

  showButton() {
      if (mounted) { setState(() {
         if(!_isContainerVisible) _isContainerVisible = true;
      }); }
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

      if (_controller!.value.isPlaying) {  _controller!.pause(); }

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
  
  String finalLink = "";

  bool orienter = false;
  bool initialize = true;
  bool first = false;

   Future<bool> _clearPrevious() async {
    await _controller?.dispose();
    return true;
  }

  Future<void> _startPlay() async {
    setState(() {
      initialize = true;
      _isContainerVisible = false;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      _clearPrevious().then((_) {
        initVideo();
      });
    });
  }

  Future<void> initVideo() async {

    if(SizeConfig.isMobile) {
      if(titre.length > 34) titre = "${titre.substring(0, 34)} [...]";
    } 
    else {
      if(titre.length > 60) titre = "${titre.substring(0, 60)} [...]";
    }
    
    finalLink = content.link;
   
     _controller = VideoPlayerController.networkUrl(Uri.parse(finalLink.toString()));
      
    await _controller!.initialize().then((_) {
        setState(() {
          initialize = false;
          _isPlaying = false;
          _isContainerVisible = true;
        });
      });

      await _controller!.setLooping(false);

      _controller!.addListener(checkVideo);
  }

  @override
  void initState()  {
    WakelockPlus.enable();
    super.initState();

    initVideo();
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _checkeDuree ();  
    _checker();
    
  }

  void checkVideo(){
    if (_controller!.value.isPlaying) {
      if(_controller!.value.position.inSeconds >= _controller!.value.duration.inSeconds) {
                if(SizeConfig.isMobile) {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                  ]);
                  }
                  else {
                  SystemChrome.setPreferredOrientations([
                    DeviceOrientation.portraitUp,
                    DeviceOrientation.portraitDown,
                    DeviceOrientation.landscapeLeft,
                    DeviceOrientation.landscapeRight,
                  ]);
                  }
              _controller!.pause();  

            // marquer la video comme terminée
            endTopic();

            if(_scaffoldKey.currentContext != null) Navigator.of(_scaffoldKey.currentContext!).pop();
              
      }
    }
  }

 String duration2String(Duration? dur,{showLive='Live'}){
 Duration duration = dur ?? const Duration();
  if (duration.inSeconds < 0) {
    return showLive;
  } else {
    return duration.toString().split('.').first.padLeft(8, "0");
  }
}

@override
void dispose() {
  WakelockPlus.disable();
  if(SizeConfig.isMobile) {
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  else {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  super.dispose();
  if(mounted) {
  print("fermeture du player");
  _controller!.dispose();
  }
}

  void getVideoPosition() {
    //var reste = _controller.value.duration.inMilliseconds - _controller.value.position.inMilliseconds;
    var duration = Duration(milliseconds: _controller!.value.position.inMilliseconds.round());
   if (mounted) { setState(() {
     if(duration.inHours > 0) {
       duree = [duration.inHours, duration.inMinutes, duration.inSeconds].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
     } else {
       duree = [duration.inMinutes, duration.inSeconds].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
     } 
    _checkeDuree();
    }); }
  }

  _checkeDuree () {
   // print("mise a jour du temps de lecture");
    Future.delayed(const Duration(milliseconds: 1000), () {
      getVideoPosition();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _playing = false;
  bool _casting  = false;
  bool connected = false;
  AppState _state = AppState.idle;
  Map<dynamic,dynamic> _mediaInfo = {};

  whereToPlay() async {
    setState(() {_controller!.play(); _isPlaying = true; });
    hiddeButton();
    if(!first) {
       startTopic(); setState(() {
        first = true;
        }); 
    }
  }
   

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    return PopScope(
     canPop: false, 
      child:     Scaffold( 
      key: _scaffoldKey,
      backgroundColor: Setting.bgColor,
      body :  GestureDetector( 
          behavior: HitTestBehavior.opaque,
          onTap: () {
             showButton();
             hiddeButton();
          },
          child :  Stack(
            children: <Widget>[
                Container(
                        child:  (!initialize) ?Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        color: Colors.black,
                        child :     FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                height: _controller!.value.size?.height ?? 0,
                                width: _controller!.value.size?.width ?? 0,
                                child: VideoPlayer(_controller!),
                              ),
                            )
                                ):Center(child : CircularProgressIndicator(color: Setting.primaryColor,)) 
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
                  
                                if (_controller!.value.isPlaying) {
                                  _controller!.pause();
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

                 Positioned(
                  top: (SizeConfig.isMobile) ? 150.0 : 450.0,
                  child: Container(
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border.all(color: Colors.transparent),  
                    borderRadius: BorderRadius.circular(30), color: Colors.transparent),
                    child: (!_isContainerVisible) ? Container() :  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[

                         GestureDetector(
                          onTap: () { repeat(); },
                          child:  const Icon(
                                            Icons.replay_10_rounded,
                                            color:  Setting.secondColor,
                                            size: 40,
                                        ) ,
                         ) ,  

                         const SizedBox(width: 50,),

                         (!_isPlaying) ? 
                                GestureDetector(
                                  onTap: () { 
                                    whereToPlay();  
                                  }, 
                                child: const Icon(
                                            Icons.play_arrow_rounded,
                                            color:  Setting.secondColor,
                                            size: 100,
                                        ) ,) : 
                                  GestureDetector(
                                  onTap: () {
                                   setState(() {
                                      _controller!.pause();
                                            setState(() {
                                              _isPlaying = false;
                                            });
                                    });
                                }, 
                                child: const Icon(
                                            Icons.pause_rounded,
                                            color:  Setting.secondColor,
                                            size: 100,
                                        ) ,)
                                         ,

                         
                         const SizedBox(width: 50,),

                         GestureDetector(
                          onTap: () { forward(); },
                          child:  const Icon(
                                            Icons.forward_10_rounded,
                                            color:  Setting.secondColor,
                                            size: 40,
                                        ) ,
                         ) ,  
          
                      ])
                  ) 
                ),

                (!_isContainerVisible) ? Container() : Positioned(
                  bottom: 40.0,
                  right: 60.0,
                  left: 60.0,
                  child: Container(
                    width:  MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(border: Border.all(color: Colors.transparent),  
                    borderRadius: BorderRadius.circular(30), color: Colors.transparent),
                    child: Column(children:[
                      
                     Row(children: [ 
                      
                      
                     Expanded(flex: 9,child : SmoothVideoProgress(
                      controller: _controller!,
                      builder: (context, position, duration, child) => Slider(
                        onChangeStart: (_) => _controller!.pause(),
                        onChangeEnd: (_) {
                          if(_isPlaying) _controller!.play();
                        } ,
                        onChanged: (value) => _controller!.seekTo(Duration(milliseconds: value.toInt())),
                        value: position.inMilliseconds.toDouble(),
                        min: 0,
                        activeColor: Setting.primaryColor,
                        inactiveColor: Setting.bottomNavBarbg,
                        max: duration.inMilliseconds.toDouble(),
                      ),
                    ), ),

                    Expanded(flex: 1,child:  Text(duree, style: const TextStyle( color: Setting.secondColor,fontFamily: 'Candara', fontWeight: FontWeight.bold, fontSize: 15.0),textAlign: TextAlign.left,
                    ),)
                     ]),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [

                       Expanded(flex: 3, 
                        child: Padding(padding: const EdgeInsets.only(left: 15),  child : Row(children: [
                          const Icon(
                                    Icons.info,
                                    color:  Setting.secondColor,
                                    size: 20,
                               ),
                               const SizedBox(width: 5,),
                               Text(titre, style: const TextStyle( color: Setting.secondColor,fontFamily: 'Candara', fontWeight: FontWeight.bold, fontSize: 13.0),textAlign: TextAlign.left),
                    
                        ],
                        ))),

                       Expanded(flex: 2, child: Container(),),
                        
                    ],)
                    
                    ])
                  ) 
                ),


            ]
          
     ) )));

  }


}

enum AppState {
  idle,
  connected,
  mediaLoaded,
  error
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  _RoundIconButton({
    required this.icon,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Setting.primaryColor
        ),
        onPressed: onPressed,
        child: Icon(
            icon,
            color: Colors.white
        )
    );
  }
}