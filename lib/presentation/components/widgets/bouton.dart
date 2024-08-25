import 'package:flutter/material.dart';

class Bouton extends StatelessWidget {

final String texte;
final Color background;
final Color couleur;
final VoidCallback onTap;


  const Bouton({
    required this.texte,
    required this.couleur,
    required this.background,
    required this.onTap
  }): super();
  
  @override
  Widget build(BuildContext context) {
    
    return  Padding(
                padding: const EdgeInsets.all(0.0),
                child:  Center(
                  child:  InkWell(
                    onTap: onTap,
                    child:  Container(
                      width: 200.0,
                      height: 50.0,
                      decoration:  BoxDecoration(
                        color: background,
                        border:  Border.all(color: Colors.transparent, width: 2.0),
                        borderRadius:  BorderRadius.circular(10.0),
                      ),
                      child:  Center(
                        child:  Text(
                          texte,
                          style:  TextStyle(
                              fontFamily: 'Candara',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              color: couleur),
                        ),
                      ),
                    ),
                  ),
                ));
  }


}