import 'dart:convert';

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
    // fetchFood(context);
    // listenNotifications();

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

    print(userData);
    _getProfileInfo();
  }

  void _getProfileInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var profileJson = localStorage.getString('profile');
    var profile = json.decode(profileJson!);
    setState(() {
      profileData = profile;
    });

    // print(profileData);

    recommendationCalories(context);
    recommendationExercise(context);
    todayCalories_API(context);
    viewTodayFood_API(context);
  }

  setPageState() {
    print('________');
    // setState(() {});
    // viewTodayFood_API(context);
    // fetchFood(context);
    //listenNotifications();
    // recommendationCalories(context);
    // recommendationExercise(context);
    // todayCalories_API(context);R
    setState(() {});
  }

  // List<String> brealFastMeals = [];
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

  List<String> selectedReportList = [];
  var todayCall = {'total_calories': ''};

  _showReportDialog(String data) {
    // return StatefulBuilder(builder: (context, setState) {
    //   return AlertDialog(
    //     content: Text(data),
    //     title: Text('Stateful Dialog'),
    //     actions: <Widget>[
    //       InkWell(
    //         child: Text('OK   '),
    //         onTap: () {

    //         },
    //       ),
    //     ],
    //   );
    // });
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

  _showFoodBotomSheet() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: DropdownSearch<String>.multiSelection(
            items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
            popupProps: PopupPropsMultiSelection.menu(
              showSelectedItems: true,
              showSearchBox: true,
              // disabledItemFn: (String s) => s.startsWith('I'),
            ),
            onChanged: print,
            selectedItems: ["Brazil"],
          ),
        );
      },
    );
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

            // DropdownSearch<String>(
            //   popupProps: PopupProps.menu(
            //     showSelectedItems: true,
            //     showSearchBox: true,
            //     disabledItemFn: (String s) => s.startsWith('I'),
            //   ),
            //   items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
            //   dropdownDecoratorProps: DropDownDecoratorProps(
            //     dropdownSearchDecoration: InputDecoration(
            //       labelText: "Menu mode",
            //       hintText: "country in menu mode",
            //     ),
            //   ),
            //   onChanged: print,
            //   selectedItem: "Brazil",
            // ),

