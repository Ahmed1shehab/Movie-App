import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'LoginState.dart';

class LoginBloc extends Cubit<LoginState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LoginBloc() : super(LoginState(isPasswordVisible: false, isSigningIn: false));

  // Toggle password visibility
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  // Save user details to Firestore
  Future<void> _saveUserDetails(User user) async {
    final userDoc = _firestore.collection('usersDetails').doc(user.uid);
    // Check if user details already exist
    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      // Create new document if it doesn't exist
      await userDoc.set({
        'uid': user.uid,
        'email': user.email,
        'fullName': user.displayName ?? 'No Name', // Handle case where name might be null
        'profileImage': user.photoURL ?? 'No photo', // Handle case where photo might be null
      });
    }
  }

  // Sign in with email and password
  void signInWithEmail(String email, String password) async {
    emit(state.copyWith(isSigningIn: true));
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserDetails(userCredential.user!); // Save user info in Firestore
      emit(state.copyWith(user: userCredential.user, isSigningIn: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isSigningIn: false));
    }
  }

  // Sign in with Google
  void signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
        await _saveUserDetails(userCredential.user!); // Save user info in Firestore
        emit(state.copyWith(user: userCredential.user));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }
}
