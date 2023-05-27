import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:two_du/pages/phone_auth_page.dart';
import 'home_page.dart';
import 'login_page.dart';
import '../service/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUpPage> {
  firebase_auth.FirebaseAuth firebaseAuth = firebase_auth.FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool circular = false;

  AuthClass authClass = AuthClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(
                    fontSize: 36,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              buttonItem("assets/google.svg", "Continue with Google", 25,
                  () async {
                await authClass.signInWithGoogle(context);
              }),
              const SizedBox(height: 10),
              buttonItem("assets/phone.svg", "Continue with phone", 25, () {
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => const PhoneAuthPage()));
                }),
              const SizedBox(height: 20),
              const Text(
                "Or",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              const SizedBox(height: 20),
              textInput("Email address", emailController),
              const SizedBox(height: 10),
              textInput("Set password", passwordController, obscureText: true),
              const SizedBox(height: 20),
              submitButton("Sign Up"),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Text(
                  "Already have an account? ",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (builder) => LoginPage()),
                        (route) => false);
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                        color: Color(0xff8711c1),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget submitButton(String buttonText) {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          firebase_auth.UserCredential userCredential =
              await firebaseAuth.createUserWithEmailAndPassword(
                  email: emailController.text,
                  password: passwordController.text);
          setState(() {
            circular = false;
          });
          authClass.setLoggedIn();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => const HomePage()), (route) => false);
        } on firebase_auth.FirebaseAuthException catch (e) {
          final snackBar = SnackBar(content: Text(e.message.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 200),
        width: MediaQuery.of(context).size.width - 200,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: const LinearGradient(
            colors: [
              Color(0xff8a32f1),
              Color(0xffad32f9),
            ],
          ),
        ),
        child: Center(
          child: circular
              ? const CircularProgressIndicator()
              : Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
        ),
      ),
    );
  }

  Widget textInput(String labelText, TextEditingController controller,
      {bool obscureText = false}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      width: MediaQuery.of(context).size.width - 60,
      height: 60,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 1,
              color: Color(0xff8711c1),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget buttonItem(String imagePath, String buttonText, double size,
      void Function()? onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                imagePath,
                height: size,
                width: size,
              ),
              const SizedBox(width: 15),
              Text(
                buttonText,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
