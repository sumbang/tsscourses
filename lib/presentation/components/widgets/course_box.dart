import 'package:flutter/material.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/core/sizeconfig.dart';
import 'package:tsscourses/domain/entities/formation.dart';
import 'package:tsscourses/presentation/screens/mobile/learning_screen.dart';

class CourseBox extends HookConsumerWidget {

final Formation item;

CourseBox({
    required this.item
}): super();

@override
Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build

    return GestureDetector(
        onTap: () {

          Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.read_5,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 16.0
              );

           Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (BuildContext context, _, __) =>
                       LearningScreen(item)));
         },
        child: Container(
          width: MediaQuery.of(context).size.width ,
          margin: EdgeInsets.all(2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Container(
                        width: MediaQuery.of(context).size.width ,
                        decoration: BoxDecoration(border: Border.all(color: Setting.secondColor),  
                        borderRadius: BorderRadius.circular(10),),
                        child : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                          child: (item.banner.toString().isNotEmpty) ? FancyShimmerImage(  
                          imageUrl: item.banner,  
                          height: (SizeConfig.isMobile) ? 250 : (SizeConfig.isPortrait) ? 190 : 220,
                          boxFit: BoxFit.cover,
                          errorWidget:  Image.asset('img/placeholder.jpeg', width: MediaQuery.of(context).size.width , height: 250,)
                          )  : Container(color: Colors.black,),
                        )),

              const SizedBox(height: 5,),

              Align(alignment: Alignment.center, child: Text(item.titre, style:  TextStyle( color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white, fontFamily: 'Candara', height: 1.5, fontWeight: FontWeight.bold, fontSize: 18.0),textAlign: TextAlign.center)),
              
              const SizedBox(height: 5,),

              Align(alignment: Alignment.center, child: Text( (item.resume.length > 90) ? "${item.resume.substring(0,90)} ..." : item.resume, style:  TextStyle( color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white, fontFamily: 'Candara', height: 1.5, fontWeight: FontWeight.normal, fontSize: 15.0),textAlign: TextAlign.justify)),

              const SizedBox(height: 15,),

              SizedBox(
                height: 5.0,
                child:  Center(
                  child:  Container(
                    margin: const EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
                    height: 5.0,
                    color: Setting.secondColor,
                  ),
                ),
              ) ,

              const SizedBox(height: 10,),

          ],),
        )
    );

    

  }

}