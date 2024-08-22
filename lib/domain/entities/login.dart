import 'package:equatable/equatable.dart';

class Login extends Equatable {

  final String id;
  final String username;
  final String email;
  final int statut;
  final String nom;
  final String authkey;
  final int abonnement;

  const Login({
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

}