// DropdownSearch<String>.multiSelection(
//     items: ["Brazil", "Italia (Disabled)", "Tunisia", 'Canada'],
//     popupProps: PopupPropsMultiSelection.menu(
//         showSelectedItems: true,
//         disabledItemFn: (String s) => s.startsWith('I'),
//     ),
//     onChanged: print,
//     selectedItems: ["Brazil"],
// )
            actions: <Widget>[
              TextButton(
                child: Text("Report"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  // List<String> foodItems = [];

  Future<List<String>> fetchFood(context) async {
    print(" Inside List of food function");

    var res = await CallApi().authenticatedGetRequest('food');

    // print(res);
    if (res != null) {
      print("==========");
      // print(res.body);
      List<String> foodItems = [];
      var b = json.decode(res.body);
      print(b.runtimeType);
      for (var data in b) {
        // print('----');
        foodItems.add(data['name']);
      }
      print(foodItems);
      // setState(() {
      //   foodItems = d;
      // });
      // var aptitudeResultItensJson = json.decode(res.body);

      // List<AptituteResult_Items> aptituderesultItems = [];

      // for (var f in aptitudeResultItensJson) {
      //   AptituteResult_Items requestlistItems = AptituteResult_Items(
      //     f["job"].toString(),
      //     f["company"].toString(),
      //     f["percent"].toString(),
      //     f["status"].toString(),

      //     // f["longitude"].toString(),
      //     // f['is_received'].toString(),
      //   );
      //   aptituderesultItems.add(requestlistItems);
      // }
      // print(aptituderesultItems.length);

      return foodItems;
    } else {
      return [];
    }
  }

  Map<String, dynamic> recommendedCalories = {'calories': ''};
  Map<String, dynamic> recommendedExercise = {'name': ''};
  recommendationExercise(context) async {
    print(" Inside Exercise function");

    var res = await CallApi().authenticatedGetRequest(
        // 'recommendation-calories?baseline_activity=${userData['profile']['baseline_activity_id']}&goal=${userData['profile']['goal_id']}&bmi=${userData['profile']['bmi_id']}');
        'recommendation-exercise?bmi=2');

    // print(res);
    if (res != null) {
      // print(res.body);

      var exerciseRecommended = json.decode(res.body)[0];
      // print('object----****');
      // print(exerciseRecommended);
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

    var res = await CallApi().authenticatedGetRequest(
        'recommendation-calories?baseline_activity=${userData['profile']['baseline_activity_id']}&goal=${userData['profile']['goal_id']}&bmi=${userData['profile']['bmi_id']}');
    // 'recommendation-calories?baseline_activity=1&goal=1&bmi=1');

    print(res);
    if (res != null) {
      print(res.body);

      var calloriesRecommended = json.decode(res.body)[0];
      // print('object----');
      // print(calloriesRecommended);
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
      // setState(() {
      //   _isLoading = false;
      //   // _not_found = true;
      // });
      // showSnack(context, 'No Network!');
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
        // print('hhh');
        showSnack(context, 'Fail to add today foods!');

        // setState(() {
        //   _isLoading = false;
        //   _not_found = true;
        // });
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
    // print("mimi");
    print(res);
    if (res != null) {
      print(res.body);

      var body = json.decode(res.body);
      // print('object-==---');
      // print(x);
      // setState(() {
      //   todayFood = [];
      //   // recommendedCalories = calloriesRecommended;
      // });
      // print(todayFood);
      // print("today === ===");
      if (res.statusCode == 200) {
        if (body['delete']) {
          showSnack(context, 'Successful delete today foods!');
          setState(() {
            todayFood = [];
          });
        } else {
          showSnack(context, 'Fail to delete today foods!');
        }
      } else if (res.statusCode == 400) {
        // print('hhh');
        showSnack(context, 'Fail to delete today foods!');

        // setState(() {
        //   _isLoading = false;
        //   _not_found = true;
        // });
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
    print(" Inside Today Callories __________________");
    // print(userData);
    var res = await CallApi().authenticatedGetRequest('daily-food-get/' +
        userData['id'].toString() +
        '/' +
        DateFormat('EEEE').format(DateTime.now()));
    print(" Inside Today Callories __________________");
    // var res = 2;
    print(res);
    if (res != null) {
      print(res.body);

      var todayCalories = json.decode(res.body);
      setState(() {
        todayCall = todayCalories;
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
                        Expanded(
                          // child: SfRadialGauge(

                          //   axes: <RadialAxis>[
                          //     RadialAxis(
                          //       minimum: 0,
                          //       maximum: 100,
                          //       showLabels: false,
                          //       showAxisLine: false,
                          //         ranges: <GaugeRange>[
                          //           GaugeRange(startValue: 0, endValue: 25, color:Colors.green),
                          //           GaugeRange(startValue: 25,endValue: 75,color: Colors.orange),
                          //           GaugeRange(startValue: 75,endValue: 100,color: Colors.red)],
                          //         pointers: <GaugePointer>[
                          //           NeedlePointer(value: 90)],
                          //         annotations: <GaugeAnnotation>[
                          //           GaugeAnnotation(widget: Container(child:
                          //           Text('90.0',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                          //               angle: 90, positionFactor: 0.5
                          //           )]
                          //     )]),

                          child: CircularPercentIndicator(
                            radius: 70.0,
                            lineWidth: 13.0,
                            animation: true,
                            percent: 0.7,
                            center: Text(
                              "70.0%",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Colors.purple,
                          ),
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
                                              ' feet',
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
                    profileData == null
                        ? Text(
                            '',
                            style: TextStyle(fontSize: 14),
                          )
                        : Text(
                            recommendedExercise['name'].toString(),
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
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recommendation',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Average',
                        style: TextStyle(fontSize: 18),
                      ),
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
