import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsscourses/core/destination.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/data/models/requests/logout_request.dart';
import 'package:tsscourses/domain/entities/message.dart';
import 'package:tsscourses/presentation/components/view_models/data_view_model.dart';
import 'package:tsscourses/presentation/components/widgets/alerte_action.dart';
import 'package:tsscourses/presentation/components/widgets/alerte_box.dart';
import 'package:tsscourses/presentation/screens/commons/onboarding_screen.dart';
import 'package:tsscourses/presentation/screens/mobile/fragments/courses_fragment.dart';
import 'package:tsscourses/presentation/screens/mobile/fragments/download_fragment.dart';
import 'package:tsscourses/presentation/screens/mobile/fragments/free_fragment.dart';


class DashboardScreen extends StatefulHookConsumerWidget {
  int currentTab;
   DashboardScreen(this.currentTab);
  @override
  DashboardScreen1State createState() =>new DashboardScreen1State(this.currentTab);
}

class DashboardScreen1State extends ConsumerState<DashboardScreen> {

  int currentTab;
  DashboardScreen1State(this.currentTab);
  GetIt getIt = GetIt.instance;

@override
void dispose() {
    super.dispose();
}

version(BuildContext context) {

  List<AlerteAction> alertes = [];
  alertes.add(AlerteAction(label:AppLocalizations.of(context)!.ok_bt, onTap:()  
  {  
    
    Navigator.of(context, rootNavigator: true).pop('dialog'); } ));

    AlerteBox(context: context, title: AppLocalizations.of(context)!.subscribe_tx7,
            description: "${AppLocalizations.of(context)!.menu_6} - ${Setting.currenversion}",
             actions: alertes
            );
                                              
  }

int _selectedIndex = 0;

@override
void initState()  {
  super.initState();
  setState(() {
    _selectedIndex = currentTab;
  });
}

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return CoursesFragment();
      case 1:
        return FreeFragment();
      case 2:
        return DownloadFragment();
      default:
    }
  }

  void _selectedTab(int index) {
    setState(() {
       _selectedIndex = index;
    });
   
  }

  String _titleTab(int pos) {
    switch (pos) {
      case 0:
        return AppLocalizations.of(context)!.movie_1;
      case 1:
        return AppLocalizations.of(context)!.movie_2;
      case 2:
        return AppLocalizations.of(context)!.movie_3;
      default: 
        return "";
    }
  }

    Future<void> _MakeLogout(BuildContext context,ref) async {

    final ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible:false);
      pr.style(message: AppLocalizations.of(context)!.wait_title);
    
    await pr.show();

    final prefs = await SharedPreferences.getInstance();
  String token = (prefs.getString("authKey") ?? "");
    LogoutRequest logoutRequest = LogoutRequest(
        token: token
      );

    Future<Message> retour = ref.read(dataViewModelProvider).setLogout(logoutRequest);

    retour.then((result) {

        pr.hide().then((isHidden) {
          print(isHidden);
        });

         prefs.remove('authKey');
        prefs.remove('nom');
        prefs.remove('email');
        prefs.remove('id');
        prefs.remove('statut');
        prefs.remove('abonnement');

        Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OnboardingScreen()),
                    );

    
    }).catchError((e) {
            
                  pr.hide().then((isHidden) {
                      print(isHidden);
                    });

                  Fluttertoast.showToast(
                  msg: e.message,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
      });    



  }

  _deconnexion(BuildContext context, ref) {

    List<AlerteAction> alertes = [];
    alertes.add(AlerteAction(label:AppLocalizations.of(context)!.logout_op2, onTap:()  {  Navigator.of(context, rootNavigator: true).pop('dialog'); } ));
    alertes.add(AlerteAction(label:AppLocalizations.of(context)!.logout_op1, onTap:() { Navigator.of(context, rootNavigator: true).pop('dialog');  _MakeLogout(context,ref); }));

    AlerteBox(
      context: context,
      title: AppLocalizations.of(context)!.logout_title,
      description: AppLocalizations.of(context)!.logout_desc,
      actions: alertes
    );

  }



  @override
  Widget build(BuildContext context) {
      
    final List<Destination> allDestinations = <Destination>[
      Destination(AppLocalizations.of(context)!.movie_1, Icons.list, Colors.white),
      Destination(AppLocalizations.of(context)!.movie_2, Icons.movie, Colors.white),
      Destination(AppLocalizations.of(context)!.movie_3, Icons.download, Colors.white),
    ]; 
    
     return PopScope(
     canPop: false, 
      child:    Scaffold(
      appBar:  AppBar(
              title:  Text( _titleTab(_selectedIndex),  style:  TextStyle(color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white, fontFamily: 'Candara', fontWeight: FontWeight.normal, fontSize: 20 ), ),
              backgroundColor: Theme.of(context).brightness == Brightness.light ? Setting.white : Setting.bgColor,
              elevation: 0,
              leading: Container(margin: const EdgeInsets.all(5), child :ClipOval(
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(40), 
                        child: Image.asset('img/user.jpeg', width: 200,) ,
                      ),
              )),
              actions: [
                PopupMenuButton<String>(
                  // Callback that sets the selected popup menu item.
                  onSelected: (String item) { 

                    if(item == "1"){
                     version(context);
                    }
                    
                    else if(item == "2") {
                      _deconnexion(context, ref);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "1",
                      child: Text(AppLocalizations.of(context)!.menu_6, style: const TextStyle(fontFamily: 'Candara'),),
                    ),
                    PopupMenuItem<String>(
                      value: "2",
                      child: Text(AppLocalizations.of(context)!.logout_title, style: const TextStyle(fontFamily: 'Candara')),
                    ),
                  ]
                ),
              ], 
        ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Setting.white : Setting.bgColor,
      body :  _getDrawerItemWidget(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: Setting.gris,
                backgroundColor: Setting.bottomNavBarbg,
                unselectedItemColor: Setting.white,
                currentIndex: _selectedIndex,
                selectedLabelStyle: const TextStyle( fontFamily: 'Candara', fontWeight: FontWeight.normal),
                unselectedLabelStyle: const TextStyle( fontFamily: 'Candara', fontWeight: FontWeight.normal),
                elevation: 16,
                onTap: (int index) {
                    _selectedTab(index);
                },
                items: allDestinations.map((Destination destination) {
                  return BottomNavigationBarItem(
                      icon: Icon(destination.icon),
                      backgroundColor: Colors.white,
                      label: destination.title, );
                }).toList(),
              ),    
     ));
  }

}