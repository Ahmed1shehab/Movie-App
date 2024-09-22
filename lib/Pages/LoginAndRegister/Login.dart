import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/loginBloc/LoginLogic.dart';
import '../../bloc/loginBloc/LoginState.dart';
import '../../components/toast.dart';
import '../HomeScreen/HomeScreen.dart';

class Loginpage extends StatelessWidget {
  const Loginpage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return BlocProvider(
      create: (context) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.user != null) {
            // Navigate to home screen if user is successfully logged in
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
            showToast(message: 'User successfully signed in');
          }
          if (state.errorMessage != null) {
            showToast(message: state.errorMessage!);
          }
        },
        builder: (context, state) {
          LoginBloc bloc = BlocProvider.of<LoginBloc>(context);

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: const Color.fromRGBO(55, 65, 81, 0),
            ),
            backgroundColor: const Color.fromRGBO(27, 35, 48, 1),
            body: Stack(
              children: [
                // Back Icon
                Positioned(
                  top: 20.0,
                  left: 40.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      backgroundColor: const Color.fromRGBO(55, 65, 81, 0.8),
                      radius: 30,
                      child: Image.asset(
                        'assets/icons/back.png',
                        color: const Color.fromRGBO(17, 24, 39, 0.7),
                        width: 35.0,
                      ),
                    ),
                  ),
                ),
                // Login Header
                const Positioned(
                  top: 120,
                  left: 75,
                  child: Text(
                    'Login or Sign In',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),
                // Input Email
                Positioned(
                  top: 300,
                  left: 40,
                  right: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(43, 58, 84, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: emailController,
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Enter Email',
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        prefixIcon: Image.asset(
                          'assets/icons/email.png',
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                  ),
                ),
                // Password Input
                Positioned(
                  top: 380,
                  left: 40,
                  right: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(43, 58, 84, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: passwordController,
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 18,
                      ),
                      obscureText: !state.isPasswordVisible,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Enter Password",
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        prefixIcon: Image.asset(
                          'assets/icons/padlock.png',
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                        suffixIcon: IconButton(
                          icon: Image.asset(
                            state.isPasswordVisible ? 'assets/icons/hide.png' : 'assets/icons/eye.png',
                            color: const Color.fromRGBO(255, 255, 255, 0.5),
                          ),
                          onPressed: () {
                            bloc.togglePasswordVisibility();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                // Login Button
                Positioned(
                  top: 490,
                  left: 40,
                  right: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(10, 75, 188, 1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: MaterialButton(
                      onPressed: state.isSigningIn
                          ? null
                          : () {
                        bloc.signInWithEmail(
                          emailController.text,
                          passwordController.text,
                        );
                      },
                      child: state.isSigningIn
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                // Google Sign-in Button
                Positioned(
                  top: 560,
                  left: 40,
                  right: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: MaterialButton(
                      onPressed: state.isSigningIn
                          ? null
                          : () {
                        bloc.signInWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/google.png',
                            width: 24,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: Color.fromRGBO(0, 0, 0, 0.7),
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
