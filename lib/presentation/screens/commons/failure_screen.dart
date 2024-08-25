import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FailureScreen extends StatefulHookConsumerWidget {

  @override
  FailureScreenState createState() => FailureScreenState();
}


class FailureScreenState extends ConsumerState<FailureScreen> {

  String token = "";

_getToken() async {
  final prefs = await SharedPreferences.getInstance();
  token = prefs.getString("authKey") ?? "";
}


@override
void initState()  {

     _getToken();    
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
            backgroundColor: Colors.black.withOpacity(1.0),
            body: Stack(
              children: <Widget>[
                 Center(child: 
                 Column(children: [
                    const SizedBox(
                         height: 150,
                       ),
                       const Align(
                         alignment: Alignment.center,
                         child: Icon(
                           Icons.error,
                           color: Colors.white,
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
                                AppLocalizations.of(context)!.error_title,
                                 style: const TextStyle(
                                     fontWeight: FontWeight.bold,
                                     fontFamily: 'Candara',
                                     fontSize: 17.0,
                                     height: 1.5,
                                     color: Colors.white)),
                           )),
                       const SizedBox(
                         height: 15,
                       ),
                 ],)),
                 Positioned(
                    top: 50,
                    right: 20,
                    //height: 75,
                    child: Container(
                        padding: const EdgeInsets.all(0),
                        color: Colors.transparent,
                        child : IconButton(icon: const Icon(Icons.close), onPressed: ()  {

                             /* if(kIsWeb) {
                                      if(token.isEmpty) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ProviderScope(child: LoginS())),
                                          );
                                      } else {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ProviderScope(child: DashboardWebScreen())),
                                          );
                                      }  
                              }

                              else if(SizeConfig.isMobile) {

                                        if(token.isEmpty) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ProviderScope(child: HomeScreen())),
                                          );
                                        } else {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ProviderScope(child: DashboardScreen())),
                                          );
                                        }  
                              }

                              else {if(token.isEmpty) {
                                Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ProviderScope(child: HomeTabletteScreen())),
                                          );
                              } else {
                                Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ProviderScope(child: DashboardTabletteScreen())),
                                          );
                              }  

                              } */
                          
                                        
                        }, color: Colors.white, ),
                                  )
                        ),
              ]
            ));
  }

}