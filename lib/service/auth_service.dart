import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../pages/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthClass {
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  FirebaseAuth auth = FirebaseAuth.instance;

  final storage = const FlutterSecureStorage();

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );
        try {
          UserCredential userCredential = await auth.signInWithCredential(authCredential);
          setLoggedIn();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => const HomePage()), (route) => false);
        }
        on FirebaseAuthException catch (e) {
          final snackBar = SnackBar(content: Text(e.message.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }
    on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> setLoggedIn() async {
    await storage.write(key: "loggedIn", value: FirebaseAuth.instance.currentUser?.uid);
  }

  Future<String?> getLoggedIn() async {
    return await storage.read(key: "loggedIn");
  }

  Future<void> logOut() async {
    try {
      await googleSignIn.signOut();
      await auth.signOut();
      await storage.delete(key: "loggedIn");
    }
    catch (e) {
      null;
    }
  }

  Future<void> verifyPhoneNumber(String phoneNumber, BuildContext context, Function setData) async {

    PhoneVerificationCompleted verificationCompleted = (PhoneAuthCredential phoneAuthCredential) async {
      showSnackBar(context, "Verification Completed");
    };

    PhoneVerificationFailed verificationFailed = (FirebaseAuthException authException) {
      showSnackBar(context, authException.message.toString());
    };

    PhoneCodeSent codeSent = (String verificationId, [int? forceResendingToken]) {
      showSnackBar(context, "OTP Sent");
      setData(verificationId);
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      showSnackBar(context, "Time Out");
    };

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
      );
    }
    on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  Future<void> signInWithOTP(String verificationId, String smsCode, BuildContext context) async {
    try {
      UserCredential userCredential = await auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode));
      setLoggedIn();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => const HomePage()), (route) => false);
    }
    on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message.toString());
    }
  }

  void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
