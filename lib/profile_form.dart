import 'dart:convert';

import 'package:calorie_calculator/api/api.dart';
import 'package:calorie_calculator/auth.dart';
import 'package:calorie_calculator/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  var userData, next;

  final _formKey = GlobalKey<FormState>();

  TextEditingController companyController = TextEditingController(); //
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController ageController = TextEditingController(); //

  String? chosenStatus; //
  String? genderStatus;
  String? goalStatus;
  String? baselineStatus;
  String? dietStatus;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    _getUserInfo();
  }

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
    // fetchJobData();
  }

  Future<List<Goal_Items>> fetchGoalData(context) async {
    print(" Inside Goal_Items function");

    var res = await CallApi().authenticatedGetRequest('goal');

    // print(res);
    if (res != null) {
      print(res.body);
      // var body = json.decode(res.body);

      var goalJson = json.decode(res.body);

      print(goalJson);

      List<Goal_Items> goalItemsList = [];

      for (var f in goalJson) {
        Goal_Items goalItems = Goal_Items(
          f["id"].toString(),
          f["name"].toString(),
        );
        goalItemsList.add(goalItems);
      }
      print(goalItemsList.length);

      return goalItemsList;
    } else {
      return [];
    }
  }

  Future<List<Baseline_Items>> fetchBaselineData(context) async {
    print(" Inside Baseline function");

    var res = await CallApi().authenticatedGetRequest('baseline-activity');

    // print(res);
    if (res != null) {
      // print(res.body);
      // var body = json.decode(res.body);

      var baselineJson = json.decode(res.body);

      print(baselineJson);

      List<Baseline_Items> baselineItemsList = [];

      for (var f in baselineJson) {
        Baseline_Items baselineItems = Baseline_Items(
          f["id"].toString(),
          f["name"].toString(),
        );
        baselineItemsList.add(baselineItems);
      }
      print(baselineItemsList.length);

      return baselineItemsList;
    } else {
      return [];
    }
  }

  void _save_profile_info() async {
    // setState(() {
    //   _isLoading = true;
    // });

    // var number = userNumberController.text;
    // print(_countryCodes);
    // var code = _selectedCountryCode
    //     .toString()
    //     .substring(1, _selectedCountryCode.toString().length);
    // if (number.length == 10) {
    //   number = number.substring(1, number.length);
    // }
    // var cellphone = code + number;

    var bmi = int.parse(weightController.text) /
        (int.parse(heightController.text) * int.parse(heightController.text));

// *******************************************************
    var data = {
      'user': userData['id'],
      'gender': genderStatus,
      'goal': goalStatus,
      'age': int.parse(ageController.text),
      'height': int.parse(heightController.text),
      'weight': int.parse(weightController.text),
      'bmi': bmi,
      'baseline_activity': baselineStatus,
      'dietary_restriction': dietStatus,
      // 'type': 'driver',
    };

    print(data);

    var res = await CallApi().authenticatedPostRequest(data, 'profile');
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
        // SharedPreferences localStorage = await SharedPreferences.getInstance();
        // localStorage.setString("token", body['token']);
        // localStorage.setString("user", json.encode(body['user']));
        // localStorage.setString("token", json.encode(body['tokens']['access']));
        // localStorage.setString("phone_number", userNumberController.text);

        // setState(() {
        //   _isLoading = false;
        // });

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const NavigatorWidget()));
      } else if (res.statusCode == 400) {
        print('hhh');
        // setState(() {
        //   _isLoading = false;
        //   _not_found = true;
        // });
      } else {}
    }

    // ignore: avoid_print
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set up your profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18, right: 18, top: 34),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: heightController,
                            // validator: validateUsername,
                            keyboardType: TextInputType.phone,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                // borderSide: BorderSide.none,
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Height in meters',
                              hintStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: weightController,
                            // validator: validateUsername,
                            keyboardType: TextInputType.phone,
                            style: Theme.of(context).textTheme.bodyMedium,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ),
                                // borderSide: BorderSide.none,
                                borderSide:
                                    const BorderSide(color: Colors.grey),
                              ),
                              hintText: 'Weight in kg',
                              hintStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    TextFormField(
                      controller: ageController,
                      // validator: validateUsername,
                      keyboardType: TextInputType.phone,
                      style: Theme.of(context).textTheme.bodyMedium,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                          // borderSide: BorderSide.none,
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Age',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    Container(
                      // padding: const EdgeInsets.all(0.0),
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12)),
                      child: DropdownButton<String>(
                        value: genderStatus,
                        //elevation: 5,
                        // style: TextStyle(color: Colors.black),

                        hint: const Text('Select Gender'),
                        dropdownColor: Colors.white,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 36,
                        isExpanded: true,
                        underline: const SizedBox(),
                        style: const TextStyle(color: Colors.black, fontSize: 15),

                        items: <String>[
                          'male',
                          'female',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        onChanged: (String? value) {
                          print(value);
                          // var v = '0';
                          // if (value == 'Revenue') {
                          //   v = '1';
                          // }
                          setState(() {
                            genderStatus = value;
                            // _visible_tag = v;
                          });
                        },
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    Container(
                        child: FutureBuilder<List<Goal_Items>>(
                      future: fetchGoalData(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!;
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 3, bottom: 3),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12)),
                            child: DropdownButton<String>(
                              hint: const Text('Select Goal'),
                              dropdownColor: Colors.white,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              underline: const SizedBox(),
                              style:
                                  const TextStyle(color: Colors.black, fontSize: 15),
                              value: goalStatus,
                              onChanged: (newValue) {
                                setState(() {
                                  goalStatus = newValue!;
                                });
                              },
                              items: data.map((valueItem) {
                                return DropdownMenuItem<String>(
                                  value: valueItem.id,
                                  child: Text(valueItem.name.toString()),
                                );
                              }).toList(),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    )),

                    const SizedBox(
                      height: 30,
                    ),

                    Container(
                        child: FutureBuilder<List<Baseline_Items>>(
                      future: fetchBaselineData(context),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!;
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, top: 3, bottom: 3),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(12)),
                            child: DropdownButton<String>(
                              hint: const Text('Select Baseline Activity'),
                              dropdownColor: Colors.white,
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 36,
                              isExpanded: true,
                              underline: const SizedBox(),
                              style:
                                  const TextStyle(color: Colors.black, fontSize: 15),
                              value: baselineStatus,
                              onChanged: (newValue) {
                                setState(() {
                                  baselineStatus = newValue!;
                                });
                              },
                              items: data.map((valueItem) {
                                return DropdownMenuItem<String>(
                                  value: valueItem.id,
                                  child: Text(valueItem.name.toString()),
                                );
                              }).toList(),
                            ),
                          );
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    )),

                    const SizedBox(
                      height: 30,
                    ),

                    Container(
                      // padding: const EdgeInsets.all(0.0),
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 0, bottom: 0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12)),
                      child: DropdownButton<String>(
                        value: dietStatus,
                        //elevation: 5,
                        // style: TextStyle(color: Colors.black),

                        hint: const Text('Select Dietary Restriction'),
                        dropdownColor: Colors.white,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 36,
                        isExpanded: true,
                        underline: const SizedBox(),
                        style: const TextStyle(color: Colors.black, fontSize: 15),

                        items: <String>[
                          'Vegetarian',
                          'None Vegetarian',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),

                        onChanged: (String? value) {
                          print(value);
                          // var v = '0';
                          // if (value == 'Revenue') {
                          //   v = '1';
                          // }
                          setState(() {
                            dietStatus = value;
                            // _visible_tag = v;
                          });
                        },
                      ),
                    ),

                    // const SizedBox(
                    //     height: 30,
                    //   ),

                    // Container(
                    //   // padding: const EdgeInsets.all(0.0),
                    //   padding: EdgeInsets.only(
                    //       left: 10.0, right: 10.0, top: 0, bottom: 0),
                    //   decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.grey),
                    //       borderRadius: BorderRadius.circular(12)),
                    //   child: DropdownButton<String>(
                    //     value: baselineStatus,
                    //     //elevation: 5,
                    //     // style: TextStyle(color: Colors.black),

                    //     hint: Text('Select Baseline Activity'),
                    //     dropdownColor: Colors.white,
                    //     icon: Icon(Icons.arrow_drop_down),
                    //     iconSize: 36,
                    //     isExpanded: true,
                    //     underline: SizedBox(),
                    //     style: TextStyle(color: Colors.black, fontSize: 15),

                    //     items: <String>[
                    //       'Full Time',
                    //       'Part Time',
                    //     ].map<DropdownMenuItem<String>>((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),

                    //     onChanged: (String? value) {
                    //       print(value);
                    //       // var v = '0';
                    //       // if (value == 'Revenue') {
                    //       //   v = '1';
                    //       // }
                    //       setState(() {
                    //         baselineStatus = value;
                    //         // _visible_tag = v;
                    //       });
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              MaterialButton(
                elevation: 0,
                color: Colors.green,
                height: 50,
                minWidth: 500,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () {
                  // _submit();
                  // _login();
                  _save_profile_info();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NavigatorWidget(),
                    ),
                  );
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),

              // const SizedBox(
              //   height: 200,
              // ),

              // _contentOverView(),
              // const SizedBox(
              //   height: 30,
              // ),

              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Goal_Items {
  final String? id, name;

  Goal_Items(this.id, this.name);
}

class Baseline_Items {
  final String? id, name;

  Baseline_Items(this.id, this.name);
}
