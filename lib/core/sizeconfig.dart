import 'package:flutter/cupertino.dart';

class SizeConfig {
  static double _screenWidth = 0;
  static double _screenHeight = 0;
  static double _blockSizeHorizontal = 0;
  static double _blockSizeVertical = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;
  static bool isMobile = false;
  static bool isSmallScreen = false;
  static String taille = "1";
  

  void init(BoxConstraints constraints, Orientation orientation) {
   
    final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalShortestSide = firstView.physicalSize.shortestSide / firstView.devicePixelRatio;

    print("ecran : "+constraints.maxWidth.toString());


    if (orientation == Orientation.portrait) {
      _screenWidth = constraints.maxWidth;
      _screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (_screenWidth < 450) {
        isMobilePortrait = true;
      }

      if(logicalShortestSide < 550) isMobile = true;
      else isMobile = false;

       if (_screenWidth < 400)  isSmallScreen = true;
       else isSmallScreen = false;

       if(_screenWidth >= 0 && _screenWidth <= 500) taille = "1";
       else if(_screenWidth > 500  && _screenWidth <= 800) taille = "2";
       else if(_screenWidth > 800  && _screenWidth <= 1200) taille = "3";
       else if(_screenWidth > 1200  && _screenWidth <= 1600) taille = "4";
       else if(_screenWidth > 1600) taille = "5";


    } else {
      _screenWidth = constraints.maxHeight;
      _screenHeight = constraints.maxWidth;
      isPortrait = false;
      isMobilePortrait = false;

      if(logicalShortestSide < 550) isMobile = true;
      else isMobile = false;

      if (_screenWidth < 400)  isSmallScreen = true;
      else isSmallScreen = false;

       if(_screenWidth >= 0 && _screenWidth <= 460) taille = "1";
       else if(_screenWidth > 460  && _screenWidth <= 700) taille = "2";
       else if(_screenWidth > 700  && _screenWidth <= 1000) taille = "3";
       else if(_screenWidth > 1000  && _screenWidth <= 1500) taille = "4";
       else if(_screenWidth > 1500) taille = "5";


    }

    _blockSizeHorizontal = _screenWidth / 100;
    _blockSizeVertical = _screenHeight / 100;

    textMultiplier = _blockSizeVertical;
    imageSizeMultiplier = _blockSizeHorizontal;
    heightMultiplier = _blockSizeVertical;
    widthMultiplier = _blockSizeHorizontal;

    print(_blockSizeHorizontal);
    print(_blockSizeVertical);
  }
}
