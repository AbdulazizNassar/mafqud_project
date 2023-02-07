import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/shared/size_config.dart';
import 'package:mafqud_project/shared/constants.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  var email, password;
  signup() async {
    var formData = _formState.currentState;
    if (formData!.validate()) {
      formData.save();
      UserCredential response =
      await AuthService().registerWithEmailAndPassword(email, password);
      if(response != null){
      Navigator.of(context).pushNamed("Home");
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
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: SizeConfig.defaultSize * 3,
                          right: SizeConfig.defaultSize * 3),
                      child: Form(
                        key: _formState,
                        child: Container(
                          margin:
                              EdgeInsets.only(top: SizeConfig.defaultSize * 20),
                          padding: EdgeInsets.only(
                              top: SizeConfig.defaultSize * 5,
                              bottom: SizeConfig.defaultSize * 2,
                              left: SizeConfig.defaultSize * 2,
                              right: SizeConfig.defaultSize * 2),
                          height: SizeConfig.defaultSize * 70,
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
                                validator: (val) => val!.isEmpty
                                    ? "Please supply a valid email"
                                    : null,
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
                                onSaved: (val) {
                                  password = val!;
                                },
                                obscureText: true,
                                validator: (val) => val!.length < 6
                                    ? "Password must be at least 6 characters long"
                                    : null,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: TextStyle(color: primaryColor),
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
                                          BorderSide(color: primaryColor)),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.defaultSize * 2,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Fullname',
                                  labelStyle: TextStyle(color: primaryColor),
                                  prefixIcon: Icon(
                                    Icons.person,
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
                                height: SizeConfig.defaultSize * 5,
                                minWidth: MediaQuery.of(context).size.width,
                                child: ElevatedButton(
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                          fontSize: 22, color: Colors.white),
                                    ),
                                    onPressed: () async { await signup();}
                              ),
                              ),
                              SizedBox(
                                height: SizeConfig.defaultSize * 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text(
                                    "Have an account? ",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushNamed("SignIn");
                                    },
                                    child: const Text(
                                      'Sign In',
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
                      margin: EdgeInsets.only(top: SizeConfig.defaultSize * 17),
                      height: SizeConfig.defaultSize * 5,
                      width: SizeConfig.defaultSize * 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 6,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Register',
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
