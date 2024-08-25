import 'package:equatable/equatable.dart';
import 'package:tsscourses/domain/entities/lesson.dart';

class Formation extends Equatable {

  final int id;
  final String titre;
  final String resume;
  final String banner;
  final int lessons;
  final int chapitres;
  final List<Lesson> contenus;

  const Formation({
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
    contenus
  ];

}