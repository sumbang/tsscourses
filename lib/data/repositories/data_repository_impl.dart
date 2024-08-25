import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsscourses/core/vimeo.dart';
import 'package:tsscourses/data/api/remote_api.dart';
import 'package:tsscourses/data/models/requests/login_request.dart';
import 'package:tsscourses/data/models/requests/logout_request.dart';
import 'package:tsscourses/domain/entities/account.dart';
import 'package:tsscourses/domain/entities/formation.dart';
import 'package:tsscourses/domain/entities/login.dart';
import 'package:tsscourses/domain/entities/message.dart';
import 'package:tsscourses/domain/repositories/data_repository.dart';

final dataRepositoryProvider = Provider<DataRepository>((ref) => DataRepositoryImpl(ref.read(remoteApiProvider)));

class DataRepositoryImpl extends DataRepository {

  final RemoteApi _remoteApi;

  DataRepositoryImpl(this._remoteApi);

  @override
  Future<Login> setLogin({required LoginRequest request}) {
    return _remoteApi.setLogin(request).then((value) => value.toEntity());
  }

  @override
  Future<Message> setLogout({required LogoutRequest request}) {
    return _remoteApi.setLogout(request).then((value) => value.toEntity());
  }

  @override
  Future<Message> setCheck({required LogoutRequest request}) {
    return _remoteApi.setCheck(request).then((value) => value.toEntity());
  }

  @override
  Future<List<Formation>> getFreeCourses() {
     return _remoteApi.getFreeCourses().then((value) => value.map((e) => e.toEntity()).toList());
  }

  @override
  Future<List<Formation>> getMyCourses() {
     return _remoteApi.getMyCourses().then((value) => value.map((e) => e.toEntity()).toList());
  }

  @override
  Future<List<Account>> getMyAccount() {
   return _remoteApi.getMyAccount().then((value) => value.map((e) => e.toEntity()).toList());
  }

  @override
  Future<Vimeo> getVimeoData({required String video}) {
    return _remoteApi.getVimeoData(video).then((value) => value);
  }

  @override
  Future<Message> setCompleteTopic({required int course, required int lesson, required int topic}) {
    return _remoteApi.setCompleteTopic(course, lesson, topic).then((value) => value.toEntity());
  }

  @override
  Future<Message> setStartTopic({required int course, required int lesson, required int topic}) {
    return _remoteApi.setStartTopic(course, lesson, topic).then((value) => value.toEntity());
  }




}