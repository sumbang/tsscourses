import 'package:equatable/equatable.dart';
import 'package:tsscourses/domain/entities/account.dart';

class AccountResponse extends Equatable {

  final String id;
  final String titre;

  const AccountResponse({
    required this.id,
    required this.titre
  });
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    titre,
  ];

  factory AccountResponse.fromJson(Map<String, dynamic> json) =>
      AccountResponse(
        id: json['id'] , 
        titre: (json['titre'] == null) ? "" : json['titre']
  );


  Account toEntity() {
    return Account(
      id: id, 
      titre: titre
    );
  }


}