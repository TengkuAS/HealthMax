import 'package:flutter/material.dart';
import 'package:healthmax_frontend/GeneralPages/helper_widgets.dart';

class RegistrationQuestions extends StatelessWidget {
  final int numQuestions;
  final int currentIndex;
  const RegistrationQuestions({
    super.key,
    required this.numQuestions,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Screen(
      bgDecoration: bgWhite,
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(50, 0, 50, 0),
            child: ProgressBar(current: currentIndex, countBars: numQuestions),
          ),
          const SizedBox(height: 100),
          Text(
            "Enter your Age",
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
