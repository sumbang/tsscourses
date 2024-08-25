import 'package:equatable/equatable.dart';
import 'package:tsscourses/domain/entities/chapitre.dart';

class ChapitreResponse extends Equatable {

  final String id;
  final String titre;
  final String video;
  final List<String> students;

  const ChapitreResponse({
    required this.id,
    required this.titre,
    required this.video,
    required this.students
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    titre,
    video,
    students
  ];

  factory ChapitreResponse.fromJson(Map<String, dynamic> json) =>
      ChapitreResponse(
        id: json['chapitre_id'] , 
        titre: (json['chapitre_titre'] == null) ? "" : json['chapitre_titre'], 
        video: (json['chapitre_video'] == null) ? "" : json['chapitre_video'], 
        students: List<String>.from(json["has_completed"].map((x) => x)),
  );


  Chapitre toEntity() {
    return Chapitre(
      id: id, 
      titre: titre, 
      students : students,
      video: video
    );
  }


}