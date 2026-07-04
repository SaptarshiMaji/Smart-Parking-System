import 'dart:async';

import 'package:flutter/material.dart';

import '../services/session_manager.dart';

import 'login_screen.dart';
import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  late Animation<double> _animation;

  @override
  void initState() {

    super.initState();

    _controller = AnimationController(

      vsync: this,

      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(

      parent: _controller,

      curve: Curves.easeInOut,
    );

    _controller.forward();

    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {

    bool isLoggedIn =
        await SessionManager.isLoggedIn();

    Timer(

      const Duration(seconds: 3),

      () {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>

                isLoggedIn

                    ? const DashboardScreen()

                    : const LoginScreen(),
          ),
        );
      },
    );
  }

  @override
  void dispose() {

    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            colors: [

              Color(0xFF0F172A),

              Color(0xFF1E293B),
            ],

            begin: Alignment.topLeft,

            end: Alignment.bottomRight,
          ),
        ),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            ScaleTransition(

              scale: _animation,

              child: Container(

                padding:
                    const EdgeInsets.all(25),

                decoration: BoxDecoration(

                  shape: BoxShape.circle,

                  color: Colors.white
                      .withOpacity(0.08),

                  boxShadow: [

                    BoxShadow(

                      color: Colors.blue
                          .withOpacity(0.4),

                      blurRadius: 30,

                      spreadRadius: 5,
                    ),
                  ],
                ),

                child: const Icon(

                  Icons.local_parking,

                  size: 90,

                  color: Color(0xFF38BDF8),
                ),
              ),
            ),

            const SizedBox(height: 35),

            const Text(

              "Smart Parking",

              style: TextStyle(

                fontSize: 34,

                fontWeight:
                    FontWeight.bold,

                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            const Text(

              "Smart Parking System",

              style: TextStyle(

                fontSize: 16,

                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 50),

            const CircularProgressIndicator(

              color: Color(0xFF38BDF8),
            ),
          ],
        ),
      ),
    );
  }
}