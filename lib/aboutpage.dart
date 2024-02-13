import 'package:flutter/material.dart';
import 'package:microfinance/userlogin.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _About();
}

class _About extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 270),
              child: Image.asset('assets/logo.png', height: 140, width: 500),
            ),
            const SizedBox(height: 10),
            const Text(
              'Grow With Us!',
              style: TextStyle(
                  fontSize: 40,
                  fontFamily: 'Garamond',
                  color: Color.fromARGB(255, 224, 118, 9),
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Save your future Now ',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Garamond',
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),
            const Text(
              'With Sunrise Microfinance',
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


          ],
        ),
      ),
    );
  }
}
Future<void> main() async {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: About(),
  ));
}
