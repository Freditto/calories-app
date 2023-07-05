import 'dart:async';

import 'package:calorie_calculator/utils/constant.dart';
import 'package:flutter/material.dart';

class SingleExerciseScreen extends StatefulWidget {
  final String name, image;

  const SingleExerciseScreen(
    this.name,
    this.image,
  );

  @override
  State<SingleExerciseScreen> createState() => _SingleExerciseScreenState();
}

class _SingleExerciseScreenState extends State<SingleExerciseScreen> {
  int count = 60; // Initial count value
  Timer? timer;

  void startCountdown() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (count > 0) {
          count--; // Decrement the count by 1
        } else {
          timer?.cancel(); // Stop the timer when count reaches zero
        }
        
      });
    });
  }

  void restartCountdown() {
    timer?.cancel(); // Stop the timer and reset the count
    setState(() {
      count = 60; // Reset the count to the initial value
    });
    startCountdown(); // Start the countdown again
  }


  void stopCountdown() {
    timer?.cancel(); // Stop the timer and reset the count
    setState(() {
      count = 10; // Reset the count to the initial value
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Exercise'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage(widget.image),
                )),
            height: 300.0,
            width: 300.0,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            widget.name,
            textAlign: TextAlign.left,
            style: kTitleText,
            maxLines: 4,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            '$count' + ' seconds',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                elevation: 0,
                color: Colors.green,
                height: 50,
                // minWidth: 100,
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onPressed: () {
                  startCountdown();

                  // _login();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ProfileFormScreen(),
                  //   ),
                  // );
                },
                child: const Text(
                  'Start Exercise',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              SizedBox(width: 10,),

               MaterialButton(
                elevation: 0,
                color: Colors.orange,
                height: 50,
                // minWidth: 100,
                shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                onPressed: () {
                  restartCountdown();

                  // _login();
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ProfileFormScreen(),
                  //   ),
                  // );
                },
                child: const Text(
                  'Restart Exercise',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
