import 'package:equatable/equatable.dart';

class VimeoFile  extends Equatable  {

  final String quality;
  final String link;
  final String publicName;
  final String sizeShort;

  const VimeoFile(
      {required this.quality,
      required this.link,
      required this.publicName,
      required this.sizeShort,
    });

  @override
  // TODO: implement props
  List<Object?> get props => [
    quality,
    publicName,
    sizeShort
  ];


  factory VimeoFile.fromJson(Map<String, dynamic> json) =>
      VimeoFile(
        quality: json['quality'] , 
        link:  json['link'] ,
        publicName:  json['public_name'] , 
        sizeShort:  json['size_short'] ,  
  );


}