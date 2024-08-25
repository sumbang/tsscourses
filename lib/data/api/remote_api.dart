import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tsscourses/core/api_response_box.dart';
import 'package:tsscourses/core/refresh_singleton.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/core/vimeo.dart';
import 'package:tsscourses/data/models/requests/login_request.dart';
import 'package:tsscourses/data/models/requests/logout_request.dart';
import 'package:tsscourses/data/models/responses/account_response.dart';
import 'package:tsscourses/data/models/responses/formation_response.dart';
import 'package:tsscourses/data/models/responses/login_response.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:tsscourses/data/models/responses/message_response.dart';


final remoteApiProvider = Provider<RemoteApi>((ref) => RemoteApi());

class RemoteApi  {

  static const String url = 'https://tssperformance.com/gestion/api/v2';
  static const String vimeoUrl = 'https://api.vimeo.com/videos';
  static const String vimeoApiKey = String.fromEnvironment("API_KEY_VIMEO");

  Future<LoginResponse> setLogin(LoginRequest request) async {

    try { 
      final response = await Dio().put('$url/comptes/login', data: request.toMap(),options: Options(headers: {'Content-Type':'application/json'}, ));
      return LoginResponse.fromJson(response.data);
    }
    
    on DioError  catch(err) { throw MessageResponse.fromJson(err.response?.data); }   
    
    on SocketException  catch(err) { throw const MessageResponse(message: 'Please check your connection');  }

  }

  Future<MessageResponse> setLogout(LogoutRequest request) async {

    try { 
      final response = await Dio().put('$url/comptes/logout', data: request.toMap(),  options: Options(headers: {'Content-Type':'application/json'}, ),); 
      return MessageResponse.fromJson(response.data);
    }

  on DioError  catch(err) {  throw MessageResponse.fromJson(err.response?.data); }   

    on SocketException  catch(err) { throw const MessageResponse(message: 'Please check your connection');  } 

  }

  Future<MessageResponse> setCheck(LogoutRequest request) async {

    try { 
      final response = await Dio().put('$url/comptes/check', data: request.toMap(),  options: Options(headers: {'Content-Type':'application/json'}, ),); 
      return MessageResponse.fromJson(response.data);
    }

  on DioError  catch(err) {  throw MessageResponse.fromJson(err.response?.data); }   

    on SocketException  catch(err) { throw const MessageResponse(message: 'Please check your connection');  } 

  }

