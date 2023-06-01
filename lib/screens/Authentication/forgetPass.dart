import 'package:flutter/material.dart';
import 'package:mafqud_project/main.dart';
import 'package:mafqud_project/shared/constants.dart';
import 'package:mafqud_project/shared/showToast.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../../services/auth.dart';
import '../../services/firebase_exceptions.dart';
import '../../shared/AlertBox.dart';

class forgotPasswordPopUp extends StatefulWidget {
  const forgotPasswordPopUp({super.key});

  @override
  State<forgotPasswordPopUp> createState() => _forgotPasswordPopUpState();
}

class _forgotPasswordPopUpState extends State<forgotPasswordPopUp> {
  final GlobalKey<FormState> _formState = GlobalKey<FormState>();

  String? email;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        showDialog(
            barrierDismissible: true,
            useRootNavigator: true,
            useSafeArea: true,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  content: Container(
                padding: const EdgeInsets.all(10),
                height: 370,
                child: Stack(children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Forgot Password",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                      const SizedBox(height: 5),
                      Text("Enter your email to reset your password",
                          style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 30.0),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.shade200,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.mail_outline_rounded, size: 40.0),
                            const SizedBox(width: 10.0),
                            Expanded(
                              child: Form(
                                  key: _formState,
                                  child: TextFormField(
                                    onChanged: (val) {
                                      email = val;
                                    },
                                    validator: (val) {
                                      if (!validator.email(val!) ||
                                          val.isEmpty) {
                                        return "Please enter a valid email";
                                      }
                                      return null;
                                    },
                                    decoration: const InputDecoration(
                                      label: Text("Email"),
                                      hintText: "Email",
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: SizedBox(
                          height: 50,
                          width: 150,
                          child: ElevatedButton(
                            onPressed: () async {
                              var formData = _formState.currentState;

                              if (formData!.validate()) {
                                formData.save();

                                if (email != null) {
                                  try {
                                    AuthStatus status = await AuthService()
                                        .resetPassword(email: email as String);
                                    if (status.name == "unknown" ||
                                        status.name == "invalidEmail") {
                                      showToast(
                                          text:
                                              "Email is not registered try creating an account",
                                          state: ToastStates.error);
                                    } else {
                                      navKey.currentState!.pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBarSuccess(
                                              "Successfully Sent an email",
                                              "Check your inbox"));
                                    }
                                  } catch (e) {}
                                }
                              }
                            },
                            style: btnStyle,
                            child: const Text(
                              "Send",
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ]),
              ));
            });
      },
      child: const Text(
        "Reset Password ?",
        style: TextStyle(
          fontSize: 15,
          decoration: TextDecoration.underline,
          color: Colors.blue,
        ),
      ),
    );
  }
}
