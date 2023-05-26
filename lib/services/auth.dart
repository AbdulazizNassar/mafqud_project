import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mafqud_project/models/currentUser.dart';
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
      final dynamic credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      createUserModel(name, email, ID, phoneNum);
      return credential;
    } on FirebaseAuthException catch (e) {
      return e.code;
    } catch (e) {
      return e;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
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

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      return null;
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
