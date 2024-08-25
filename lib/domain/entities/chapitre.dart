
import 'package:equatable/equatable.dart';

class Chapitre extends Equatable {

  final String id;
  final String titre;
  final String video;
  final List<String> students;

  const Chapitre ({
    required this.id,
    required this.titre,
    required this.students,
    required this.video
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    titre,
    video,
    students
  ];

}