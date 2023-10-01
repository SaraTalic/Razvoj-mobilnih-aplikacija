import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';
import 'package:recipe/consent/navigation.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:recipe/consent/UserProvider.dart';

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  TextEditingController emailControllerR = TextEditingController();
  TextEditingController usernameControllerR = TextEditingController();
  TextEditingController passwordControllerR = TextEditingController();
  TextEditingController usernameControllerL = TextEditingController();
  TextEditingController passwordControllerL = TextEditingController();

  final String ime = "";

  Future<void> registerUser(BuildContext context) async {
    final String username = usernameControllerR.text;
    final String useremail = emailControllerR.text;
    final String password = passwordControllerR.text;

    final response = await http.post(
      Uri.parse('http://192.168.100.57/phpsalate/user/signup.php'),
      body: {
        "username": username,
        "useremail": useremail,
        "password": password,
      },
    );
    print('PHP skripta: ${response.body}');

    final data = json.decode(response.body);
    if (data == "Success") {
      Fluttertoast.showToast(
        msg: "Uspješno ste se registrovali.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 54, 244, 108),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserName(usernameControllerR.text);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Navigation()),
      );
    } else if (data == "Error") {
      Fluttertoast.showToast(
        msg: "Korisnik već postoji.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }else if (data == "MissingFields") {
      Fluttertoast.showToast(
        msg: "Morate popuniti sva polja.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      ); }
    else {
      Fluttertoast.showToast(
        msg: "Registracija nije uspjela. ",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<void> loginUser(BuildContext context) async {
    final String usernameOrEmail = usernameControllerL.text;
    final String password = passwordControllerL.text;

    final response = await http.post(
      Uri.parse('http://192.168.100.57/phpsalate/user/login.php'),
      body: {
        "usernameOrEmail": usernameOrEmail,
        "password": password,
      },
    );

    final data = json.decode(response.body);
    if (data == "Success") {
      Fluttertoast.showToast(
        msg: "Uspješno ste prijavljeni.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 54, 244, 108),
        textColor: Colors.white,
        fontSize: 16.0,
      );
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserName(usernameControllerL.text);
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => Navigation()),
      );
    } else if (data == "UserError") {
      Fluttertoast.showToast(
        msg: "Korisnik ne postoji.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (data == "PasswordError") {
      Fluttertoast.showToast(
        msg: "Neispravna lozinka.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (data == "MissingFields") {
      Fluttertoast.showToast(
        msg: "Neko polje je prazno.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      Fluttertoast.showToast(
        msg: "Prijavljivanje nije uspjelo.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: background,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 120),
            Center(
              child: Text(
                'Prijava',
                style: TextStyle(
                  color: font,
                  fontFamily: 'ro',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: usernameControllerL,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    hintText: 'Korisničko ime ili email',
                    hintStyle: TextStyle(fontFamily: 'ro'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                padding: EdgeInsets.only(left: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: passwordControllerL,
                  obscureText: true,
                  obscuringCharacter: '*',
                  decoration: InputDecoration(
                    icon: Icon(Icons.lock),
                    hintText: 'Lozinka',
                    hintStyle: TextStyle(fontFamily: 'ro'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                loginUser(context);
              },
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 160,
                decoration: BoxDecoration(
                  color: maincolor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  'Prijavi se',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'ro',
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 180),
            Expanded(
              child: GestureDetector(
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        offset: Offset(1, 1),
                        blurRadius: 20,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(120),
                      topRight: Radius.circular(120),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Registracija',
                      style: TextStyle(
                        fontFamily: 'ro',
                        color: font,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    barrierColor: Colors.transparent,
                    context: context,
                    builder: (BuildContext context) {
                      return DraggableScrollableSheet(
                        initialChildSize: 0.77,
                        builder: (context, scrollController) {
                          return Container(
                            decoration: BoxDecoration(
                              color: background,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(120),
                                topRight: Radius.circular(120),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: 50),
                                Text(
                                  'Registracija',
                                  style: TextStyle(
                                    fontFamily: 'ro',
                                    color: font,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 40),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextField(
                                      controller: usernameControllerR,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.person),
                                        hintText: 'Korisničko ime',
                                        hintStyle: TextStyle(fontFamily: 'ro'),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextField(
                                      controller: emailControllerR,
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.email),
                                        hintText: 'Email',
                                        hintStyle: TextStyle(fontFamily: 'ro'),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Container(
                                    padding: EdgeInsets.only(left: 15),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: TextField(
                                      controller: passwordControllerR,
                                      obscureText: true,
                                      obscuringCharacter: '*',
                                      decoration: InputDecoration(
                                        icon: Icon(Icons.lock),
                                        hintText: 'Lozinka',
                                        hintStyle: TextStyle(fontFamily: 'ro'),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                GestureDetector(
                                  onTap: () {
                                    registerUser(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 50,
                                    width: 160,
                                    decoration: BoxDecoration(
                                      color: maincolor,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      'Registruj se',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'ro',
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
