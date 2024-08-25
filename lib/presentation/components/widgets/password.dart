import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsscourses/presentation/components/view_models/password_state.dart';
import 'package:tsscourses/presentation/components/view_models/password_view_model.dart';

class Password extends HookConsumerWidget {

final String label;
final Color background;
final TextEditingController controller;
final Icon icon;
final PasswordState state;
final Color labelColor;

  const Password({
    required this.label,
    required this.background,
    required this.controller,
    required this.icon,
    required this.state,
    required this.labelColor
  }): super();
  
  @override
  Widget build(BuildContext context,ref) {
    
    return   Padding(
              padding: const EdgeInsets.all(0.0),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 3.0, bottom: 3.0),
                width: double.infinity,
                decoration:  BoxDecoration(
                  color: background,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                     Expanded(
                      flex: 7,
                      child: TextFormField(
                        obscureText: state.status,
                        style:  TextStyle(
                            fontFamily: 'Candara',
                            color: labelColor,
                            fontWeight: FontWeight.normal),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          icon: icon,
                          labelText: label,
                          labelStyle:  TextStyle(
                              color: labelColor,
                              fontSize: 16.0,
                              fontFamily: 'Candara',
                              fontWeight: FontWeight.normal),
                        ),
                        controller: controller,
                      ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 0.0, right: 0.0, bottom: 0.0, top: 15.0),
                        child: GestureDetector(
                          onTap: () {
                           if(ref.watch(passwordViewModelProvider).status == true) {
                             ref.read(passwordViewModelProvider.notifier).submitAnswer(false);
                           } else {
                             ref.read(passwordViewModelProvider.notifier).submitAnswer(true);
                           }
                          },
                          child: (ref.watch(passwordViewModelProvider).status == true) ?  Icon(
                            Icons.visibility_off_outlined,
                            color: labelColor,
                          ) :  Icon(
                            Icons.visibility_outlined,
                            color: labelColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
  }


}