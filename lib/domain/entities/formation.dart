import 'package:equatable/equatable.dart';

class Formation extends Equatable {

  final String id;
  final String titre;
  final String resume;
  final String banner;
  final int lessons;
  final int chapitres;
  final int statut;
  final int finish;

  const Formation({
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

}