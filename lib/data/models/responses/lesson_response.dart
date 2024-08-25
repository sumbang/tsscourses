import 'package:equatable/equatable.dart';
import 'package:tsscourses/data/models/responses/chapitre_response.dart';
import 'package:tsscourses/domain/entities/chapitre.dart';
import 'package:tsscourses/domain/entities/lesson.dart';

class LessonResponse extends Equatable {

  final String id;
  final String titre;
  final List<ChapitreResponse> chapitres;
  bool expanded;

 LessonResponse({
    required this.id,
    required this.titre,
    required this.chapitres,
    this.expanded = false
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    titre,
    chapitres
  ];

  factory LessonResponse.fromJson(Map<String, dynamic> json) =>
      LessonResponse(
        id: json['lesson_id'] , 
        titre: (json['lesson_title'] == null) ? "" : json['lesson_title'], 
        chapitres: List<ChapitreResponse>.from(json["lesson_chapitre"].map((x) => ChapitreResponse.fromJson(x))),
  );


  Lesson toEntity() {
    return Lesson(
      id: id, 
      titre: titre, 
      chapitres : List<Chapitre>.from(chapitres.map((x) => x.toEntity())),
      expanded: expanded
    );
  }


}