import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1E1E1E), 
              Color(0xFF200545), 
              Color(0xFF6200EA), 
            ],
            stops: [0.0, 0.6, 1.0], 
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2), 
              const Text(
                'TASKMASTER',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.white,
                  fontFamily: 'Roboto', 
                ),
              ),

              const SizedBox(height: 40),

              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFF7C4DFF), 
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 100,
                  color: Colors.black54,
                ),
              ),

              const Spacer(flex: 3), 

              
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text(
                  'CADASTRO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 50), 
            ],
          ),
        ),
      ),
    );
  }
}