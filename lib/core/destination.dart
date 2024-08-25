import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Destination  extends Equatable  {

  const Destination(this.title, this.icon, this.color);
  final String title;
  final IconData icon;
  final Color color;
  
  @override
  // TODO: implement props
  List<Object?> get props => [
    title,
    icon
  ];

}
