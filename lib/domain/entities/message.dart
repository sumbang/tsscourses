import 'package:equatable/equatable.dart';

class Message extends Equatable {

  final String message;
  
  const Message({
    required this.message
  });

    @override
  // TODO: implement props
  List<Object?> get props => [
   message
  ];

}