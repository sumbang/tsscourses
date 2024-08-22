import 'package:equatable/equatable.dart';
import 'package:tsscourses/domain/entities/formation.dart';

class FormationResponse extends Equatable {

  final String id;
  final String titre;
  final String resume;
  final String banner;
  final int lessons;
  final int chapitres;
  final int statut;
  final int finish;

  const FormationResponse({
    required this.id,
    required this.titre,
    required this.resume,
    required this.banner,
    required this.lessons,
    required this.chapitres,
    required this.statut,
    required this.finish
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    titre,
    banner,
    resume,
    lessons,
    chapitres,
    statut,
    finish
  ];


 factory FormationResponse.fromJson(Map<String, dynamic> json) =>
      FormationResponse(
        id: json['id'] , 
        titre: (json['titre'] == null) ? "" : json['titre'], 
        resume: (json['resume'] == null) ? "" :json['resume'], 
        banner: (json['banner'] == null) ? "" :json['banner'], 
        lessons: (json['lessons'] == null) ? 0 :json['lessons'], 
        chapitres: (json['chapitres'] == null) ? 0 :json['chapitres'], 
        statut: (json['statut'] == null) ? 0 :json['statut'], 
        finish: (json['finish'] == null) ? 0 :json['finish']
  );


  Formation toEntity() {
    return Formation(
      id: id, 
      titre: titre, 
      resume : resume,
      banner : banner,
      lessons: lessons,
      chapitres: chapitres,
      statut: statut,
      finish: finish
    );
  }


}