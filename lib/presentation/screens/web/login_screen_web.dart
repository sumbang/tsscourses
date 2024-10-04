
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:progress_dialog_fork/progress_dialog_fork.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsscourses/data/models/requests/login_request.dart';
import 'package:tsscourses/presentation/components/view_models/data_view_model.dart';
import 'package:tsscourses/presentation/components/view_models/password_view_model.dart';
import 'package:tsscourses/presentation/components/widgets/alerte_action.dart';
import 'package:tsscourses/presentation/components/widgets/alerte_box.dart';
import 'package:tsscourses/presentation/components/widgets/bouton.dart';
import 'package:tsscourses/presentation/components/widgets/input.dart';
import 'package:tsscourses/presentation/components/widgets/password.dart';
import 'package:flutter_sliding_toast/flutter_sliding_toast.dart';
import 'package:tsscourses/presentation/screens/web/dashboard_screen_web.dart';

import '../../../../core/setting.dart';
import '../../../../core/sizeconfig.dart';
import '../../../../domain/entities/login.dart';

class LoginScreenWeb extends StatefulHookConsumerWidget {

  LoginScreenWeb();

  @override
  LoginScreenWebState createState() => LoginScreenWebState();
}

class LoginScreenWebState extends ConsumerState<LoginScreenWeb> {  

  final _loginController = TextEditingController();
  final _pwdController = TextEditingController();

  bool visiblepassword = true;
  final _formKey = GlobalKey<FormState>();


  Future<void> _makeLogin(BuildContext context,ref) async {

    if(_loginController.text.trim().toString().isEmpty || _pwdController.text.trim().toString().isEmpty ) {
        
              InteractiveToast.pop(
                  context,
                  title: Text(AppLocalizations.of(context)!.empty_txt, ),
                  toastSetting: const PopupToastSetting(
                    animationDuration: Duration(seconds: 1),
                    displayDuration: Duration(seconds: 3),
                    toastAlignment: Alignment.bottomCenter,
                  ),
                  toastStyle: ToastStyle(
                    backgroundColor: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                );
    }

    else {

     final ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible:false);
      pr.style(message: AppLocalizations.of(context)!.wait_title);
    
      await pr.show();
      
      final prefs = await SharedPreferences.getInstance();

      LoginRequest loginRequest = LoginRequest(
        login: _loginController.text.toString(),
        password: _pwdController.text.toString(),
      );

     Future<Login> retour = ref.read(dataViewModelProvider).setLogin(loginRequest);

     retour.then((result) {

        pr.hide().then((isHidden) {
          print(isHidden);
        });

        _loginController.clear();
        _pwdController.clear();

        prefs.setString("authKey",result.authkey);
        prefs.setString("nom",result.nom);
        prefs.setString("email",result.email);
        prefs.setString("id",result.id.toString());
        prefs.setString("statut",result.statut.toString());
        prefs.setString("abonnement",result.abonnement.toString());

        Navigator.push(context, MaterialPageRoute(builder: (_) =>  DashboardScreenWeb(0)), );           

      }).catchError((e) {

                  pr.hide().then((isHidden) {
                      print(isHidden);
                    });

                InteractiveToast.pop(
                  context,
                  title: Text(e.message),
                  toastSetting: const PopupToastSetting(
                    animationDuration: Duration(seconds: 1),
                    displayDuration: Duration(seconds: 3),
                    toastAlignment: Alignment.bottomCenter,
                  ),
                  toastStyle: ToastStyle(
                    backgroundColor: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(.2),
                        blurRadius: 5,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                );
      }); }

      
  } 
  version(BuildContext context) {

  List<AlerteAction> alertes = [];
  alertes.add(AlerteAction(label:AppLocalizations.of(context)!.ok_bt, onTap:()  
  {  Navigator.of(context, rootNavigator: true).pop('dialog'); } ));

   AlerteBox(
                              context: context,
                              title: AppLocalizations.of(context)!.subscribe_tx7,
                              description: "${AppLocalizations.of(context)!.menu_6} - ${Setting.currenversion}",
                              actions: alertes
                            );
                                              
  }

  @override
  void initState()  {
    super.initState();
    
    
  }   


  @override
  Widget build(BuildContext context) {

    final viewModelState = ref.watch(passwordViewModelProvider);
    
    return  PopScope(
     canPop: false, 
      child:   Scaffold(
        resizeToAvoidBottomInset: true,
        appBar:  AppBar(
              title:  const Text( "",  style: TextStyle(color: Colors.white), ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [PopupMenuButton<String>(
                  // Callback that sets the selected popup menu item.
                  onSelected: (String item) {
                      if(item == "1") version(context);
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "1",
                      child: Text(AppLocalizations.of(context)!.menu_6, style: const TextStyle(fontFamily: 'Candara')),
                    )
                  ],
                ),
              ],
        ),
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Setting.white : Setting.bgColor,
        body : SingleChildScrollView(child : Form(
        key: _formKey,
        child: Center( child : Container(
          padding: const EdgeInsets.all(10.0),
          width: (SizeConfig.isMobile) ? double.infinity : 600,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: (SizeConfig.isPortrait) ? (40 * SizeConfig.heightMultiplier) : (10 * SizeConfig.heightMultiplier),
            ),
             Center(
              child:  Image.asset(
                'img/logo.png',
                fit: BoxFit.cover,
                alignment: Alignment.center,
                width: 150.0,
            )),
            const SizedBox(
              height: 20.0,
            ),
            Input(background: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white, controller: _loginController, icon:   Icon(Icons.email,color: Theme.of(context).brightness == Brightness.light ? Setting.white : Setting.bgColor ), label: '${AppLocalizations.of(context)!.login} *', labelColor: Theme.of(context).brightness == Brightness.light ? Setting.white : Setting.bgColor,),
            const SizedBox(
              height: 10.0,
            ),
            Password(background: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white, controller: _pwdController, icon:   Icon(Icons.lock_open,color:  Theme.of(context).brightness == Brightness.light ? Setting.white : Setting.bgColor), label: '${AppLocalizations.of(context)!.password} *', state: viewModelState, labelColor: Theme.of(context).brightness == Brightness.light ? Setting.white : Setting.bgColor,),
            const SizedBox(
              height: 20.0,
            ),
            Bouton(background: Setting.primaryColor, couleur: Setting.white, onTap: () { _makeLogin(context,ref); }, texte: AppLocalizations.of(context)!.login_bt,),
            const SizedBox(
              height: 30.0,
            ), 

          ])))))), 
     );
  }

}