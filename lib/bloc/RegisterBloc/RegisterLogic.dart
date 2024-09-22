import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import '../../user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'RegisterState.dart';

class RegisterBloc extends Cubit<RegisterState> {
  final FirebaseAuthServices _auth;
  final String defaultProfileImage = 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'; // URL of the default image

  RegisterBloc(this._auth) : super(RegisterState(isPasswordVisible: false, isSigningUp: false));

  // Toggle the password visibility
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  // Sign up logic with saving user details to Firestore
  Future<void> signUp(String username, String email, String password) async {
    emit(state.copyWith(isSigningUp: true));

    try {
      // Sign up the user
      User? user = await _auth.signUpWithEmailAndPassword(email, password);

      emit(state.copyWith(isSigningUp: false));

      if (user != null) {
        // Save user details to Firestore
        await FirebaseFirestore.instance.collection('usersDetails').doc(user.uid).set({
          'fullName': username,
          'email': email,
          'password': password,
          'profileImage': defaultProfileImage,
        });

        // Emit success state
        emit(state.copyWith(signUpSuccess: true));
      } else {
        // Emit failure state
        emit(state.copyWith(signUpSuccess: false));
      }
    } catch (e) {
      // Handle any errors that occur during sign up or Firestore operation
      emit(state.copyWith(isSigningUp: false, signUpSuccess: false));
      print('Error during sign-up: $e');
    }
  }
}
