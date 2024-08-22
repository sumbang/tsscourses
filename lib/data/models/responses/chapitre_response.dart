import 'package:equatable/equatable.dart';
import 'package:tsscourses/domain/entities/chapitre.dart';

class ChapitreResponse extends Equatable {

  final String id;
  final String titre;
  final String resume;
  final String video;
  final int statut;
  final int  activite;

  const ChapitreResponse({
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

  factory ChapitreResponse.fromJson(Map<String, dynamic> json) =>
      ChapitreResponse(
        id: json['id'] , 
        titre: (json['titre'] == null) ? "" : json['titre'], 
        resume: (json['resume'] == null) ? "" :json['resume'], 
        video: (json['video'] == null) ? "" :json['video'], 
        activite: (json['activite'] == null) ? 0 :json['activite'], 
        statut: (json['statut'] == null) ? "" :json['statut'], 
  );


  Chapitre toEntity() {
    return Chapitre(
      id: id, 
      titre: titre, 
      resume : resume,
      activite : activite,
      statut: statut,
      video: video
    );
  }


}