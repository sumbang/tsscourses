
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
import 'package:tsscourses/presentation/screens/mobile/dashboard_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/setting.dart';
import '../../../../core/sizeconfig.dart';
import '../../../../domain/entities/login.dart';

class LoginScreen extends StatefulHookConsumerWidget {

  LoginScreen();

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends ConsumerState<LoginScreen> {  

  final _loginController = TextEditingController();
  final _pwdController = TextEditingController();

  bool visiblepassword = true;
  final _formKey = GlobalKey<FormState>();


  Future<void> _makeLogin(BuildContext context,ref) async {

    if(_loginController.text.trim().toString().isEmpty || _pwdController.text.trim().toString().isEmpty ) {
              Fluttertoast.showToast(
                  msg: AppLocalizations.of(context)!.empty_txt,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1, 
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
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

        Navigator.push(context, MaterialPageRoute(builder: (_) =>  DashboardScreen(0)), );           

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

    String _authStatus = 'Unknown';

  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
       print("tracking debut");
      final TrackingStatus status = await AppTrackingTransparency.trackingAuthorizationStatus;
      setState(() => _authStatus = '$status');
      // If the system can show an authorization request dialog
      if (status == TrackingStatus.notDetermined) {
        // Show a custom explainer dialog before the system dialog
       // if (await showCustomTrackingDialog(context)) {
          // Wait for dialog popping animation
         // await Future.delayed(const Duration(milliseconds: 200));
          // Request system's tracking authorization dialog
          final TrackingStatus status =
              await AppTrackingTransparency.requestTrackingAuthorization();
          setState(() => _authStatus = '$status');
       // }
      }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
      print("tracking error");
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  }

    Future<bool> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
        onWillPop: () async => false, // <-- Prevents dialog dismiss on press of back button.
        child: AlertDialog(
          title: Text(AppLocalizations.of(context)!.tracking1),
          content:  Text(AppLocalizations.of(context)!.tracking2),
          actions: [
             TextButton(
              onPressed: () => Navigator.pop(context, false),
              child:  Text(AppLocalizations.of(context)!.tracking5),
            ),
          ],
        ),
      )) ??
      false;


  @override
  void initState()  {
    super.initState();
    if(Platform.isIOS) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => initPlugin());
    }
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
              height: (SizeConfig.isMobile) ? (15 * SizeConfig.heightMultiplier) : (7 * SizeConfig.heightMultiplier),
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