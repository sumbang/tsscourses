import 'package:equatable/equatable.dart';

class Account extends Equatable {

  final String id;
  final String titre;

  const Account({
    required this.id,
    required this.titre
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    titre,
  ];

}