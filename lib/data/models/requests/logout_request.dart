
import 'package:equatable/equatable.dart';

class LogoutRequest extends Equatable {

  final String token;

  const LogoutRequest({
    required this.token,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    token
  ];

  Map<String, dynamic> toMap() {
    final queryParameters = {
      'token':token
    };
    return queryParameters;
  }


}