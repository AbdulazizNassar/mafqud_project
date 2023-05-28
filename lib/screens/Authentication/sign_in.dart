import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/screens/posts/posts.dart';
import 'package:mafqud_project/shared/AlertBox.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:mafqud_project/shared/size_config.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:regexed_validator/regexed_validator.dart';
import '../../services/firebase_exceptions.dart';
import '../chat/cubit/chat_cubit.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, this.navKey});
  final navKey;
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  var email, password;
  var _passwordVisible = true;

  signInWithEmailAndPassword() async {
    var formData = _formState.currentState;
    if (formData!.validate()) {
      formData.save();
      UserCredential response =
          await AuthService().signInWithEmailAndPassword(email, password);
      uId = response.user!.uid;
      // ChatCubit.get(context).getUserData();
      widget.navKey.currentState.pushReplacement(MaterialPageRoute(
          builder: (context) => Posts(
                navKey: navKey,
              )));
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
                              onChanged: (val) {
                                email = val;
                              },
                              validator: (val) {
                                if (!validator.email(val!)) {
                                  return "Please enter a valid email";
                                }
                                return null;
                              },
                              decoration: textFormFieldStyle(
                                'Email',
                                Icons.email_outlined,
                              ),
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 3,
                            ),
                            TextFormField(
                              onSaved: (val) {
                                password = val!;
                              },
                              decoration: textFormFieldStyle(
                                'Password',
                                Icons.key_outlined,
                                IconButton(
                                  icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.blueAccent),
                                  onPressed: () {
                                    setState(
                                      () {
                                        _passwordVisible = !_passwordVisible;
                                      },
                                    );
                                  },
                                ),
                              ),
                              validator: (val) => val!.isEmpty
                                  ? "password cannot be empty"
                                  : null,
                              obscureText: _passwordVisible,
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
                                  if (status.name == "unknown" ||
                                      status.name == "invalidEmail") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        snackBarError("Erorr",
                                            "Email is not registered try creating an account"));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        snackBarSuccess("Success",
                                            "Check your email to reset password"));
                                  }
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
                  Positioned(
                    top: 5,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed("MainScreen");
                      },
                      icon: const Icon(Icons.arrow_back_outlined),
                      color: Colors.red,
                      iconSize: 30,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Sign In',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
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
