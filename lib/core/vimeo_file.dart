import 'package:equatable/equatable.dart';

class VimeoFile  extends Equatable  {

  final String quality;
  final String rendition;
  final int width;
  final int height;
  final String type;
  final String link;
  final String publicName;
  final String sizeShort;
  final String expires;

  const VimeoFile(
      {required this.quality,
      required this.rendition,
      required this.width,
      required this.height,
      required this.type,
      required this.link,
      required this.publicName,
      required this.sizeShort,
      required this.expires
    });

  @override
  // TODO: implement props
  List<Object?> get props => [
    quality,
    link,
    publicName,
    sizeShort
  ];


  factory VimeoFile.fromJson(Map<String, dynamic> json) =>
      VimeoFile(
        quality: json['quality'] , 
        rendition:  json['rendition'] , 
        width:  json['width'] , 
        height:  json['height'] , 
        type:  json['type'] , 
        link:  json['link'] ,
        publicName:  json['public_name'] , 
        sizeShort:  json['size_short'] ,  
        expires:  json['expires'] , 
  );


}