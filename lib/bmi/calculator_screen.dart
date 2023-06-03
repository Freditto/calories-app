import 'package:calorie_calculator/bmi/ReusableContainer.dart';
import 'package:calorie_calculator/bmi/constants.dart';
import 'package:calorie_calculator/bmi/inputpage.dart';
import 'package:flutter/material.dart';

class Result_screen extends StatelessWidget {
  Result_screen({super.key, 
    @required this.bmiResult,
    @required this.interpretaition,
    @required this.resultText,
  });
  String? bmiResult;
  String? resultText;
  String? interpretaition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BMI CALCULATOR"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(left: 10, top: 10),
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Your result",
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
              flex: 10,
              child: ReusableContainer(
                colour: my_active_color,
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        resultText!.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow),
                      ),
                    ),
                    Center(
                      child: Text(
                        bmiResult!,
                        style: const TextStyle(
                          fontSize: 100,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      interpretaition!.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )),
          BottomButton(
            onTap: () {
              Navigator.pop(context);
            },
            buttonTitle: "Re-Enter",
          )
        ],
      ),
    );
  }
}
