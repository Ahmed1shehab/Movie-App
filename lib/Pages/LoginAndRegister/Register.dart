
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/RegisterBloc/RegisterLogic.dart';
import '../../bloc/RegisterBloc/RegisterState.dart';
import '../../components/toast.dart';
import '../../user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import '../HomeScreen/HomeScreen.dart';
import 'Login.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(FirebaseAuthServices()),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.signUpSuccess == true) {
            showToast(message: 'User is successfully Created !!');
            Navigator.of(context).push(MaterialPageRoute(builder: (c) => const HomeScreen()));
          } else if (state.signUpSuccess == false) {
            showToast(message: 'Some error happened');
          }
        },
        builder: (context, state) {
          RegisterBloc obj = BlocProvider.of<RegisterBloc>(context);
          String pass = 'assets/icons/eye.png';
          String pass2 = 'assets/icons/hide.png';

          return Scaffold(
            backgroundColor: const Color.fromRGBO(27, 35, 48, 1),
            body: Stack(
              children: [
                // BACK ICON
                Positioned(
                  top: 60.0, // Adjust the vertical position
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
                        width: 35.0, // Adjust size if needed
                      ),
                    ),
                  ),
                ),

                // Register Header
                const Positioned(
                  top: 165,
                  left: 140,
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(255, 255, 255, 1),
                    ),
                  ),
                ),

                // Create new account Text
                const Positioned(
                  top: 215,
                  left: 100,
                  child: Text(
                    'Create Your New Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(186, 186, 186, 1),
                    ),
                  ),
                ),

                // Input FullName
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
                      controller: _usernameController,
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Enter Full Name",
                        hintStyle: const TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 1),
                        ),
                        prefixIcon: Image.asset(
                          'assets/icons/user.png',
                          color: const Color.fromRGBO(255, 255, 255, 1),
                        ),
                      ),
                    ),
                  ),
                ),

                // Input Email
                Positioned(
                  top: 370,
                  left: 40,
                  right: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(43, 58, 84, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _emailController,
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

                // Password
                Positioned(
                  top: 440,
                  left: 40,
                  right: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(43, 58, 84, 1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1),
                        fontSize: 18,
                      ),
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
                            state.isPasswordVisible ? pass2 : pass,
                            color: const Color.fromRGBO(255, 255, 255, 0.5),
                          ),
                          onPressed: () {
                            obj.togglePasswordVisibility();
                          },
                        ),
                      ),

                      obscureText: !state.isPasswordVisible,
                    ),
                  ),
                ),

                // Button Login (Updated)
                Positioned(
                  top: 530,
                  left: 40,
                  right: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(10, 75, 188, 1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        final username = _usernameController.text;
                        final email = _emailController.text;
                        final password = _passwordController.text;

                        if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                          // Call the BLoC signUp method
                          context.read<RegisterBloc>().signUp(username, email, password);
                        } else {
                          // Show error if any field is empty
                          showToast(message: 'Please fill all fields');
                        }
                      },
                      child: state.isSigningUp
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),




                // Already have account
                Positioned(
                  top: 600, // Adjust this value as needed
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Column(
                      children: [
                        const Text(
                          'Already have an account ? ',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Center(
                          child: Container(
                            width:400,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(125, 188, 250, 1),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: TextButton(
                              child: const Text(
                                'Sign In ',
                                style: TextStyle(
                                  color: Color.fromRGBO(125, 188, 250, 1),
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                  fontSize: 20,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (c) {
                                    return  const Loginpage();
                                  }),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
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