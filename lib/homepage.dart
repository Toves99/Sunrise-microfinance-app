import 'package:flutter/material.dart';
import 'package:microfinance/userlogin.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.4, 3.0], // Adjust the stops for a smooth transition
            colors: [
              Color.fromARGB(255, 9, 41, 155), // Darker blue at the top
              Color.fromARGB(255, 224, 118, 9), // Orange at the bottom
            ],
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 70),
                child: Text(
                  'Sunrise Microfinance.',
                  style: TextStyle(
                      fontSize: 23,
                      fontFamily: 'Garamond',
                      color: Colors.white,fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Image.asset('assets/logo.png', height: 140, width: 500),
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome',
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Garamond',
                    color: Color.fromARGB(255, 224, 118, 9),
                    fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Welcome to the new \n Sunrise Microfinance \n app.',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Garamond',
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:
                          (context)=>const LoginPage()),
                    );
                  },
                  child: Text(
                    'Get started',
                  ),
                  color: Color.fromARGB(255, 224, 118, 9),
                  height: 40,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    // handle button press
                  },
                  child: Text(
                    'About us',
                  ),
                  color: Colors.white,
                  height: 40,
                  textColor: Color.fromARGB(255, 224, 118, 9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: Color.fromARGB(255, 224, 118, 9)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
