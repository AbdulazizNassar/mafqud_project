import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafqud_project/models/currentUser.dart';
import '../screens/chat/cubit/chat_cubit.dart';
import 'firebase_exceptions.dart';

class AuthService {
  static late AuthStatus _status;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  //document IDs

  Future createUserModel(
      String name, String email, String ID, String phoneNum) async {
    await _firestore.collection("users").doc(currentUser!.uid).set({
      'name': name,
      'email': email,
      'ID': int.parse(ID),
      'phoneNum': phoneNum,
      "uid": _auth.currentUser!.uid,
      'image': ' ',
      'rating': 0.0,
      'numOfRating': 1,
    });
    UserData(
        uid: currentUser!.uid,
        Name: name,
        email: email,
        phoneNum: phoneNum,
        id: ID);
  }

  // sign in with email and password
  signInWithEmailAndPassword(String email, String password) async {
    try {
      final dynamic credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential;
    } catch (e) {
      return e;
    }
  }

  // register with email and password
  registerWithEmailAndPassword(String name, String email, String password,
      String ID, String phoneNum) async {
    try {
      UserCredential response =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      createUserModel(name, email, ID, phoneNum);
      return response;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential> signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    Query<Map<String, dynamic>> c = await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: googleUser!.email);
    try {
      await _firestore
          .collection("users")
          .doc(AuthService().currentUser!.uid)
          .set({
        'name': googleUser.displayName,
        'email': googleUser.email,
        'ID': 'none',
        'phoneNum': 'none',
        "uid": currentUser!.uid,
        'image': ' ',
        'rating': 0.0,
        'numOfRating': 1,
      });
      ChatCubit.get(context).getUserData();
    } catch (e) {}

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error);
    }
  }

  Future<AuthStatus> resetPassword({required String email}) async {
    await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));
    return _status;
  }
}
