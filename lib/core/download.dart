import 'package:equatable/equatable.dart';

class Download  extends Equatable  {
  final int id;
  final String titre;
  final String description;
  final int categorie;
  final String taskid;
  final String lien;
  final String filename;
  final int statut;
  final int movie;

  Download(
      {required this.id,
      required this.titre,
      required this.description,
      required this.categorie,
      required this.taskid,
      required this.lien,
      required this.filename,
      required this.statut,
      required this.movie});

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    titre,
    lien,
    filename
  ];


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titre': titre,
      'description': description,
      'categorie': categorie,
      'taskid': taskid,
      'lien': lien,
      'filename': filename,
      'statut': statut,
      'movie': movie
    };
  }

  @override
  String toString() {
    return 'Download{id: $id, titre: $titre, categorie: $categorie}';
  }
}