import 'package:equatable/equatable.dart';

class Lesson extends Equatable {

  final String id;
  final String titre;
  final String resume;
  final int chapitre;
  final int debut;
  final String debutread;
  final String ecart;
  final int actuel;
  final int level;
  final String statut;

  const Lesson({
    required this.id,
    required this.titre,
    required this.resume,
    required this.chapitre,
    required this.debut,
    required this.debutread,
    required this.ecart,
    required this.actuel,
    required this.level,
    required this.statut
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    titre,
    chapitre,
    resume,
    debut,
    debutread,
    statut,
    ecart,
    actuel,
    level
  ];

}