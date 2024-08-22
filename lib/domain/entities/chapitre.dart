
import 'package:equatable/equatable.dart';

class Chapitre extends Equatable {

  final String id;
  final String titre;
  final String resume;
  final String video;
  final int statut;
  final int  activite;

  const Chapitre ({
    required this.id,
    required this.titre,
    required this.resume,
    required this.video,
    required this.activite,
    required this.statut
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    titre,
    video,
    resume,
    statut,
    activite,
  ];

}