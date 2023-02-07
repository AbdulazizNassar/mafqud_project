import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animate_do/animate_do.dart';
import 'package:mafqud_project/screens/Authentication/sign_in.dart';

class MainScreen extends StatelessWidget {
  final Duration duration = const Duration(milliseconds: 800);

  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      body: Container(
        margin: const EdgeInsets.all(8),
        width: size.width,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ///
            FadeInUp(
              duration: duration,
              delay: const Duration(milliseconds: 2000),
              child: Container(
                margin: const EdgeInsets.only(
                  top: 50,
                  left: 5,
                  right: 5,
                ),
                width: size.width,
                height: size.height / 2,
                child: Lottie.asset("assets/wl.json", animate: true),
              ),
            ),

            ///
            const SizedBox(
              height: 15,
            ),

            /// TITLE
            FadeInUp(
              duration: duration,
              delay: const Duration(milliseconds: 1600),
              child: const Text(
                "Mafqud",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),
            ),

            ///
            const SizedBox(
              height: 10,
            ),

            /// SUBTITLE
            FadeInUp(
              duration: duration,
              delay: const Duration(milliseconds: 1000),
              child: const Text(
                "Find and retrieve your lost items easier than before! ",
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.2,
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w300),
              ),
            ),

            ///
            Expanded(child: Container()),

            /// GOOGLE BTN
            FadeInUp(
              duration: duration,
              delay: const Duration(milliseconds: 200),
              child: SizedBox(
                width: 150 ,
                child: ElevatedButton.icon(
                  onPressed: (){Navigator.of(context).pushNamed("SignIn");},
                  icon: const Icon(
                    Icons.email,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.grey,
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  ),
                  label: const Text("Login")
            ),
              ),
            ),
            ///
            const SizedBox(
              height: 15,
            ),

            /// GITHUB BTN
            FadeInUp(
              duration: duration,
              delay: const Duration(milliseconds: 200),
              child: ElevatedButton.icon(
                  onPressed: (){Navigator.of(context).pushNamed("Register");},
                  icon: const Icon(
                    Icons.email,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  style: ElevatedButton.styleFrom(
                    shadowColor: Colors.grey,
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
                  ),
                  label: const Text("Create an account")
              ),
            ),
            ///
            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}

class SButton extends StatelessWidget {
  const SButton({
    Key? key,
    required this.size,
    required this.color,
    required this.borderColor,
    required this.img,
    required this.text,
    required this.textStyle,
  }) : super(key: key);

  final Size size;
  final Color color;
  final Color borderColor;
  final String img;
  final String text;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: ((context) => const MainScreen()),
          ),
        );
      },
      child: Container(
        width: size.width / 1.2,
        height: size.height / 15,
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor, width: 1)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              img,
              height: 40,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
