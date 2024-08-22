import 'package:equatable/equatable.dart';
import 'package:tsscourses/domain/entities/lesson.dart';

class LessonResponse extends Equatable {

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

  const LessonResponse({
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

  factory LessonResponse.fromJson(Map<String, dynamic> json) =>
      LessonResponse(
        id: json['id'] , 
        titre: (json['titre'] == null) ? "" : json['titre'], 
        resume: (json['resume'] == null) ? "" :json['resume'], 
        chapitre: (json['chapitre'] == null) ? 0 :json['chapitre'], 
        debut: (json['debut'] == null) ? 0 :json['debut'], 
        debutread: (json['debutread'] == null) ? 0 :json['debutread'], 
        statut: (json['statut'] == null) ? "" :json['statut'], 
        ecart: (json['ecart'] == null) ? "" :json['ecart'], 
        level: (json['level'] == null) ? 0 :json['level'],
        actuel: (json['actuel'] == null) ? 0 :json['actuel']
  );


  Lesson toEntity() {
    return Lesson(
      id: id, 
      titre: titre, 
      resume : resume,
      chapitre : chapitre,
      debut: debut,
      debutread: debutread,
      statut: statut,
      level: level,
      actuel: actuel,
      ecart: ecart
    );
  }


}