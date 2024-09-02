import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/presentation/screens/pc/login_screen_pc.dart';

class OnboardingPcScreen extends StatefulHookConsumerWidget {

  OnboardingPcScreen();

  @override
  OnboardingPcScreenState createState() => new OnboardingPcScreenState();
}

class OnboardingPcScreenState extends ConsumerState<OnboardingPcScreen> {
  
  bool isconnected = false;

  OnboardingPcScreenState();


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
            duration: 2000,
            splash: Image.asset('img/playstore.png'),
            nextScreen:   LoginScreenPc(),
            centered: true,
            splashIconSize: 400.0,
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: Setting.white
          );
            
  }
    
  }