import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsscourses/core/vimeo.dart';
import 'package:tsscourses/data/models/requests/login_request.dart';
import 'package:tsscourses/data/models/requests/logout_request.dart';
import 'package:tsscourses/domain/entities/account.dart';
import 'package:tsscourses/domain/entities/formation.dart';
import 'package:tsscourses/domain/entities/login.dart';
import 'package:tsscourses/domain/entities/message.dart';
import 'package:tsscourses/domain/usercases/data_use_case.dart';

final dataViewModelProvider = Provider.autoDispose<DataViewModel>((ref) => DataViewModel(ref.read(dataUseCaseProvider)));

class DataViewModel {

  final DataUseCase _useCase;

  DataViewModel(this._useCase);

  Future<Login> setLogin(LoginRequest request) {
    return _useCase.setLogin(request);
  } 

  Future<Message> setLogout(LogoutRequest request) {
    return _useCase.setLogout(request);
  }  

  Future<Message> setCheck(LogoutRequest request) {
    return _useCase.setCheck(request);
  }  

  Future<List<Formation>> getFreeCourses() {
    return _useCase.getFreeCourses();
  } 

  Future<List<Formation>> getMyCourses() {
    return _useCase.getMyCourses();
  }  

  Future<List<Account>> getMyAccount() {
    return _useCase.getMyAccount();
  }  

  Future<Vimeo> getVimeo(String request) {
    return _useCase.getVimeo(request);
  } 

  Future<Message> setCompleteTopic(int course, int lesson, int topic) {
    return _useCase.setCompleteTopic(course, lesson, topic);
  } 

  Future<Message> setStartTopic(int course, int lesson, int topic) {
    return _useCase.setStartTopic(course, lesson, topic);
  } 

}