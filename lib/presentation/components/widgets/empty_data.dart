import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsscourses/core/setting.dart';

class EmptyData extends HookConsumerWidget {


@override
Widget build(BuildContext context, WidgetRef ref) {

  return  const Center(
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.school_sharp,
                            color: Setting.primaryColor,
                            size: 140,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Candara',
                                      fontSize: 17.0,
                                      color: Colors.black)),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  );

}

}