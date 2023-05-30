import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/screens/Authentication/sign_in.dart';
import 'package:mafqud_project/services/auth.dart';
import 'package:mafqud_project/shared/size_config.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../../shared/loading.dart';
import '../chat/cubit/chat_cubit.dart';
import '../posts/posts.dart';

class Register extends StatefulWidget {
  const Register({super.key, this.navKey});
  final navKey;
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();
  var email, password, idNum, PhoneNum, name;
  bool _passwordVisible = true;

  signup() async {
    var formData = _formState.currentState;
    if (formData!.validate()) {
      formData.save();
      UserCredential? response = await AuthService()
          .registerWithEmailAndPassword(name, email, password, idNum, PhoneNum);
      uId = response!.user!.uid;
      ChatCubit.get(context).getUserData();
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return isLoading
        ? Loading()
        : Scaffold(
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
                              // margin:
                              // EdgeInsets.fromLTRB(SizeConfig.defaultSize * 2,SizeConfig.defaultSize * 4,SizeConfig.defaultSize * 2,0),
                              padding: EdgeInsets.only(
                                  top: SizeConfig.defaultSize * 8,
                                  left: SizeConfig.defaultSize * 3,
                                  right: SizeConfig.defaultSize * 1),
                              height: MediaQuery.of(context).size.height,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                              ),
                              child: Column(
                                children: <Widget>[
                                  //Name Field
                                  TextFormField(
                                    onSaved: (val) {
                                      name = val!;
                                    },
                                    validator: (val) =>
                                        val!.isEmpty ? "Cannot be empty" : null,
                                    decoration: InputDecoration(
                                      labelText: 'Name',
                                      labelStyle:
                                          const TextStyle(color: primaryColor),
                                      prefixIcon: Icon(
                                        Icons.abc,
                                        size: SizeConfig.defaultSize * 4,
                                        color: primaryColor,
                                      ),
                                      filled: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: primaryColor)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.defaultSize * 2,
                                  ),

                                  //Email Field
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
                                      decoration: textFormFieldStyle(
                                          'Email', Icons.email)),
                                  SizedBox(
                                    height: SizeConfig.defaultSize * 2,
                                  ),

                                  //password Field
                                  TextFormField(
                                    onSaved: (val) {
                                      password = val!;
                                    },
                                    obscureText: _passwordVisible,
                                    validator: (val) => val!.length < 6
                                        ? "Password must be at least 6 characters long"
                                        : null,
                                    decoration: textFormFieldStyle(
                                      "Password",
                                      Icons.key_outlined,
                                      IconButton(
                                        icon: Icon(
                                          _passwordVisible
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: Colors.blueAccent,
                                        ),
                                        onPressed: () {
                                          setState(
                                            () {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.defaultSize * 2,
                                  ),

                                  //ID num Field
                                  TextFormField(
                                    onSaved: (val) {
                                      idNum = val!;
                                    },
                                    validator: (val) => val!.length < 10
                                        ? "Incorrect ID number"
                                        : null,
                                    decoration: InputDecoration(
                                      labelText: 'ID',
                                      labelStyle:
                                          const TextStyle(color: primaryColor),
                                      prefixIcon: Icon(
                                        Icons.perm_identity,
                                        size: SizeConfig.defaultSize * 2,
                                        color: primaryColor,
                                      ),
                                      filled: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: primaryColor)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.defaultSize * 2,
                                  ),

                                  //phone num Field
                                  TextFormField(
                                    onSaved: (val) {
                                      PhoneNum = val!;
                                    },
                                    validator: (val) => val!.length < 10
                                        ? "Phone Number must be 10 numbers long"
                                        : null,
                                    decoration: InputDecoration(
                                      labelText: 'Phone Number',
                                      labelStyle:
                                          const TextStyle(color: primaryColor),
                                      prefixIcon: Icon(
                                        Icons.phone,
                                        size: SizeConfig.defaultSize * 2,
                                        color: primaryColor,
                                      ),
                                      filled: true,
                                      enabledBorder: UnderlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                              color: primaryColor)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.defaultSize * 8,
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
                                              fontSize: 30,
                                              color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          try {
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await signup();
                                            navKey.currentState!
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Posts(
                                                              navKey: navKey,
                                                            )));
                                            setState(() {
                                              isLoading = false;
                                            });
                                          } catch (e) {
                                            print("eeeeeeeeeeeeeeee");
                                            print(e);
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
                                        "Have an account? ",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          navKey.currentState!
                                              .push(MaterialPageRoute(
                                                  builder: (context) => SignIn(
                                                        navKey: widget.navKey,
                                                      )));
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
                        Center(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: SizeConfig.defaultSize * 1),
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
                                      0, 1), // changes position of shadow
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
