import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/domain/entities/lesson.dart';

class LessonWidget extends HookConsumerWidget {

  final Lesson item;

  LessonWidget({
      required this.item
  }): super();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5,bottom: 5),
      child : Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
          const SizedBox(height: 5,),
          Align(alignment: Alignment.centerLeft, child: Text(item.titre, style:  TextStyle( color: Theme.of(context).brightness == Brightness.light ? Setting.bgColor : Setting.white, fontFamily: 'Candara', height: 1.5, fontWeight: FontWeight.bold, fontSize: 15.0),textAlign: TextAlign.left)),
          const SizedBox(height: 5,),

    ],));

  }

}