  Future<List<FormationResponse>> getFreeCourses() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("authKey") ?? "");
    String boxName = "free-courses";
    
    await Hive.openBox<ApiResponseBox>(boxName);  
    final box = Hive.box<ApiResponseBox>(boxName);
    final cachedResponse = box.values.firstWhere(
      (response) => response.url == '$url/comptes/free-courses',
      orElse: () {
          ApiResponseBox erreur = ApiResponseBox();
          erreur.url = "";
          erreur.timestamp = 0;
          erreur.response = "";
          return erreur;
        },
    );

    RefreshSingleton refreshSingleton = RefreshSingleton();

    if (cachedResponse.url.isNotEmpty && (DateTime.now().millisecondsSinceEpoch - cachedResponse.timestamp < Setting.cacheTimeout)  ) {
      final results = List<Map<String, dynamic>>.from(json.decode(cachedResponse.response));
      return results.map((e) => FormationResponse.fromJson(e)).toList();
    }

    else {

      try { 
      
        final response = await Dio().get('$url/comptes/free-courses', options: Options(headers: {'Authorization': 'Bearer $token','Content-Type':'application/json'}, ),);
        final results = List<Map<String, dynamic>>.from(response.data);
        
        if(results.isNotEmpty) {
          final newResponse = ApiResponseBox()
            ..url = '$url/comptes/free-courses'
            ..response = json.encode(response.data)
            ..timestamp = DateTime.now().millisecondsSinceEpoch;

          await box.add(newResponse);
          refreshSingleton.setRefresh(false);
          return results.map((e) => FormationResponse.fromJson(e)).toList();
        }
        
        return [];

      }
      on DioError  catch(err) { throw MessageResponse.fromJson(err.response?.data); }   

      on SocketException  catch(err) { throw const MessageResponse(message: 'Please check your connection');  } 
    
    } 

  }

  Future<List<FormationResponse>> getMyCourses() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("authKey") ?? "");
    String boxName = "my-courses";
    
    await Hive.openBox<ApiResponseBox>(boxName);  
    final box = Hive.box<ApiResponseBox>(boxName);
    final cachedResponse = box.values.firstWhere(
      (response) => response.url == '$url/comptes/my-courses',
      orElse: () {
          ApiResponseBox erreur = ApiResponseBox();
          erreur.url = "";
          erreur.timestamp = 0;
          erreur.response = "";
          return erreur;
        },
    );

    RefreshSingleton refreshSingleton = RefreshSingleton();

    if (cachedResponse.url.isNotEmpty && (DateTime.now().millisecondsSinceEpoch - cachedResponse.timestamp < Setting.cacheTimeout)  ) {
      final results = List<Map<String, dynamic>>.from(json.decode(cachedResponse.response));
      print("ici");
      return results.map((e) => FormationResponse.fromJson(e)).toList();
    }

    else {

      try { 
      
        final response = await Dio().get('$url/comptes/my-courses', options: Options(headers: {'Authorization': 'Bearer $token','Content-Type':'application/json'}, ),);
        final results = List<Map<String, dynamic>>.from(response.data);
        
        if(results.isNotEmpty) {
          final newResponse = ApiResponseBox()
            ..url = '$url/comptes/my-courses'
            ..response = json.encode(response.data)
            ..timestamp = DateTime.now().millisecondsSinceEpoch;
          await box.add(newResponse);
          refreshSingleton.setRefresh(false);
          return results.map((e) => FormationResponse.fromJson(e)).toList();
        }
        
        return [];

      }
      on DioError  catch(err) { throw MessageResponse.fromJson(err.response?.data); }   

      on SocketException  catch(err) { throw const MessageResponse(message: 'Please check your connection');  } 
    
    } 

  }

  Future<List<AccountResponse>> getMyAccount() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("authKey") ?? "");
    String boxName = "account";
    
    await Hive.openBox<ApiResponseBox>(boxName);  
    final box = Hive.box<ApiResponseBox>(boxName);
    final cachedResponse = box.values.firstWhere(
      (response) => response.url == '$url/comptes/my-account',
      orElse: () {
          ApiResponseBox erreur = ApiResponseBox();
          erreur.url = "";
          erreur.timestamp = 0;
          erreur.response = "";
          return erreur;
        },
    );

    RefreshSingleton refreshSingleton = RefreshSingleton();

    if (cachedResponse.url.isNotEmpty && (DateTime.now().millisecondsSinceEpoch - cachedResponse.timestamp < Setting.cacheTimeout)  ) {
      final results = List<Map<String, dynamic>>.from(json.decode(cachedResponse.response));
      return results.map((e) => AccountResponse.fromJson(e)).toList();
    }

    else {

      try { 
      
        final response = await Dio().get('$url/comptes/my-account', options: Options(headers: {'Authorization': 'Bearer $token','Content-Type':'application/json'}, ),);
        final results = List<Map<String, dynamic>>.from(response.data);
        
        if(results.isNotEmpty) {
          final newResponse = ApiResponseBox()
            ..url = '$url/comptes/my-account'
            ..response = json.encode(response.data)
            ..timestamp = DateTime.now().millisecondsSinceEpoch;

          await box.add(newResponse);
          refreshSingleton.setRefresh(false);
          return results.map((e) => AccountResponse.fromJson(e)).toList();
        }
        
        return [];

      }
      on DioError  catch(err) { throw MessageResponse.fromJson(err.response?.data); }   

      on SocketException  catch(err) { throw const MessageResponse(message: 'Please check your connection');  } 
    
    } 

  }

  Future<MessageResponse> setStartTopic(int course, int lesson, int topic) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("authKey") ?? "");

    try { 
      final response = await Dio().get('$url/comptes/start-topic?course=$course&lesson=$lesson&topic=$topic',  options: Options(headers: {'Authorization': 'Bearer $token','Content-Type':'application/json'}, ),); 
      return MessageResponse.fromJson(response.data);
    }

  on DioError  catch(err) {  throw MessageResponse.fromJson(err.response?.data); }   

    on SocketException  catch(err) { throw const MessageResponse(message: 'Please check your connection');  } 

  }

  Future<MessageResponse> setCompleteTopic(int course, int lesson, int topic) async {
    
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("authKey") ?? "");

    try { 
      final response = await Dio().get('$url/comptes/complete-topic?course=$course&lesson=$lesson&topic=$topic',  options: Options(headers: {'Authorization': 'Bearer $token','Content-Type':'application/json'}, ),); 
      return MessageResponse.fromJson(response.data);
    }

  on DioError  catch(err) {  throw MessageResponse.fromJson(err.response?.data); }   

    on SocketException  catch(err) { throw const MessageResponse(message: 'Please check your connection');  } 

  }

  Future<Vimeo> getVimeoData(String video ) async {

    try { 
      final response = await Dio().get('$vimeoUrl/$video',  options: Options(headers: {'Authorization': 'Bearer $vimeoApiKey','Content-Type':'application/json'}, ),); 
      return Vimeo.fromJson(response.data);
    }

  on DioError  catch(err) {  throw MessageResponse.fromJson(err.response?.data); }   

    on SocketException  catch(err) { throw const MessageResponse(message: 'Please check your connection');  } 

  }


}