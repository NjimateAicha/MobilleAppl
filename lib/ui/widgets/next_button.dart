import 'package:flutter/material.dart';
import 'package:moroccan_explorer/model/constants.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key});
  // final VoidCallback nextQuestion;

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: neutral,
          borderRadius: BorderRadius.circular(10.0),
      
        ),
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: const Text(
          "Next Question",
         textAlign:TextAlign.center,
         style : TextStyle(fontSize: 18.0)),
      
    );
  }
}