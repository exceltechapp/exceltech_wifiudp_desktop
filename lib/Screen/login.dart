import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widget/textfield.dart';
import 'main.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  var showpassword1 = true;
  final TextEditingController textIP = TextEditingController();
  final TextEditingController textPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: SizedBox(
            width: 550,
            height: 550,
            child: Card(
              elevation: 40,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset(
                    "assets/exceltech-logo.png",
                    height: 230,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 5),
                    child: textField(
                      obscureText: false,
                      labelText: "User Name",
                      controller: textIP,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 5),
                    child: textField(
                      obscureText: showpassword1,
                      labelText: "Password",
                      controller: textPassword,
                      icon: IconButton(
                        onPressed: () {
                          setState(() {
                            showpassword1 = !showpassword1;
                          });
                        },
                        icon: showpassword1
                            ? const Icon(
                          FontAwesomeIcons.eyeSlash,
                          color: Color.fromRGBO(0, 165, 146, 1),
                          size: 20,
                        )
                            : const Icon(
                          FontAwesomeIcons.eye,
                          color: Color.fromRGBO(0, 165, 146, 1),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SizedBox(
                      width: 150,
                      height: 40,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            Color.fromRGBO(0, 165, 146, 1),
                          ),
                        ),
                        onPressed: () {
                          if(textPassword.value.text.trim() == "admin"&& textIP.value.text.trim() == "admin"){
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => mainScreen()));
                          }
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
