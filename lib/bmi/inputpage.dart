import 'package:calorie_calculator/bmi/calculator_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'ReusableCard.dart';
import 'ReusableContainer.dart';
import 'calculator_brain.dart';
import 'constants.dart';

enum Genders {
  male,
  female,
}

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Genders? sellectedGender;
  int height = 180;
  int weight = 60;
  int age = 20;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text('BMI CALCULATOR'),
        ),
        body: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ReusableContainer(
                      onPressed: () {
                        setState(() {
                          sellectedGender = Genders.male;
                        });
                      },
                      cardChild: const ReusableCard(
                        genderIcon: Icon(
                          FontAwesomeIcons.mars,
                          size: 80,
                          color: Colors.white,
                        ),
                        genderText: "MALE",
                      ),
                      colour: sellectedGender == Genders.male
                          ? my_active_color
                          : my_inactive_color,
                    ),
                  ),
                  Expanded(
                    child: ReusableContainer(
                      onPressed: () {
                        setState(() {
                          sellectedGender = Genders.female;
                        });
                      },
                      cardChild: const ReusableCard(
                        genderIcon: Icon(
                          FontAwesomeIcons.venus,
                          size: 80,
                          color: Colors.white,
                        ),
                        genderText: "FEMALE",
                      ),
                      colour: sellectedGender == Genders.female
                          ? my_active_color
                          : my_inactive_color,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ReusableContainer(
                cardChild: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: Text(
                        "HEIGHT",
                        style: lableStyle,
                      ),
                    ),
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(height.toString(), style: nubmerTextStyle),
                        const Text(
                          "cm",
                          style: lableStyle,
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        inactiveTickMarkColor: const Color(0xFF8D8E98),
                        activeTrackColor: Colors.white,
                        thumbColor: Colors.green,
                        overlayColor: Colors.greenAccent,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 15.0),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 30),
                      ),
                      child: Slider(
                        value: height.toDouble(),
                        min: 120,
                        max: 220,
                        onChanged: (double newValue) {
                          setState(() {
                            height = newValue.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                colour: my_active_color,
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ReusableContainer(
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "WEIGHT",
                            style: lableStyle,
                          ),
                          Text(
                            weight.toString(),
                            style: nubmerTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RoundedIconButton(
                                icon: Icons.add,
                                   
                                onPressed: () {
                                  setState(() {
                                    weight++;
                                  });
                                },
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              RoundedIconButton(
                                icon: Icons.minimize_sharp,
                                onPressed: () {
                                  setState(() {
                                    if (weight > 1) {
                                      weight--;
                                    }
                                  });
                                },

                              ),
                            ],
                          )
                        ],
                      ),
                      colour: my_active_color,
                    ),
                  ),
                  Expanded(
                    child: ReusableContainer(
                      colour: my_active_color,
                      cardChild: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "AGE",
                            style: lableStyle,
                          ),
                          Text(
                            age.toString(),
                            style: nubmerTextStyle,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RoundedIconButton(
                                icon: Icons.add,
                                onPressed: () {
                                  setState(() {
                                    if (age > 0) {
                                      age--;
                                    }
                                  });
                                },

                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              RoundedIconButton(
                                icon: Icons.minimize,
                                onPressed: () {
                                  setState(() {
                                    age--;
                                  });
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            BottomButton(
              onTap: () {
                Calculator_brain calc =
                    Calculator_brain(height: height, weight: weight);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Result_screen(
                        bmiResult: calc.calculateBMI(),
                        interpretaition: calc.getInterpretaition(),
                        resultText: calc.getResult()),
                  ),
                );
              },
              buttonTitle: "Result",
            ),
          ],
        ));
  }
}

class BottomButton extends StatelessWidget {
  const BottomButton({super.key, this.buttonTitle, this.onTap});
  final VoidCallback? onTap;
  final String? buttonTitle;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: bottom_container_color,
        margin: const EdgeInsets.only(top: 10),
        width: double.infinity,
        height: 80,
        child: Center(
            child: Text(
          buttonTitle!,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        )),
      ),
    );
  }
}

class RoundedIconButton extends StatelessWidget {
  RoundedIconButton({super.key, this.icon, this.onPressed});
  final IconData? icon;
  VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 6,
      constraints: const BoxConstraints.tightFor(
        height: 56,
        width: 56,
      ),
      shape: const CircleBorder(),
      fillColor: const Color(0xFF4C4F5E),
      onPressed: onPressed,
      child: Icon(icon, color: Colors.white,),
    );
  }
}
