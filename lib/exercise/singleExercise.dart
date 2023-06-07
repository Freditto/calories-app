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
            '20 seconds',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          
          ),

          SizedBox(
            height: 30,
          ),

          MaterialButton(
            elevation: 0,
            color: Colors.green,
            height: 50,
            minWidth: 500,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onPressed: () {
              
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
        ],
      ),
    );
  }
}
