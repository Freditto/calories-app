import 'dart:convert';

import 'package:calorie_calculator/auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData, profileData;

  @override
  void initState() {
    checkLoginStatus();
    _getUserInfo();
    _getProfileInfo();

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

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson!);
    setState(() {
      userData = user;
    });
    print(userData);
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

  _logoutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  child: const Text(
                    "Are you sure you want to logout",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      InkWell(
                          onTap: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();
                            Navigator.of(context).pop();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text('Yes')),

                      const SizedBox(
                        width: 30,
                      ),

                      InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('No')),
                      // onPressed: () {
                      //   Navigator.of(context).pop();
                      // }
                    ])
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('PROFILE'),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 30.0),
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://free2music.com/images/singer/2019/02/10/troye-sivan_2.jpg"),
                radius: 50.0,
              ),
              const SizedBox(height: 20.0),

              userData == null
                  ? const Text(
                      "",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                      ),
                    )
                  : Text(
                      userData['username'].toString(),
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

              const SizedBox(height: 20.0),

              userData == null
                  ? const Text("",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.0,
                      ))
                  : Text(
                      userData['email'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.0,
                      ),
                    ),

              const SizedBox(height: 20.0),

              userData == null
                  ? const Text("",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.0,
                      ))
                  : Text(
                      userData['phone'].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.0,
                      ),
                    ),
              const SizedBox(height: 30.0),

              CustomListTile(
                "History",
                Icons.history,
                Icons.keyboard_arrow_right_outlined,
              ),
              CustomListTile(
                "Notification",
                Icons.notifications_outlined,
                Icons.keyboard_arrow_right_outlined,
              ),
              CustomListTile(
                "Setting",
                Icons.settings,
                Icons.keyboard_arrow_right_outlined,
              ),
              // SwitchListTile(
              //   value: _darkMode,
              //   title: Text(
              //     ' Night Mode',
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              //   secondary: Padding(
              //     padding: const EdgeInsets.all(9.0),
              //     child: Icon(Icons.dark_mode),
              //   ),
              //   onChanged: (newValue) {
              //     setState(() {
              //       _darkMode = newValue;
              //     });
              //   },
              //   // visualDensity: VisualDensity.adaptivePlatformDensity,
              //   // switchType: SwitchType.material,
              //   activeColor: Colors.indigo,
              // ),
              InkWell(
                onTap: () {
                  _logoutDialog(context);
                },

                
                child: ListTile(
                  title: const Text(
                    ("Sign out"),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: (Icon(
                      Icons.logout,
                      size: 25,
                    )),
                  ),
                  tileColor: Colors.grey.shade100,
                  subtitle: const Text("Registered to example@gmail.com"),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.only(left: 20, top: 15, bottom: 14),
              //   child: Text(
              //     "Support",
              //     style:
              //         TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // CustomListTile(
              //   "Help",
              //   Icons.space_bar_rounded,
              //   Icons.keyboard_arrow_right_outlined,
              // ),
              // CustomListTile(
              //   "About us",
              //   Icons.person_outline,
              //   Icons.keyboard_arrow_right_outlined,
              // ),
              // CustomListTile(
              //   "Contact us",
              //   Icons.message,
              //   Icons.keyboard_arrow_right_outlined,
              // ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "CALORIES COUNTER 1.0.0",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 15),
                ),
              ),
              const SizedBox(height: 10),
              // SizedBox(height: 30.0),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     ElevatedButton(
              //       onPressed: () {},
              //       child: Text(
              //         "Follow",
              //         style: TextStyle(fontSize: 18.0),
              //       ),
              //       style: ElevatedButton.styleFrom(
              //         fixedSize: Size(140.0, 55.0),
              //         primary: Colors.green,
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(15.0),
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 15.0),
              //     OutlinedButton(
              //       onPressed: () {},
              //       child: Icon(Icons.mail_outline_outlined),
              //       style: OutlinedButton.styleFrom(
              //           primary: Colors.black,
              //           backgroundColor: Colors.black12,
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(50.0),
              //           ),
              //           fixedSize: Size(50.0, 60.0)),
              //     )
              //   ],
              // ),
              // SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  String title;
  IconData icon;
  IconData traling;

  CustomListTile(this.title, this.icon, this.traling, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: ListTile(
        tileColor: Colors.grey.shade50,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: (Icon(
            icon,
            size: 25,
          )),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          traling,
          size: 22,
        ),
      ),
    );
  }
}
