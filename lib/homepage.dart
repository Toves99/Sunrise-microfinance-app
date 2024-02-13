import 'package:flutter/material.dart';
import 'package:microfinance/userlogin.dart';

import 'aboutpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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
              Padding(
                padding: const EdgeInsets.only(top: 150),
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:
                          (context)=>const About()),
                    );
                  },
                  color: Colors.white,
                  height: 40,
                  textColor: const Color.fromARGB(255, 224, 118, 9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color.fromARGB(255, 224, 118, 9)),
                  ),
                  child: const Text(
                    'About us',
                  ),
                ),
              ),
              const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top:50
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: 30
                      ),
                      child: Text(
                          'Developed By:GeniusLink Creations',style: TextStyle(fontSize: 16,color: Colors.blue,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
Future<void> main() async {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
    home: SplashScreen(),
  ));
}
