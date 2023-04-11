import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './firebaseFunctions.dart';
import '../auth/login.dart';

class AuthServices {
  static signupUser(
      String email, String password, String name, BuildContext context) async {
    debugPrint("SIGN UPPP");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginForm(),
      ),
    );
    // try {
    //   UserCredential userCredential = await FirebaseAuth.instance
    //       .createUserWithEmailAndPassword(email: email, password: password);

    //   // Send email verification to user
    //   await userCredential.user!.sendEmailVerification();

    //   await FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    //   await FirebaseAuth.instance.currentUser!.updateEmail(email);
    //   await FirestoreServices.saveUser(name, email, userCredential.user!.uid);

    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content: Text('Registration Successful, Please verify your email')));

    //   await Future.delayed(Duration(seconds: 4));

    //   // Log user out after successful registration
    //   await FirebaseAuth.instance.signOut();
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => LoginForm(),
    //     ),
    //   );
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('Password Provided is too weak')));
    //   } else if (e.code == 'email-already-in-use') {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('Email Provided already Exists')));
    //   }
    // } catch (e) {
    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text(e.toString())));
    // }
  }

  static signinUser(String email, String password, BuildContext context) async {
    debugPrint("SIGN IN");
    // try {
    //   await FirebaseAuth.instance
    //       .signInWithEmailAndPassword(email: email, password: password);

    //   ScaffoldMessenger.of(context)
    //       .showSnackBar(SnackBar(content: Text('You are Logged in')));
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(content: Text('No user Found with this Email')));
    //   } else if (e.code == 'wrong-password') {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text('Incorrect Password')));
    //   }
    // }
  }
}
