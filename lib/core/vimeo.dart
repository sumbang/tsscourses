import 'package:equatable/equatable.dart';
import 'package:tsscourses/core/vimeo_file.dart';

class Vimeo extends Equatable {

  final String name;
  final List<VimeoFile> files;
  final List<VimeoFile> download;

  const Vimeo({
    required this.name,
    required this.files,
    required this.download
  });

    @override
  // TODO: implement props
  List<Object?> get props => [
    name,
    files,
    download
  ];


 factory Vimeo.fromJson(Map<String, dynamic> json) =>
      Vimeo(
        name: json['name'] , 
        files: List<VimeoFile>.from(json["files"].map((x) => VimeoFile.fromJson(x))),
        download: List<VimeoFile>.from(json["download"].map((x) => VimeoFile.fromJson(x))),
  );

}