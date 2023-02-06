import 'package:flutter/material.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:mafqud_project/shared/size_config.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/shared/loading.dart';
import 'package:mafqud_project/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({required this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  GlobalKey<FormState> _formState = new GlobalKey<FormState>();
  bool loading = false;
  String errorMessage = "";

  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return loading ? Loading() : Scaffold(
      body: SingleChildScrollView(
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
                  height: SizeConfig.defaultSize * 5,
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: SizeConfig.defaultSize * 3,
                        right: SizeConfig.defaultSize * 3),
                    child: Form(
                      key: _formState,
                      child: Container(
                        margin:
                        EdgeInsets.only(top: SizeConfig.defaultSize * 28),
                        padding: EdgeInsets.only(
                            top: SizeConfig.defaultSize * 6,
                            bottom: SizeConfig.defaultSize * 2,
                            left: SizeConfig.defaultSize * 2,
                            right: SizeConfig.defaultSize * 2),
                        height: SizeConfig.defaultSize * 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              onSaved: (val) => email = val!,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(color: primaryColor),
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
                                    BorderSide(color: primaryColor)),
                              ),

                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                            TextFormField(
                              onSaved: (val) => password = val!,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: const TextStyle(color: primaryColor),
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
                              validator: (val) => val!.length < 6 ? "Incorrect Password" : null,
                              obscureText: true,
                              onChanged: (val){
                                setState(() => password = val);
                              },
                            ),
                            SizedBox(
                              height: SizeConfig.defaultSize * 2,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                child: const Text(
                                  'Forgot your password?',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                onTap: () {},
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
                                  if (_formState.currentState!.validate()){

                                  }
                                },
                              ),
                            ),
                            ButtonTheme(
                              height: SizeConfig.defaultSize * 3,
                              minWidth: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                child: const Text(
                                  'Sign in with Google',
                                  style: TextStyle(
                                      fontSize: 22, color: Colors.white),
                                ),
                                onPressed: () {},
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
                                    widget.toggleView();
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
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: SizeConfig.defaultSize * 26),
                    height: SizeConfig.defaultSize * 5,
                    width: SizeConfig.defaultSize * 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 6,
                          offset: const Offset(0, 2), // changes position of shadow
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
    );
  }
}