
import 'dart:io';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/presentation/screens/mobile/login_screen.dart';

class OnboardingScreen extends StatefulHookConsumerWidget {

  OnboardingScreen();

  @override
  OnboardingScreenState createState() => new OnboardingScreenState();
}

class OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  
  bool isconnected = false;

  OnboardingScreenState();


  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
            duration: 2000,
            splash: Image.asset('img/logo.png'),
            nextScreen:  LoginScreen(),
            centered: true,
            splashIconSize: 400.0,
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: Theme.of(context).brightness == Brightness.light ? Setting.white : Setting.bgColor
          );
            
  }
    
  }