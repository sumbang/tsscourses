import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/core/sizeconfig.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tsscourses/domain/entities/chapitre.dart';
import 'package:tsscourses/domain/entities/formation.dart';
import 'package:tsscourses/domain/entities/lesson.dart';
import 'package:tsscourses/presentation/components/widgets/chapitre_widget.dart';
import 'package:tsscourses/presentation/components/widgets/lesson_widget.dart';

class LearningScreen extends StatefulHookConsumerWidget {

  Formation formation;
  LearningScreen(this.formation);

  @override
  LearningScreenState createState() => new LearningScreenState(this.formation);
}

class LearningScreenState extends ConsumerState<LearningScreen> {

 Formation formation;
 LearningScreenState(this.formation);

 List<Widget> buildFormation(Formation formation) {

    List<Widget> liste = [];

    for(int i = 0; i < formation.contenus.length; i++) {

        liste.add(LessonWidget(item: formation.contenus[i],));

        for(int j = 0; j < formation.contenus[i].chapitres.length; j++) {
            
            liste.add(ChapitreWidget(formation: formation, lesson: formation.contenus[i], item: formation.contenus[i].chapitres[j],));
        }

    }

    return liste;

 }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return  PopScope(
     canPop: false, 
      child:    Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Setting.white : Setting.bgColor,
        body : Stack(
              children: <Widget>[ 

                ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                                      height: 27 * SizeConfig.heightMultiplier,
                                      width: MediaQuery.of(context).size.width,
                                      color: Colors.transparent,
                                      margin: const EdgeInsets.all(0),
                                      child: FancyShimmerImage(  
                                        imageUrl: formation.banner,  
                                        boxFit: BoxFit.cover,
                                        errorWidget:  Image.asset('img/placeholder.jpeg', width: MediaQuery.of(context).size.width , height: 27 * SizeConfig.heightMultiplier),
                                  )
                          ),
                          
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom:0),
                            child: Align(alignment: Alignment.centerLeft, child: Text(formation.titre, style:  TextStyle( color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white, fontFamily: 'Candara', fontWeight: FontWeight.bold, fontSize: 22.0),textAlign: TextAlign.left,)),
                          ) ,                  
              
                          Padding(
                            padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom:0),
                            child: Align(alignment: Alignment.centerLeft, child: Text(formation.resume, style:  TextStyle( color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white,fontFamily: 'Candara', fontWeight: FontWeight.normal, height: 1.5, fontSize: 15.0),textAlign: TextAlign.justify,)),
                          ) ,

                          const SizedBox(height : 10),

                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 10, right: 10, bottom:0),
                            child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Align(alignment: Alignment.centerLeft, child: Text("${AppLocalizations.of(context)!.read_1}${formation.lessons}", style:  TextStyle( color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white,fontFamily: 'Candara', fontWeight: FontWeight.bold, height: 1.5, fontSize: 15.0),textAlign: TextAlign.justify,)),

                                const SizedBox(width : 50),

                                Align(alignment: Alignment.centerLeft, child: Text("${AppLocalizations.of(context)!.read_2}${formation.chapitres}", style:  TextStyle( color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white,fontFamily: 'Candara', fontWeight: FontWeight.bold, height: 1.5, fontSize: 15.0),textAlign: TextAlign.justify,)),
                            ],
                          )),

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

                          ExpansionPanelList(
                            expansionCallback: (int index, bool isExpanded) {
                              setState(() {
                                formation.contenus[index].expanded = isExpanded;
                              });
                            },
                            children: formation.contenus.map<ExpansionPanel>((Lesson item) {
                              return ExpansionPanel(
                                backgroundColor: Theme.of(context).brightness == Brightness.light ? Setting.white : Setting.bgColor ,
                                canTapOnHeader: true,
                                headerBuilder: (BuildContext context, bool isExpanded) {
                                  return LessonWidget(item: item,);
                                },
                                body: Column(
                                  children: item.chapitres.map((e) => ChapitreWidget(formation: formation, lesson: item, item: e)).toList(),
                                ),
                                isExpanded: item.expanded,
                              );
                            }).toList(),
                          )


                        ],
                      ),
                    )
                  ],
                ),

                Positioned(
                    top: 50,
                    right: 20,
                    //height: 75,
                    child: Container(
                        padding: const EdgeInsets.all(0),
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: Setting.primaryColor, 
                          shape: BoxShape.circle,
                        ),
                        child : IconButton( icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop(), color: Colors.white, ),
                                  )
                        ),

              ])
    ));

  }


}