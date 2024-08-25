import 'package:equatable/equatable.dart';
import 'package:tsscourses/domain/entities/formation.dart';
import 'package:tsscourses/domain/entities/lesson.dart';

import 'lesson_response.dart';

class FormationResponse extends Equatable {

  final int id;
  final String titre;
  final String resume;
  final String banner;
  final int lessons;
  final int chapitres;
  final List<LessonResponse> contenus;

  const FormationResponse({
    required this.id,
    required this.titre,
    required this.resume,
    required this.banner,
    required this.lessons,
    required this.chapitres,
    required this.contenus
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
    lessons
  ];


 factory FormationResponse.fromJson(Map<String, dynamic> json) =>
      FormationResponse(
        id: json['course_id'] , 
        titre: (json['course_title'] == null) ? "" : json['course_title'], 
        resume: (json['course_resume'] == null) ? "" :json['course_resume'], 
        banner: (json['course_banner'] == null) ? "" :json['course_banner'], 
        lessons: (json['course_lesson'] == null) ? 0 :json['course_lesson'], 
        chapitres: (json['course_chapitre'] == null) ? 0 :json['course_chapitre'], 
        contenus: List<LessonResponse>.from(json["course_json"].map((x) => LessonResponse.fromJson(x))),
  );


  Formation toEntity() {
    return Formation(
      id: id, 
      titre: titre, 
      resume : resume,
      banner : banner,
      lessons: lessons,
      chapitres: chapitres,
      contenus: List<Lesson>.from(contenus.map((x) => x.toEntity())),
    );
  }


}