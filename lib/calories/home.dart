import 'dart:convert';

import 'package:calorie_calculator/api/api.dart';
import 'package:calorie_calculator/auth.dart';
import 'package:calorie_calculator/calories/chart.dart';
import 'package:calorie_calculator/profile/profile.dart';
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

    fetchFood(context);
    //listenNotifications();
    recommendationCalories(context);
    recommendationExercise(context);

    _getProfileInfo();
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
  }

  void _getProfileInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var profileJson = localStorage.getString('profile');
    var profile = json.decode(profileJson!);
    setState(() {
      profileData = profile;
    });

    print(profileData);
  }

  List<String> brealFastMeals = [
    "Not relevant",
    "Illegal",
    "Spam",
    "Offensive",
    "Uncivil"
        "Not relevant",
    "Illegal",
    "Spam",
    "Offensive",
    "Uncivil"
        "Not relevant",
    "Illegal",
    "Spam",
    "Offensive",
    "Uncivil"
  ];

  List<String> selectedReportList = [];

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("BreakFast Meals"),
            content: MultiSelectChip(
              brealFastMeals,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
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
        print('----');
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

  var recommendedCalories;
  var recommendedExercise;
  recommendationExercise(context) async {
    print(" Inside Exercise function");

    var res = await CallApi().authenticatedGetRequest(
        // 'recommendation-calories?baseline_activity=${userData['profile']['baseline_activity_id']}&goal=${userData['profile']['goal_id']}&bmi=${userData['profile']['bmi_id']}');
        'recommendation-exercise?bmi=2');

    // print(res);
    if (res != null) {
      // print(res.body);

      var calloriesRecommended = json.decode(res.body)[0];
      print('object----');
      print(calloriesRecommended);
      setState(() {
        recommendedExercise = calloriesRecommended;
      });
      return [];
    } else {
      return [];
    }
  }

  recommendationCalories(context) async {
    print(" Inside Callories function");

    var res = await CallApi().authenticatedGetRequest(
        // 'recommendation-calories?baseline_activity=${userData['profile']['baseline_activity_id']}&goal=${userData['profile']['goal_id']}&bmi=${userData['profile']['bmi_id']}');
        'recommendation-calories?baseline_activity=1&goal=1&bmi=1');

    // print(res);
    if (res != null) {
      // print(res.body);

      var calloriesRecommended = json.decode(res.body)[0];
      print('object----');
      print(calloriesRecommended);
      setState(() {
        recommendedCalories = calloriesRecommended;
      });
      return [];
    } else {
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
                      Chart(),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'BODY MASS INDEX',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
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
                      profileData == null
                          ? CustomListTile(
                              "",
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            )
                          : CustomListTile(
                              profileData['bmi'].toStringAsFixed(3),
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            ),
                      profileData == null
                          ? CustomListTile(
                              "",
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            )
                          : CustomListTile(
                              profileData['height'].toString() + ' feet',
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            ),
                      profileData == null
                          ? CustomListTile(
                              "",
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            )
                          : CustomListTile(
                              profileData['baseline_activity'].toString(),
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            ),
                      profileData == null
                          ? CustomListTile(
                              "",
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            )
                          : CustomListTile(
                              profileData['goal'].toString(),
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            ),

                        recommendedCalories == null
                          ? CustomListTile(
                              "",
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            )
                          : CustomListTile(
                              recommendedCalories['calories'].toString()+" per day",
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            ),

                            recommendedExercise == null
                          ? CustomListTile(
                              "",
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            )
                          : CustomListTile(
                              recommendedExercise['name'].toString(),
                              Icons.height,
                              Icons.keyboard_arrow_right_outlined,
                            ),
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
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
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
                              'Burn Calories',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              'Start Exercise',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
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
                              'Current Weight',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            profileData == null
                                ? Text(
                                    '',
                                    style: TextStyle(fontSize: 18),
                                  )
                                : Text(
                                    profileData['weight'].toString() + " kg",
                                    style: TextStyle(fontSize: 18),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),

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
                        onChanged: print,
                        // selectedItems: ["Choose food"],
                      ),
                    ],
                  ),
                ),
              ),
            ),

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
