
import 'package:equatable/equatable.dart';

class SignupRequest extends Equatable {

  final String nom;
  final String prenom;
  final String email;
  final String password;
  final String phone;
  final String login;


  const SignupRequest({
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.phone,
    required this.login,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    nom,
    prenom,
    email,
    password,
    login,
    phone
  ];

  Map<String, dynamic> toMap() {
    final queryParameters = {
      'nom':nom,
      'prenom':prenom,
      'email':email,
      'password':password,
      'login':login,
      'phone':phone
    };
    return queryParameters;
  }


}