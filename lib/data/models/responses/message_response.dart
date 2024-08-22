import 'package:equatable/equatable.dart';
import 'package:tsscourses/domain/entities/message.dart';

class MessageResponse extends Equatable {

  final String message;
  
  const MessageResponse({
    required this.message
  });

    @override
  // TODO: implement props
  List<Object?> get props => [
   message
  ];

   factory MessageResponse.fromJson(Map<String, dynamic> json) =>
      MessageResponse(
        message: json['message']
  );

  Message toEntity() {
    return Message(
      message: message);
  }

}