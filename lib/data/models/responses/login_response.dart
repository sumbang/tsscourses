import 'package:equatable/equatable.dart';
import 'package:tsscourses/domain/entities/login.dart';

class LoginResponse extends Equatable {

  final String id;
  final String username;
  final String email;
  final int statut;
  final String nom;
  final String authkey;
  final int abonnement;

  const LoginResponse({
    required this.id,
    required this.nom,
    required this.username,
    required this.email,
    required this.statut,
    required this.authkey,
    required this.abonnement,
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    nom,
    username,
    statut,
    email,
    authkey,
    abonnement,
    email
  ];


 factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      LoginResponse(
        id: json['id'] , 
        username: json['username'], 
        nom: json['nom'], 
        statut: json['statut'], 
        abonnement: json['abonnement'], 
        authkey: json['authkey'],
        email: json['email']
  );


  Login toEntity() {
    return Login(
      id: id, 
      username: username, 
      nom : nom,
      authkey:authkey,
      abonnement: abonnement,
      email:email,
      statut: statut
      );
  }


}