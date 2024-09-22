import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../bloc/passwordBloc/passwordLogic.dart';
import '../../../bloc/passwordBloc/passwordState.dart';


class ChangePasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Change Password',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: 'NerkoOne',
          ),
        ),
        leading: Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        backgroundColor: const Color.fromRGBO(27, 35, 48, 1),
      ),
      backgroundColor: const Color.fromRGBO(27, 35, 48, 1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocProvider(
          create: (_) => PasswordLogic(
            FirebaseAuth.instance,
            FirebaseFirestore.instance,
          ),
          child: PasswordForm(),
        ),
      ),
    );
  }
}

class PasswordForm extends StatelessWidget {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordLogic, PasswordState>(
      builder: (context, state) {
        return Column(
          children: [
            TextFormField(
              controller: _currentPasswordController,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Current Password',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'NerkoOne', fontSize: 18),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'New Password',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'NerkoOne', fontSize: 18),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Confirm New Password',
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'NerkoOne', fontSize: 18),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            state.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                context.read<PasswordLogic>().changePassword(
                  _currentPasswordController.text,
                  _newPasswordController.text,
                  _confirmPasswordController.text,
                );
              },
              child: Text(
                'Update Password',
                style: TextStyle(
                  fontSize: 20,
                  color: const Color.fromRGBO(27, 35, 48, 1),
                  fontFamily: 'NerkoOne',
                ),
              ),
            ),
            if (state.errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  state.errorMessage,
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }
}
