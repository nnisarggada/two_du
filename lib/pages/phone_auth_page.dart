import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'dart:async';
import 'package:two_du/service/auth_service.dart';

class PhoneAuthPage extends StatefulWidget {
  const PhoneAuthPage({Key? key}) : super(key: key);

  @override
  PhoneAuthPageState createState() => PhoneAuthPageState();
}

class PhoneAuthPageState extends State<PhoneAuthPage> {

  int start = 30;
  bool wait = false;
  String buttonName = "Send";
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  AuthClass authClass = AuthClass();
  String verificationIdFinal = "";
  String smsCode = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 24),),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 200),
              textField(),
              const SizedBox(height: 40),
              Container(
                constraints: const BoxConstraints(maxWidth: 500),
                width: MediaQuery.of(context).size.width - 40,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                    const Text(
                      "Enter the OTP",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Colors.grey,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              optField(),
              const SizedBox(height: 80),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: "Send OTP again in ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: start < 10 ? "00:0$start" : "00:$start",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const TextSpan(
                      text: " secs",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  authClass.signInWithOTP(verificationIdFinal, smsCode, context);
                },
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 200),
                  height: 60,
                  width: MediaQuery.of(context).size.width - 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff8a32f1),
                        Color(0xffad32f9),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: const Center(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer timer = Timer.periodic(oneSec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      }
      else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget optField() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: OTPTextField(
        length: 6,
        width: MediaQuery.of(context).size.width - 40,
        fieldWidth: 50,
        otpFieldStyle: OtpFieldStyle(
          backgroundColor: const Color(0xff1d1d1d),
          borderColor: Colors.white,
        ),
        style: const TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        textFieldAlignment: MainAxisAlignment.spaceAround,
        fieldStyle: FieldStyle.underline,
        onCompleted: (pin) {
          setState(() {
            smsCode = pin;
          });
        },
      ),
    );
  }

  Widget textField() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500),
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        style: const TextStyle(color: Colors.white),
        controller: phoneController,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Enter Your Phone Number",
          hintStyle: const TextStyle(
            color: Colors.white54,
            fontSize: 16,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 0),
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(vertical: 22, horizontal: 15),
            child: Text(
              "(+91)",
              style: TextStyle(color: Colors.white, fontSize: 16,),
            ),
          ),
          suffixIcon: InkWell(
            onTap: wait ? null : () async {
              startTimer();
              setState(() {
                wait = true;
                buttonName = "Resend";
                start = 30;
              });
              await authClass.verifyPhoneNumber("+91${phoneController.text}", context, setData);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 15),
              child: Text(
                buttonName,
                style: TextStyle(color: wait ? Colors.grey : const Color(0xffad32f9), fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTimer();
  }
}
