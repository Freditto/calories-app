import 'dart:convert';
import 'dart:math';

import 'package:calorie_calculator/api/api.dart';
import 'package:calorie_calculator/auth.dart';
import 'package:calorie_calculator/calories/chart.dart';
import 'package:calorie_calculator/profile/profile.dart';
import 'package:calorie_calculator/utils/snackbar.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var userData, profileData;

  @override
  void initState() {
    checkLoginStatus();
    _getUserInfo();

    super.initState();
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  checkProfileStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });

    _getProfileInfo();
  }

  void _getProfileInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    if (localStorage.getString('profile') == null) {
      var res = await CallApi()
          .authenticatedGetRequest('get-updated-profile/${userData['id']}');
      if (res != null) {
        localStorage.setString("profile", res.body);
        var newProfile = localStorage.getString('profile');
        setState(() {
          profileData = json.decode(newProfile!);
        });
      }
    } else {
      var profileJson = localStorage.getString('profile');
      var profile = json.decode(profileJson!);
      setState(() {
        profileData = profile;
      });
    }

    recommendationCalories(context);
    recommendationExercise(context);
    todayCalories_API(context);
    viewTodayFood_API(context);
    randomize();
    randomizeE();
  }

  setPageState() {
    setState(() {});
  }

  List<String> todayFastMeals() {
    List<String> data = [];
    for (var d in todayFood) {
      data.add(d['food']);
    }
    return data;
  }

  // [
  //   "Not relevant",
  //   "Illegal",
  //   "Spam",
  //   "Offensive",
  //   "Uncivil"
  //       "Not relevant",
  //   "Illegal",
  //   "Spam",
  //   "Offensive",
  //   "Uncivil"
  //       "Not relevant",
  //   "Illegal",
  //   "Spam",
  //   "Offensive",
  //   "Uncivil"
  // ];
  var exerciseRandomize = [
    "Leg Pull ups",
    "Bicycle Crunches",
    "Leg Raise",
    "Mountain Climber",
    "Crunch",
    "Front Lunges"
  ];

  // var randomFood = [];
  // final list = ['a', 'b', 'c', 'd', 'e'];
  final random = Random();
  final randomElementsExercise = <String>[];

  void randomizeE() {
    // print("*******************");
    // print(randomElementsExercise);
    while (randomElementsExercise.length < 2) {
      final randomIndex = random.nextInt(exerciseRandomize.length);
      final randomElement = exerciseRandomize[randomIndex];

      if (!randomElementsExercise.contains(randomElement)) {
        randomElementsExercise.add(randomElement);
      }
    }
  }

  var foodToRandomize = [
    "Noodle",
    "Soup",
    "Pizza",
    "Rice",
    "Roasted meat",
    "Roasted fish",
    "Fried fish",
    "Fried chicken",
    "Banana",
    "Broccoli",
    "Salmon",
    "Brown Rice",
    "Avocado",
    "Sweet Potato",
    "Almonds",
    "Black Beans",
    "Spinach",
    "Eggs",
    "Greek Yogurt",
    "Oatmeal",
    "Rice",
    "Ugali",
    "Dough",
    "Fried fish",
    "Fried chicken",
    "Beans",
    "Coconut peas",
    "Roasted fish",
    "Roasted meat",
    "Banana meat",
    "Spinach",
    "Pilau",
    "Chips",
    "Egg chop",
    "Fried bread",
    "Chapati",
    "Sausage",
    "Frying eggs",
    "Boiled egg",
    "Sponge cake",
    "Donut",
    "Boiled cassava",
    "Coffee",
    "Tea",
    "Milk",
    "Smoothie",
    "Yogurt",
    "Coffee with milk"
  ];
  var randomFood = [];
  final list = ['a', 'b', 'c', 'd', 'e'];
  // final random = Random();
  final randomElements = <String>[];

  void randomize() {
    // print("*******************");
    // print(randomElements);
    while (randomElements.length < 2) {
      final randomIndex = random.nextInt(foodToRandomize.length);
      final randomElement = foodToRandomize[randomIndex];

      if (!randomElements.contains(randomElement)) {
        randomElements.add(randomElement);
      }
    }
  }

  List<String> selectedReportList = [];
  Map<String, String> todayCall = {'total_calories': ''};

  _showReportDialog(String data) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Today Foods"),
            content: MultiSelectChip(
              todayFastMeals(),
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  _showFoodDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("BreakFast Meals"),
            content: DropdownSearch<String>.multiSelection(
              items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
              popupProps: PopupPropsMultiSelection.menu(
                showSelectedItems: true,
                showSearchBox: true,
                disabledItemFn: (String s) => s.startsWith('I'),
              ),
              onChanged: print,
              selectedItems: ["Brazil"],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Report"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Future<List<String>> fetchFood(context) async {
    print(" Inside List of food function");
    print(profileData);

    var res = await CallApi().authenticatedGetRequest('food');

    if (res != null) {
      print("==========");
      List<String> foodItems = [];
      var b = json.decode(res.body);
      print(b.runtimeType);
      for (var data in b) {
        foodItems.add(data['name']);
      }

      return foodItems;
    } else {
      return [];
    }
  }

  Map<String, dynamic> recommendedCalories = {'calories': ''};
  Map<String, dynamic> recommendedExercise = {'name': ''};
  recommendationExercise(context) async {
    print(" Inside Exercise function");

    var res = await CallApi()
        .authenticatedGetRequest('recommendation-exercise?bmi=2');

    if (res != null) {
      var exerciseRecommended = json.decode(res.body)[0];
      setState(() {
        recommendedExercise = exerciseRecommended;
      });
      return [];
    } else {
      return [];
    }
  }

  List<Widget> ListFood() {
    List<Widget> toreturn = [];
    for (var data in todayFood) {
      toreturn.add(
        Text(
          data.toString(),
          style: TextStyle(fontSize: 18),
        ),
      );
    }
    return [];
  }

  recommendationCalories(context) async {
    print(" Inside Callories function");
    print(profileData);
    // print(userData['profile']['baseline_activity_id']);
    // print(userData['profile']['goal_id']);
    // print(userData['profile']['bmi_id']);
    var res = await CallApi().authenticatedGetRequest(
        'recommendation-calories?baseline_activity=${profileData['baseline_activity_id']}&goal=${profileData['goal_id']}&bmi=${profileData['bmi_id']}');
    print("**");
    print(res);
    print("**");
    if (res != null) {
      print(res.body);

      var calloriesRecommended = json.decode(res.body)[0];
      setState(() {
        recommendedCalories = calloriesRecommended;
      });
      return [];
    } else {
      return [];
    }
  }

  var selectedValue = [];

  void _saveFood_API() async {
    print(userData);
    var data = [];
    for (var d in selectedValue) {
      data.add({
        'user': userData['id'],
        'food': d,
        'day': DateFormat('EEEE').format(DateTime.now())
      });
    }

    print(data);

    var res = await CallApi().authenticatedPostRequest(data, 'daily-food');
    if (res == null) {
    } else {
      var body = json.decode(res!.body);
      print(body);

      if (res.statusCode == 200) {
        if (body['save']) {
          showSnack(context, 'Successful add today foods!');
        } else {
          showSnack(context, 'Fail to add today foods!');
          setState(() {});
        }
      } else if (res.statusCode == 400) {
        showSnack(context, 'Fail to add today foods!');
      } else {}
    }

    // ignore: avoid_print
  }

  var todayFood = [];
  deleteTodayFood(context) async {
    print(" Inside ===========-------");
    String day = DateFormat('EEEE').format(DateTime.now());
    print(profileData['goal_id']);
    print(userData['id']);
    print(day);
    var res = await CallApi().authenticatedGetRequest(
        'delete-food-daily-meal-record?user=${userData['id']}&goal=goal=${profileData['goal_id']}&day=${day}');
    print(res);
    if (res != null) {
      print(res.body);

      var body = json.decode(res.body);
      if (res.statusCode == 200) {
        if (body['delete']) {
          showSnack(context, 'Successful delete today foods!');
          todayFood = [];
          todayCall['total_calories'] == "";
          setState(() {});
        } else {
          showSnack(context, 'Fail to delete today foods!');
        }
      } else if (res.statusCode == 400) {
        showSnack(context, 'Fail to delete today foods!');
      } else {}

      return [];
    } else {
      return [];
    }
  }

  viewTodayFood_API(context) async {
    print(" Inside ===========-------");

    // var res = await CallApi().authenticatedGetRequest(
    //     // 'recommendation-calories?baseline_activity=${userData['profile']['baseline_activity_id']}&goal=${userData['profile']['goal_id']}&bmi=${userData['profile']['bmi_id']}');
    //     'food-daily-meal-record?user='+
    //         userData['id'].toString() +'&goal=1&day='+
    //         DateFormat('EEEE').format(DateTime.now()));
    String day = DateFormat('EEEE').format(DateTime.now());
    print(profileData['goal_id']);
    print(userData['id']);
    print(day);
    var res = await CallApi().authenticatedGetRequest(
        'food-daily-meal-record?user=${userData['id']}&goal=goal=${profileData['goal_id']}&day=${day}');
    // print("mimi");
    print(res);
    if (res != null) {
      print(res.body);

      var x = json.decode(res.body);
      print('object-==---');
      print(x);
      setState(() {
        todayFood = x;
        // recommendedCalories = calloriesRecommended;
      });
      print(todayFood);
      print("today === ===");
      return [];
    } else {
      return [];
    }
  }

  todayCalories_API(context) async {
    // print(" Inside Today Callories __________________");
    // print(userData);
    var res = await CallApi().authenticatedGetRequest('daily-food-get/' +
        userData['id'].toString() +
        '/' +
        DateFormat('EEEE').format(DateTime.now()));
    // var res = 2;
    print(res);
    if (res != null) {
      print(res.body);
      // print(" Inside Today Callories __________________");
      print("****");
      var todayCalories = json.decode(res.body);
      setState(() {
        todayCall['total_calories'] =
            todayCalories['total_calories'].toString();
      });
      // print('object----');
      // print(calloriesRecommended);
      // setState(() {
      // recommendedCalories = calloriesRecommended;
      //
      return [];
    } else {
      print("shit---");
      return [];
    }
  }

  final List<Category> categories = [
    Category('Category 1', ['Item 1', 'Item 2', 'Item 3']),
    Category('Category 2', ['Item 4', 'Item 5']),
    Category('Category 3', ['Item 6', 'Item 7', 'Item 8', 'Item 9']),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Calories Counter'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                // height: 220,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          spreadRadius: 20,
                          blurRadius: 10,
                          offset: const Offset(0, 10))
                    ],
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today,' + DateFormat('MMMM d').format(DateTime.now()),
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Calories',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      todayCall['total_calories'] == ""
                          ? Chart(
                              calories: "0.00".toString(),
                            )
                          : Chart(
                              calories: todayCall['total_calories'].toString(),
                            )

                      // Row(
                      //   children: [
                      //     Text(
                      //       'Average',
                      //       style: TextStyle(fontSize: 18),
                      //     ),
                      //     SizedBox(
                      //       height: 10,
                      //     ),
                      //     Row(
                      //       children: [
                      //         Text(
                      //           '1258',
                      //           style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      //         ),

                      //         SizedBox(width: 10,),
                      //         Text(
                      //           'kcal',
                      //           style: TextStyle(fontSize: 18),
                      //         )
                      //       ],
                      //     ),

                      // Chart(),
                      // ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              // height: 220,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.01),
                        spreadRadius: 20,
                        blurRadius: 10,
                        offset: const Offset(0, 10))
                  ],
                  borderRadius: BorderRadius.circular(30)),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'BODY MASS INDEX',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        // Expanded(
                        //   // child: SfRadialGauge(

                        //   //   axes: <RadialAxis>[
                        //   //     RadialAxis(
                        //   //       minimum: 0,
                        //   //       maximum: 100,
                        //   //       showLabels: false,
                        //   //       showAxisLine: false,
                        //   //         ranges: <GaugeRange>[
                        //   //           GaugeRange(startValue: 0, endValue: 25, color:Colors.green),
                        //   //           GaugeRange(startValue: 25,endValue: 75,color: Colors.orange),
                        //   //           GaugeRange(startValue: 75,endValue: 100,color: Colors.red)],
                        //   //         pointers: <GaugePointer>[
                        //   //           NeedlePointer(value: 90)],
                        //   //         annotations: <GaugeAnnotation>[
                        //   //           GaugeAnnotation(widget: Container(child:
                        //   //           Text('90.0',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                        //   //               angle: 90, positionFactor: 0.5
                        //   //           )]
                        //   //     )]),

                        //   child: CircularPercentIndicator(
                        //     radius: 70.0,
                        //     lineWidth: 13.0,
                        //     animation: true,
                        //     percent: 0.7,
                        //     center: Text(
                        //       "70.0%",
                        //       style: TextStyle(
                        //           fontWeight: FontWeight.bold, fontSize: 20.0),
                        //     ),
                        //     circularStrokeCap: CircularStrokeCap.round,
                        //     progressColor: Colors.purple,
                        //   ),
                        // ),

                        Image.asset(
                          'assets/body.png',
                          width: 200, // Specify the desired width
                          height: 150, // Specify the desired height
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BMI STATUS',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            profileData == null
                                ? Text(
                                    '',
                                    style: TextStyle(fontSize: 18),
                                  )
                                : Text(
                                    profileData['bmi_name'].toString(),
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ],
                        )
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Height',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  profileData == null
                                      ? Text(
                                          '',
                                          style: TextStyle(fontSize: 14),
                                        )
                                      : Text(
                                          profileData['height'].toString() +
                                              ' centimeter',
                                          style: TextStyle(fontSize: 14),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Weight',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  profileData == null
                                      ? Text(
                                          '',
                                          style: TextStyle(fontSize: 14),
                                        )
                                      : Text(
                                          profileData['weight'].toString() +
                                              " kg",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your BMI',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  profileData == null
                                      ? Text(
                                          '',
                                          style: TextStyle(fontSize: 14),
                                        )
                                      : Text(
                                          profileData['bmi'].toString(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Goal',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  profileData == null
                                      ? Text(
                                          '',
                                          style: TextStyle(fontSize: 14),
                                        )
                                      : Text(
                                          profileData['goal'].toString(),
                                          style: TextStyle(fontSize: 14),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),

                    // profileData == null
                    //     ? CustomListTile(
                    //         "",
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       )
                    //     : CustomListTile(
                    //         profileData['bmi'].toStringAsFixed(3),
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       ),
                    // profileData == null
                    //     ? CustomListTile(
                    //         "",
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       )
                    //     : CustomListTile(
                    //         profileData['height'].toString() + ' feet',
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       ),
                    // profileData == null
                    //     ? CustomListTile(
                    //         "",
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       )
                    //     : CustomListTile(
                    //         profileData['baseline_activity'].toString(),
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       ),
                    // profileData == null
                    //     ? CustomListTile(
                    //         "",
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       )
                    //     : CustomListTile(
                    //         profileData['goal'].toString(),
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       ),

                    //   recommendedCalories == null
                    //     ? CustomListTile(
                    //         "",
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       )
                    //     : CustomListTile(
                    //         recommendedCalories['calories'].toString()+" per day",
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       ),

                    //       recommendedExercise == null
                    //     ? CustomListTile(
                    //         "",
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       )
                    //     : CustomListTile(
                    //         recommendedExercise['name'].toString(),
                    //         Icons.height,
                    //         Icons.keyboard_arrow_right_outlined,
                    //       ),
                    // CustomListTile(
                    //   "Notification",
                    //   Icons.notifications_outlined,
                    //   Icons.keyboard_arrow_right_outlined,
                    // ),
                    // CustomListTile(
                    //   "Setting",
                    //   Icons.settings,
                    //   Icons.keyboard_arrow_right_outlined,
                    // ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Baseline Activity',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    profileData == null
                        ? Text(
                            '',
                            style: TextStyle(fontSize: 14),
                          )
                        : Text(
                            profileData['baseline_activity'].toString(),
                            style: TextStyle(fontSize: 14),
                          ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Calories',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    profileData == null
                        ? Text(
                            '',
                            style: TextStyle(fontSize: 14),
                          )
                        : Text(
                            recommendedCalories['calories'].toString() +
                                " per day",
                            style: TextStyle(fontSize: 14),
                          ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Exercise',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    randomElementsExercise.isEmpty == true
                        ? Text(
                            '',
                            style: TextStyle(fontSize: 14),
                          )
                        : Text(
                            '${randomElementsExercise[0]} and ${randomElementsExercise[1]}',
                            style: TextStyle(fontSize: 14),
                          ),
                  ],
                ),
              ),
            ),

            // Row(
            //   children: [
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.all(16.0),
            //         child: Container(
            //           width: double.infinity,
            //           // height: 220,
            //           decoration: BoxDecoration(
            //               color: Colors.white,
            //               boxShadow: [
            //                 BoxShadow(
            //                     color: Colors.black.withOpacity(0.01),
            //                     spreadRadius: 20,
            //                     blurRadius: 10,
            //                     offset: const Offset(0, 10))
            //               ],
            //               borderRadius: BorderRadius.circular(30)),
            //           child: Padding(
            //             padding: EdgeInsets.all(16.0),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Burn Calories',
            //                   style: TextStyle(
            //                       fontSize: 20, fontWeight: FontWeight.bold),
            //                 ),
            //                 SizedBox(
            //                   height: 30,
            //                 ),
            //                 Text(
            //                   'Start Exercise',
            //                   style: TextStyle(fontSize: 18),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Expanded(
            //       child: Padding(
            //         padding: const EdgeInsets.all(16.0),
            //         child: Container(
            //           width: double.infinity,
            //           // height: 220,
            //           decoration: BoxDecoration(
            //               color: Colors.white,
            //               boxShadow: [
            //                 BoxShadow(
            //                     color: Colors.black.withOpacity(0.01),
            //                     spreadRadius: 20,
            //                     blurRadius: 10,
            //                     offset: const Offset(0, 10))
            //               ],
            //               borderRadius: BorderRadius.circular(30)),
            //           child: Padding(
            //             padding: EdgeInsets.all(16.0),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text(
            //                   'Current Weight',
            //                   style: TextStyle(
            //                       fontSize: 20, fontWeight: FontWeight.bold),
            //                 ),
            //                 SizedBox(
            //                   height: 30,
            //                 ),
            //                 profileData == null
            //                     ? Text(
            //                         '',
            //                         style: TextStyle(fontSize: 18),
            //                       )
            //                     : Text(
            //                         profileData['weight'].toString() + " kg",
            //                         style: TextStyle(fontSize: 18),
            //                       ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     )
            //   ],
            // ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                // height: 220,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          spreadRadius: 20,
                          blurRadius: 10,
                          offset: const Offset(0, 10))
                    ],
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Today Food',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      DropdownSearch<String>.multiSelection(
                        // items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
                        // items: fetchFood(context),
                        asyncItems: fetchFood,
                        popupProps: PopupPropsMultiSelection.menu(
                          showSelectedItems: true,
                          showSearchBox: true,
                          // disabledItemFn: (String s) => s.startsWith('I'),
                        ),
                        onChanged: (newValue) {
                          setState(() {
                            selectedValue = newValue;
                            print(newValue);
                          });
                          // You can perform additional actions with the selected value here
                          print('Selected Value: $newValue');
                        },
                        // selectedItems: ["Choose food"],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      deleteTodayFood(context);
                      todayCalories_API(context);
                      print(todayCall);
                      // _saveFood_API();
                      // setPageState();
                      // _showReportDialog(todayFood.toString());
                      // viewTodayFood_API(context);
                      // todayCalories_API(context);
                      // Add your second button press logic here
                      print('Button 1 Pressed!');
                    },
                    child: Text('Reset'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // _saveFood_API();
                      // setPageState();
                      viewTodayFood_API(context);
                      print(todayFood);
                      _showReportDialog(todayFood.toString());
                      // viewTodayFood_API(context);
                      // todayCalories_API(context);
                      // Add your second button press logic here
                      print('Button 2 Pressed!');
                    },
                    child: Text('Show Selected Food'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _saveFood_API();
                      // setPageState();
                      // _showReportDialog(todayFood.toString());
                      // viewTodayFood_API(context);
                      // todayCalories_API(context);
                      // Add your second button press logic here
                      print('Button 3 Pressed!');
                    },
                    child: Text('Save Food'),
                  ),
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Container(
            //     width: double.infinity,
            //     // height: 220,
            //     decoration: BoxDecoration(
            //         color: Colors.white,
            //         boxShadow: [
            //           BoxShadow(
            //               color: Colors.black.withOpacity(0.01),
            //               spreadRadius: 20,
            //               blurRadius: 10,
            //               offset: const Offset(0, 10))
            //         ],
            //         borderRadius: BorderRadius.circular(30)),
            //     child: Padding(
            //       padding: EdgeInsets.all(16.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text(
            //             'Selected Food',
            //             style: TextStyle(
            //                 fontSize: 20, fontWeight: FontWeight.bold),
            //           ),
            //           SizedBox(
            //             height: 10,
            //           ),
            //           todayFood.length == 0?
            //           Text(
            //             'No Food Selected',
            //             style: TextStyle(fontSize: 18),
            //           )
            //           :
            //           Column(
            //             children: ListFood()
            //             // [
            //             //   // Text(
            //             //   //   todayFood.toString(),
            //             //   //   style: TextStyle(fontSize: 18),
            //             //   // ),
            //             // ],
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                // height: 220,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.01),
                          spreadRadius: 20,
                          blurRadius: 10,
                          offset: const Offset(0, 10))
                    ],
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommendation',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      profileData == null
                          ? Text(
                              '',
                              style: TextStyle(fontSize: 18),
                            )
                          : profileData['bmi_name'].toString() == "Underweight"
                              ? Text(
                                  'try to avoid foods with a lot of added sugar, fat and salt, like cakes, takeaway foods and sugary drinks',
                                  style: TextStyle(fontSize: 18),
                                )
                              : profileData['bmi_name'].toString() ==
                                      "Normal"
                                  ? Text(
                                      'Emphasizes fruits, vegetables, whole grains, and fat-free or low-fat milk and milk products. Includes a variety of protein foods such as seafood, lean meats and poultry, eggs, legumes (beans and peas), soy products, nuts, and seeds',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  : profileData['bmi_name'].toString() ==
                                          "Over weight"
                                      ? Text(
                                          'Choose minimally processed, whole foods-whole grains, vegetables, fruits, nuts, healthful sources of protein (fish, poultry, beans), and plant oils',
                                          style: TextStyle(fontSize: 18),
                                        )
                                      : Text(''),

                      // randomElements.isEmpty == false
                      //     ? Text(
                      //         '${randomElements[0]} and ${randomElements[1]}',
                      //         style: TextStyle(fontSize: 18),
                      //       )
                      //     : Text("")
                    ],
                  ),
                ),
              ),
            ),

            // const Padding(
            //   padding: EdgeInsets.only(left: 20, top: 15, bottom: 14),
            //   child: Text(
            //     'Meals',
            //     style:
            //         const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // InkWell(
            //   child: CustomListTile(
            //     "BreakFast",
            //     Icons.restaurant,
            //     Icons.add,
            //   ),
            //   onTap: () {
            //     // _showReportDialog();
            //     // _showFoodDialog();
            //     // _showFoodBotomSheet();

            //     // DropdownSearch<String>(
            //     //   popupProps: PopupProps.bottomSheet(
            //     //      showSelectedItems: true,
            //     //     showSearchBox: true,
            //     //     disabledItemFn: (String s) => s.startsWith('I'),
            //     //   ),
            //     //   // popupProps: PopupProps.menu(
            //     //   //   showSelectedItems: true,
            //     //   //   showSearchBox: true,
            //     //   //   disabledItemFn: (String s) => s.startsWith('I'),
            //     //   // ),
            //     //   items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
            //     //   dropdownDecoratorProps: DropDownDecoratorProps(
            //     //     dropdownSearchDecoration: InputDecoration(
            //     //       labelText: "Menu mode",
            //     //       hintText: "country in menu mode",
            //     //     ),
            //     //   ),
            //     //   onChanged: print,
            //     //   selectedItem: "Brazil",
            //     // );
            //   },
            // ),
            // DropdownSearch<String>.multiSelection(
            //   // items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
            //   // items: fetchFood(context),
            //   asyncItems: fetchFood,
            //   popupProps: PopupPropsMultiSelection.menu(
            //     showSelectedItems: true,
            //     showSearchBox: true,
            //     // disabledItemFn: (String s) => s.startsWith('I'),
            //   ),
            //   onChanged: print,
            //   selectedItems: ["Brazil"],
            // ),
            // CustomListTile(
            //   "Lunch",
            //   Icons.restaurant,
            //   Icons.add,
            // ),
            // CustomListTile(
            //   "Dinner",
            //   Icons.restaurant,
            //   Icons.add,
            // ),
          ],
        ),
      ),
    );
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<String> reportList;
  final Function(List<String>) onSelectionChanged;

  MultiSelectChip(this.reportList, {required this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<String> selectedChoices = [];

  _buildChoiceList() {
    List<Widget> choices = [];

    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

class FoodItems {
  final String id;
  final String name;

  FoodItems({required this.id, required this.name});
}

class Category {
  final String name;
  final List<String> items;

  Category(this.name, this.items);
}
