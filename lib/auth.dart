import 'dart:convert';

import 'package:calorie_calculator/api/api.dart';
import 'package:calorie_calculator/profile_form.dart';
import 'package:calorie_calculator/utils/constant.dart';
import 'package:calorie_calculator/utils/snackbar.dart';
import 'package:calorie_calculator/widgets/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// **************** Login starts here ***************************
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  var userData;

  @override
  void initState() {
    // checkLoginStatus();
    _getUserInfo();

    //listenNotifications();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // return Future.value(true);
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // _contentHeader(),
                const SizedBox(
                  height: 18,
                ),

                Image.asset('assets/calogo.png'),

                const Center(
                  child: Text(
                    'CALORIE COUNTER',
                    style: TextStyle(fontSize: 26, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 70,
                ),
                // Spacer(),
                // Text(
                //   'Accounting Tool',
                //   style: Theme.of(context).textTheme.headline5,
                // ),

                // Text(
                //   'For Small Business',
                //   style: Theme.of(context).textTheme.titleSmall,
                // ),
                // const SizedBox(
                //   height: 18,
                // ),
                // const SizedBox(
                //   height: 30,
                // ),
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                const SizedBox(
                  height: 16,
                ),

                // CustomInputField(
                //   controller: userNumberController,
                //   keyboardType: TextInputType.number,
                //   hintText: 'Phone Number',
                //   textInputAction: TextInputAction.next,
                // ),
                // // _contentServices(context),

                // TextField(
                //   decoration: new InputDecoration(labelText: "Enter your number"),
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //     FilteringTextInputFormatter.digitsOnly
                //   ], // Only numbers can be entered
                // ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userEmailController,
                        validator: validateUsername,
                        // keyboardType: TextInputType.phone,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.kPlaceholder3,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Username',
                          hintStyle: const TextStyle(
                            color: AppColor.kTextColor1,
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
                      TextFormField(
                        controller: userPasswordController,
                        obscureText: true,
                        validator: validatePassword,
                        // keyboardType: TextInputType.phone,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.kPlaceholder3,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                            color: AppColor.kTextColor1,
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
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
                    _submit();
                    // _login();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ProfileFormScreen(),
                    //   ),
                    // );
                  },
                  child: const Text(
                    'Login',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Not Registered?',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      },
                      child: Text(
                        'Register here!',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
                // const SizedBox(height: 16),
                // _contentSendMoney(),
                // const SizedBox(
                //   height: 30,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Text(
                //       'Services',
                //       style: Theme.of(context).textTheme.headline4,
                //     ),
                //     SvgPicture.asset(
                //       filter,
                //       color: Theme.of(context).iconTheme.color,
                //       width: 18,
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                // _contentServices(context),

                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  String? validateUsername(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.isEmpty) {
      return 'Username Field must not be empty';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.isEmpty) {
      return 'Password Field must not be empty';
    } else if (value.length < 8)
      return 'Password must be of 8 or more digit';
    else
      return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO SAVE DATA
      _login();
    }
  }

  // fetchProfileData(context) async {
  //   print(" Inside Profile function");

  //   var res = await CallApi()
  //       .authenticatedGetRequest('profile?user_id=${user_id}');

  //   print(res);
  //   if (res != null) {
  //     // print(res.body);

  //     var profileListItensJson = json.decode(res.body);
  //     print(profileListItensJson);
  //     return [];
  //   } else {
  //     return [];
  //   }
  // }

  var user_id;

  void _login() async {
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

// *************************************************
    var data = {
      'username': userEmailController.text,
      'password': userPasswordController.text,
    };

    print(data);

    var res = await CallApi().authenticatedPostRequest(data, 'auth/login');
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
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        // localStorage.setString("token", body['token']);
        // localStorage.setString("user", json.encode(body['user']));
        // localStorage.setString("token", json.encode(body['tokens']['access']));
        // localStorage.setString("profile", json.encode(body['profile_data']));
        // localStorage.setString("phone_number", userNumberController.text);

        if (body['msg'] == 'success') {
          setState(() {
            user_id = body['user']['id'];
          });
          localStorage.setString("user", json.encode(body['user']));
          localStorage.setString(
              "token", json.encode(body['tokens']['access']));
          localStorage.setString("profile", json.encode(body['profile_data']));
          if (body['profile'] == false) {
            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ProfileFormScreen()));
          } else if (body['profile'] == true) {
            // setState(() {});
            // fetchProfileData(context);
            // ignore: use_build_context_synchronously
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NavigatorWidget()));
          }
        } else {
          // ignore: use_build_context_synchronously
          showSnack(context, 'Wrong User name or Password!');
        }
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
}

