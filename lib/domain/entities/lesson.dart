import 'package:equatable/equatable.dart';
import 'package:tsscourses/domain/entities/chapitre.dart';

class Lesson extends Equatable {

  final String id;
  final String titre;
  final List<Chapitre> chapitres;
  bool expanded;

   Lesson({
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
    chapitres,
    expanded
  ];


}