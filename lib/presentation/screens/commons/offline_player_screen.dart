import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/core/sizeconfig.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class OfflinePlayerScreen extends StatelessWidget {

  String directory;
  String filename;
  OfflinePlayerScreen(this.directory, this.filename);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          backgroundColor: Colors.black.withOpacity(1.0),
          body: OfflinePlayerScreen1(directory, filename)
          );
  }
}

class OfflinePlayerScreen1 extends StatefulWidget {
  String directory;
  String filename;
  OfflinePlayerScreen1(this.directory, this.filename);

  @override
  OfflinePlayerScreenState createState() => OfflinePlayerScreenState(directory,filename);
}

class OfflinePlayerScreenState extends State<OfflinePlayerScreen1> {
  String directory;
  String filename;
  VideoPlayerController? _controller;
  OfflinePlayerScreenState(this.directory, this.filename);
  bool _isContainerVisible = false;
  bool _isPlaying = false;
  String duree = "";

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

  String dossier = "";

  _getDossier() async {
      final externalDir = (Platform.isAndroid) ? await getExternalStorageDirectory() : await getApplicationSupportDirectory();
       dossier = await externalDir!.path;
  }



  bool initialize = true;

    Future<void> initVideo() async {

       final externalDir = (Platform.isAndroid) ? await getExternalStorageDirectory() : await getApplicationSupportDirectory();
       String path = await externalDir!.path;
        final File file = File(path + "/" + filename);

            if(!file.existsSync()) {
    } else {
              
            }
   
   _controller = VideoPlayerController.file(file);
      
    await _controller!.initialize().then((_) {
        setState(() {
          _isPlaying = false;
          _isContainerVisible = true;
           initialize = false;
        });
      });

      await _controller!.setLooping(false);

      _controller!.addListener(checkVideo);
  }



  @override
  void initState() {
    WakelockPlus.enable();
    super.initState();

  /*  _getDossier();

    final File file = File(dossier + "/" + filename);
    if(!file.existsSync()) {
      print("fichier non existant");
    } else print("fichier existant");

    _controller = VideoPlayerController.file(file)
      ..initialize().then((_) {
        setState(() {
          _isContainerVisible = true;
        });
      });
      
    _controller.setLooping(false);
    _controller.addListener(checkVideo);*/

    initVideo();
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    _checkeDuree ();
    
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
            //  Navigator.pop(context);
             Navigator.of(_scaffoldKey.currentContext!).pop();
      }
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
    if(mounted) {
    _controller!.dispose();
    }
    super.dispose();
  }

  void getVideoPosition() {
    var duration = Duration(milliseconds: _controller!.value.position.inMilliseconds.round());
   if (mounted) { setState(() {
     duree = [duration.inMinutes, duration.inSeconds].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
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

  @override
  Widget build(BuildContext context) {
    Locale myLocale = Localizations.localeOf(context);

    return  PopScope(
     canPop: false, 
      child:      Scaffold( 
      key: _scaffoldKey,
      backgroundColor: Setting.bgColor,
      body : GestureDetector( 
          behavior: HitTestBehavior.opaque,
          onTap: () {
             showButton();
             hiddeButton();
          },
          child : Stack(
            children: <Widget>[
                 Container(
                        child:   (!initialize) ?Container(
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
                  child: Container(
                    child : Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                     

                          const SizedBox(width: 10,),
                          
                         Container(
                      padding: const EdgeInsets.all(0),
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Setting.primaryColor, 
                        shape: BoxShape.circle,
                      ),
                      child :  IconButton(
                                icon: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                ), onPressed: () {

                                
                                  if (_controller!.value.isPlaying) {
                                    _controller!.pause();
                                  }

                                  //Navigator.pop(context);
                                   Navigator.of(_scaffoldKey.currentContext!).pop();
                                  
                          },)),


                      ],
                    )
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
                                            color: Setting.secondColor,
                                            size: 40,
                                        ) ,
                         ) ,  

                         const SizedBox(width: 50,),

                         (!_isPlaying) ? 
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                          _controller!.play();
                                            setState(() {
                                              _isPlaying = true;
                                            });
                                            hiddeButton();
                                          });
                                }, 
                                child: const Icon(
                                            Icons.play_arrow_rounded,
                                            color: Setting.secondColor,
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
                                            color: Setting.secondColor,
                                            size: 100,
                                        ) ,)
                                         ,

                         
                         const SizedBox(width: 50,),

                         GestureDetector(
                          onTap: () { forward(); },
                          child:  const Icon(
                                            Icons.forward_10_rounded,
                                            color: Setting.secondColor,
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

                    const Row(children: [
                      
                    ],)
                    
                    ])
                  ) 
                ),


            ]
          
     ) )));

  }


}