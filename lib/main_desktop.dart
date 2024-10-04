import "dart:html" 
  if (dart.library.io) "dart:io";
import 'dart:io';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsscourses/core/api_response_box.dart';
import 'package:tsscourses/core/global_translation.dart';
import 'package:tsscourses/core/my_app_themes.dart';
import 'package:tsscourses/core/navigation_service.dart';
import 'package:tsscourses/data/models/requests/logout_request.dart';
import 'package:tsscourses/domain/entities/message.dart';
import 'package:tsscourses/firebase_options.dart';
import 'package:tsscourses/presentation/components/view_models/data_view_model.dart';
import 'package:tsscourses/presentation/screens/commons/onboarding_pc_screen.dart';
import 'package:tsscourses/presentation/screens/pc/dashboard_screen_pc.dart';
import 'package:upgrader/upgrader.dart';
import 'core/setting.dart';
import 'core/sizeconfig.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


Future<void> main() async {

    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform,);

    // Pass all uncaught errors from the framework to Crashlytics.
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    await Upgrader.clearSavedSettings();

    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    Hive.registerAdapter(ApiResponseBoxAdapter());
  
    HttpOverrides.global = MyHttpOverrides();
    setupLocator();
    
    runApp(
      ProviderScope(child: MyApp())
    );
    
} 


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


class MyApp extends StatefulHookConsumerWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends ConsumerState<MyApp> {


  Future<String>  checkifConnect() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("authKey") ?? "";
    LogoutRequest logoutRequest = LogoutRequest(
        token: token
    );
    
    String connected = "0";

    Future<Message> retour = ref.read(dataViewModelProvider).setCheck(logoutRequest);
    await retour.then((result) {
      connected = "1";
    }).catchError((e) {});

    if(token.isEmpty) {
      return "0";
    } else  {
      if(connected == "1") {
        return "1";
      } else {
        prefs.remove('authKey');
        prefs.remove('nom');
        prefs.remove('email');
        prefs.remove('id');
        prefs.remove('statut');
        prefs.remove('abonnement');
          return "0";
      }
    }
  }

  @override
  Widget build(BuildContext context)  {

    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeConfig().init(constraints, orientation);
            return OverlaySupport(child: MaterialApp(
            title: Setting.appName,
            debugShowCheckedModeBanner: false,
            theme: MyAppThemes.lightTheme,
            darkTheme: MyAppThemes.darkTheme,
            themeMode: ThemeMode.system, // Default mode
            navigatorKey: locator<NavigationService>().navigatorKey,
            navigatorObservers: <NavigatorObserver>[observer],
            localizationsDelegates: const [
              AppLocalizations.delegate, // Add this line
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: allTranslations.supportedLocales(),
            home: FutureBuilder<String>(
              future: checkifConnect(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  if(snapshot.data == "1") {
                    return DashboardScreenPc(0);
                  } else {
                    return OnboardingPcScreen();
                  }
                }

                return Scaffold(
                    body: Container(
                      color: Setting.bgColor,
                      child : const Center(
                      child: CircularProgressIndicator(color: Setting.primaryColor,),
                    )),
                  );
                
              },
            )
          ));
              },
          );
      },
    );
  }
}

