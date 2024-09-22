import 'package:flutter/material.dart';
import '../components/submit_btn.dart';
import 'LoginAndRegister/Login.dart';
import 'LoginAndRegister/Register.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(27, 35, 48, 1),
      ),
      body: Container(
        color: const Color.fromRGBO(27, 35, 48, 1),
        child: Stack(
          children: [
            Positioned(
              top: 80.0,
              right: 30.0,
              child: Image.asset('assets/images/M64.png'),
            ),
            const Positioned(
              top: 50.0,
              left: 30.0,
              child: Text(
                'Welcome',
                style: TextStyle(
                  fontFamily: 'NerkoOne',
                  fontSize: 80,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Positioned(
              top: 125.0,
              left: 30.0,
              child: Text(
                'To',
                style: TextStyle(
                  fontFamily: 'NerkoOne',
                  fontSize: 80,
                  color: Colors.white,
                ),
              ),
            ),
            const Positioned(
              top: 200.0,
              left: 30.0,
              child: Text(
                'Movie List',
                style: TextStyle(
                  fontFamily: 'NerkoOne',
                  fontSize: 80,
                  color: Colors.white,
                ),
              ),
            ),
            // Login Button
            Positioned(
              top: 400,
              left: 50,
              child: buildActionButton(
                context: context,
                text: 'Login',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) {
                      return const Loginpage(); // Separate Login Page
                    }),
                  );
                },
              ),
            ),
            // Register Button
            Positioned(
              top: 500,
              left: 50,
              child: buildActionButton(
                context: context,
                text: 'Register',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (c) {
                      return  RegisterPage(); // Register Page
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


// Reusable Action Button
}
