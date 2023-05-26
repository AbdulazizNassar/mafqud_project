import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/shared/AlertBox.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:mafqud_project/shared/size_config.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:regexed_validator/regexed_validator.dart';
import '../../services/firebase_exceptions.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  var email, password;

  signInWithEmailAndPassword() async {
    var formData = _formState.currentState;
    if (formData!.validate()) {
      formData.save();
      UserCredential response =
          await AuthService().signInWithEmailAndPassword(email, password);
      if (response != null) {
        Navigator.of(context).pushReplacementNamed("Home");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.defaultSize * 0,
                  ),
                  Center(
                    child: Form(
                      key: _formState,
                      child: Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.defaultSize * 15,
                            bottom: SizeConfig.defaultSize * 12,
                            left: SizeConfig.defaultSize * 2,
                            right: SizeConfig.defaultSize * 2),
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              onSaved: (val) {
                                email = val!;
                              },
                              validator: (val) {
                                if (!validator.email(val!)) {
                                  return "Please enter a valid email";
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle:
                                    const TextStyle(color: primaryColor),
                                prefixIcon: Icon(
                                  Icons.mail,
                                  size: SizeConfig.defaultSize * 2,
                                  color: primaryColor,
                                ),
                                filled: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: primaryColor)),
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 3,
                            ),
                            TextFormField(
                              onSaved: (val) {
                                password = val!;
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle:
                                    const TextStyle(color: primaryColor),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  size: SizeConfig.defaultSize * 2,
                                  color: primaryColor,
                                ),
                                filled: true,
                                enabledBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: primaryColor)),
                              ),
                              validator: (val) => val!.isEmpty
                                  ? "password cannot be empty"
                                  : null,
                              obscureText: true,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                child: const Text(
                                  'Forgot your password?',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                onTap: () async {
                                  AuthStatus status = await AuthService()
                                      .resetPassword(email: email);
                                  setState(() {
                                    confirmationAlert(context, status.name);
                                  });
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                            ButtonTheme(
                              height: SizeConfig.defaultSize * 3,
                              minWidth: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  child: const Text(
                                    'Login',
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  ),
                                  onPressed: () async {
                                    try {
                                      await signInWithEmailAndPassword();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBarError("Error",
                                              "Account not registered"));
                                    }
                                  }),
                            ),
                            ButtonTheme(
                              height: SizeConfig.defaultSize * 5,
                              minWidth: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                child: const Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                                onPressed: () async {
                                  await AuthService().signInWithGoogle();
                                },
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text(
                                  "Don't have an account? ",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed("Register");
                                  },
                                  child: const Text(
                                    'Sign Up',
                                    style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(top: SizeConfig.defaultSize * 1),
                      height: SizeConfig.defaultSize * 5,
                      width: SizeConfig.defaultSize * 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 6,
                            offset: const Offset(
                                0, 2), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
