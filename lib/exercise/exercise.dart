import 'package:calorie_calculator/exercise/singleExercise.dart';
import 'package:calorie_calculator/utils/constant.dart';
import 'package:flutter/material.dart';

class ExersiceScreen extends StatefulWidget {
  const ExersiceScreen({super.key});

  @override
  State<ExersiceScreen> createState() => _ExersiceScreenState();
}

class _ExersiceScreenState extends State<ExersiceScreen> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
          title: const Text('DAILY EXERCISE'),
        ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            makeItem(name: "Leg Pull ups",image: 'assets/1.gif', date: 17, month: "JAN", time: "12:00"),
      
            makeItem(name: "Bicycle Crunches",image: 'assets/2.gif', date: 17, month: "JAN", time: "12:00"),
      
            makeItem(name: "Leg Raise",image: 'assets/3.gif', date: 17, month: "JAN", time: "12:00"),
      
            makeItem(name: "Mountain Climber",image: 'assets/4.gif', date: 17, month: "JAN", time: "12:00"),
      
            makeItem(name: "Crunch",image: 'assets/5.gif', date: 17, month: "JAN", time: "12:00"),
      
            makeItem(name: "Front Lunges",image: 'assets/6.gif', date: 17, month: "JAN", time: "12:00"),
          ],
        ),
      ),
    );
  }

  


    Widget makeItem({name, image, date, month, time}) {
    final mediaQuery = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return SingleExerciseScreen(
              name,
              image,
              
            );
          }),
        );
      },
      child: Container(
        // width: mediaQuery.size.width * 0.8,
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage(image),
              )),
              height: 100.0,
              width: mediaQuery.size.width * 0.4,
            ),
            const SizedBox(
              width: 20.0,
            ),
            // ignore: sized_box_for_whitespace
            Container(
              height: 120.0,
              width: mediaQuery.size.width * 0.45,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ignore: sized_box_for_whitespace
                  Text(
                    name,
                    textAlign: TextAlign.left,
                    style: kTitleText,
                    maxLines: 4,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        date.toString(),
                        style: kLabelText,
                      ),
                      const SizedBox(width: 5.0),
                      const Icon(
                        Icons.circle,
                        size: 10.0,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 5.0),
                      // Text(
                      //   '$read min',
                      //   style: kLabelText,
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

