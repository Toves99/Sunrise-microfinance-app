import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some error occurred");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Some error occurred");
      return null;
    }
  }

  Future<void> updateUserEmail(String? userEmail, String? newEmail) async {
    try {
      if (_auth.currentUser != null && userEmail != null) {
        await _auth.currentUser!.updateEmail(newEmail!);
      }
    } catch (error) {
      print('Error updating email: $error');
      throw error;
    }
  }

  Future<void> updateUserDetails(String? newEmail, String username) async {
    try {
      if (_auth.currentUser != null && newEmail != null) {
        await _firestore.collection('users').doc(newEmail).update({
          'username': username,
          // Add more fields to update as needed
        });
      }
    } catch (error) {
      print('Error updating user details: $error');
      throw error;
    }
  }
}
