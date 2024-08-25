import 'package:tsscourses/core/vimeo.dart';
import 'package:tsscourses/data/models/requests/login_request.dart';
import 'package:tsscourses/data/models/requests/logout_request.dart';
import 'package:tsscourses/domain/entities/account.dart';
import 'package:tsscourses/domain/entities/formation.dart';
import 'package:tsscourses/domain/entities/login.dart';
import 'package:tsscourses/domain/entities/message.dart';

abstract class DataRepository {

   Future<Login> setLogin({required LoginRequest request});

   Future<Message> setLogout({required LogoutRequest request});

   Future<Message> setCheck({required LogoutRequest request});

   Future<List<Formation>> getFreeCourses();

   Future<List<Formation>> getMyCourses();

   Future<List<Account>> getMyAccount();

   Future<Message> setStartTopic({required int course, required int lesson, required int topic});

   Future<Message> setCompleteTopic({required int course, required int lesson, required int topic});

   Future<Vimeo> getVimeoData({required String video});

}