// **************** Login Ends here ***************************

// **************** Register starts here ***************************

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPhoneController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // TODO SAVE DATA

      _register();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // return Future.value(true);
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');

        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // _contentHeader(),
                const SizedBox(
                  height: 18,
                ),

                Image.asset('assets/calogo.png'),

                const Center(
                  child: Text(
                    'CALORIE COUNTER',
                    style: TextStyle(fontSize: 26, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Spacer(),
                // Text(
                //   'Accounting Tool',
                //   style: Theme.of(context).textTheme.headline5,
                // ),

                // Text(
                //   'For Small Business',
                //   style: Theme.of(context).textTheme.titleSmall,
                // ),
                // const SizedBox(
                //   height: 18,
                // ),
                // const SizedBox(
                //   height: 30,
                // ),
                const Center(
                  child: Text(
                    'Register',
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),

                // CustomInputField(
                //   controller: userNumberController,
                //   keyboardType: TextInputType.number,
                //   hintText: 'Phone Number',
                //   textInputAction: TextInputAction.next,
                // ),
                // // _contentServices(context),

                // TextField(
                //   decoration: new InputDecoration(labelText: "Enter your number"),
                //   keyboardType: TextInputType.number,
                //   inputFormatters: <TextInputFormatter>[
                //     FilteringTextInputFormatter.digitsOnly
                //   ], // Only numbers can be entered
                // ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userNameController,
                        validator: validateUsername,
                        // keyboardType: TextInputType.phone,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.kPlaceholder3,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Username',
                          hintStyle: const TextStyle(
                            color: AppColor.kTextColor1,
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
                      TextFormField(
                        controller: userEmailController,
                        validator: validateEmail,
                        // keyboardType: TextInputType.phone,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.kPlaceholder3,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                            color: AppColor.kTextColor1,
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
                      TextFormField(
                        controller: userPasswordController,
                        obscureText: true,
                        validator: validatePassword,
                        // keyboardType: TextInputType.phone,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.kPlaceholder3,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Password',
                          hintStyle: const TextStyle(
                            color: AppColor.kTextColor1,
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
                      TextFormField(
                        controller: userPhoneController,
                        validator: validateMobile,
                        keyboardType: TextInputType.phone,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColor.kPlaceholder3,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Phone Number',
                          hintStyle: const TextStyle(
                            color: AppColor.kTextColor1,
                            fontSize: 14,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                Center(
                  child: MaterialButton(
                    elevation: 0,
                    color: Colors.green,
                    height: 50,
                    minWidth: 500,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      _submit();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => OTP_Screen(),
                      //   ),
                      // );
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already Registered?',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: Text(
                        'Login here!',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 30,
                ),
                // const SizedBox(height: 16),
                // _contentSendMoney(),
                // const SizedBox(
                //   height: 30,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: <Widget>[
                //     Text(
                //       'Services',
                //       style: Theme.of(context).textTheme.headline4,
                //     ),
                //     SvgPicture.asset(
                //       filter,
                //       color: Theme.of(context).iconTheme.color,
                //       width: 18,
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                // _contentServices(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validateEmail(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

  String? validateMobile(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.length != 10) {
      return 'Mobile Number must be of 10 digit';
    } else {
      return null;
    }
  }

  String? validateUsername(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.isEmpty) {
      return 'Username Field must not be empty';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
// Indian Mobile number are of 10 digit only
    if (value!.isEmpty) {
      return 'Password Field must not be empty';
    } else if (value.length < 8)
      return 'Password must be of 8 or more digit';
    else
      return null;
  }

  void _register() async {
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

// *******************************************************
    var data = {
      'username': userNameController.text,
      'email': userEmailController.text,
      'password': userPasswordController.text,
      'phone': userPhoneController.text,
      // 'type': 'driver',
    };

    print(data);

    var res = await CallApi().authenticatedPostRequest(data, 'auth/register');
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

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
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
}


// **************** Register Ends here ***************************
