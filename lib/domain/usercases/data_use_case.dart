import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsscourses/core/vimeo.dart';
import 'package:tsscourses/data/models/requests/login_request.dart';
import 'package:tsscourses/data/models/requests/logout_request.dart';
import 'package:tsscourses/data/repositories/data_repository_impl.dart';
import 'package:tsscourses/domain/entities/account.dart';
import 'package:tsscourses/domain/entities/formation.dart';
import 'package:tsscourses/domain/entities/login.dart';
import 'package:tsscourses/domain/entities/message.dart';
import 'package:tsscourses/domain/repositories/data_repository.dart';

final dataUseCaseProvider = Provider<DataUseCase>((ref) => DataUseCase(ref.read(dataRepositoryProvider)));

class DataUseCase { 

  DataUseCase(this._repository);

  final DataRepository _repository;

  Future<Login> setLogin(LoginRequest loginRequest) {
    return _repository.setLogin(request: loginRequest);
  } 

  Future<Message> setLogout(LogoutRequest logoutRequest) {
    return _repository.setLogout(request: logoutRequest);
  }  

  Future<Message> setCheck(LogoutRequest logoutRequest) {
    return _repository.setCheck(request: logoutRequest);
  }  

  Future<List<Formation>> getFreeCourses() {
      return _repository.getFreeCourses();
  }

  Future<List<Formation>> getMyCourses() {
      return _repository.getMyCourses();
  }

  Future<List<Account>> getMyAccount() {
      return _repository.getMyAccount();
  }

  Future<Vimeo> getVimeo(String video) {
    return _repository.getVimeoData(video: video);
  } 

  Future<Message> setCompleteTopic(int course, int lesson, int topic) {
    return _repository.setCompleteTopic(course: course, lesson: lesson, topic: topic);
  }  

  Future<Message> setStartTopic(int course, int lesson, int topic) {
    return _repository.setStartTopic(course: course, lesson: lesson, topic: topic);
  }  

}