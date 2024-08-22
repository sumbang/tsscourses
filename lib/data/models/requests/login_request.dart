
import 'package:equatable/equatable.dart';

class LoginRequest extends Equatable {

  final String login;
  final String password;

  const LoginRequest({
    required this.login,
    required this.password
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    login,
    password
  ];

  Map<String, dynamic> toMap() {
    final queryParameters = {
      'login':login,
      'password':password
    };
    return queryParameters;
  }


}