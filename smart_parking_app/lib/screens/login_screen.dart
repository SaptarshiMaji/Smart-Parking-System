import 'package:flutter/material.dart';

import '../services/api_service.dart';

import '../services/session_manager.dart';
import 'forgot_password_screen.dart';
import 'register_screen.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController
      emailController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  bool obscurePassword = true;

  bool isLoading = false;

  Future<void> loginUser() async {

    setState(() {

      isLoading = true;
    });

    try {

      final response =
          await ApiService.loginUser(

        email:
            emailController.text.trim(),

        password:
            passwordController.text.trim(),
      );

      setState(() {

        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          content:
              Text(response["message"]),
        ),
      );

      if (response["success"]) {

        // =========================
        // SAVE USER SESSION
        // =========================

        await SessionManager.saveUser(

          name:
              response["user"]["name"],

          email:
              response["user"]["email"],
        );

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(

            builder: (_) =>
                const DashboardScreen(),
          ),
        );
      }

    } catch (e) {

      setState(() {

        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(

          backgroundColor: Colors.red,

          content:
              Text("Error: $e"),
        ),
      );
    }
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

        child: SafeArea(

          child: SingleChildScrollView(

            padding: const EdgeInsets.all(24),

            child: Column(

              children: [

                const SizedBox(height: 60),

                Container(

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

                        blurRadius: 25,

                        spreadRadius: 5,
                      ),
                    ],
                  ),

                  child: const Icon(

                    Icons.local_parking,

                    size: 80,

                    color: Color(0xFF38BDF8),
                  ),
                ),

                const SizedBox(height: 30),

                const Text(

                  "Welcome Back",

                  style: TextStyle(

                    fontSize: 32,

                    fontWeight:
                        FontWeight.bold,

                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(

                  "Login to continue",

                  style: TextStyle(

                    fontSize: 16,

                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 50),

                buildTextField(

                  controller:
                      emailController,

                  hint: "Email",

                  icon: Icons.email,
                ),

                const SizedBox(height: 20),

                buildTextField(

                  controller:
                      passwordController,

                  hint: "Password",

                  icon: Icons.lock,

                  obscure:
                      obscurePassword,

                  suffixIcon: IconButton(

                    onPressed: () {

                      setState(() {

                        obscurePassword =
                            !obscurePassword;
                      });
                    },

                    icon: Icon(

                      obscurePassword

                          ? Icons.visibility

                          : Icons.visibility_off,

                      color: Colors.white70,
                    ),
                  ),
                ),
Align(

  alignment:
      Alignment.centerRight,

  child: TextButton(

    onPressed: () {

      Navigator.push(

        context,

        MaterialPageRoute(

          builder: (_) =>
              const ForgotPasswordScreen(),
        ),
      );
    },

    child: const Text(

      "Forgot Password?",

      style: TextStyle(

        color:
            Color(0xFF38BDF8),
      ),
    ),
  ),
),
                const SizedBox(height: 35),

                SizedBox(

                  width: double.infinity,

                  height: 60,

                  child: ElevatedButton(

                    style:
                        ElevatedButton.styleFrom(

                      backgroundColor:
                          const Color(
                              0xFF38BDF8),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius
                                .circular(18),
                      ),
                    ),

                    onPressed:
                        isLoading
                            ? null
                            : loginUser,

                    child: isLoading

                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )

                        : const Text(

                            "Login",

                            style: TextStyle(

                              fontSize: 18,

                              fontWeight:
                                  FontWeight.bold,

                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                Row(

                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [

                    const Text(

                      "Don't have an account?",

                      style: TextStyle(

                        color: Colors.white70,
                      ),
                    ),

                    TextButton(

                      onPressed: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(

                            builder: (_) =>
                                const RegisterScreen(),
                          ),
                        );
                      },

                      child: const Text(

                        "Register",

                        style: TextStyle(

                          color:
                              Color(0xFF38BDF8),

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({

    required TextEditingController
        controller,

    required String hint,

    required IconData icon,

    bool obscure = false,

    Widget? suffixIcon,
  }) {

    return TextField(

      controller: controller,

      obscureText: obscure,

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(

        hintText: hint,

        hintStyle: const TextStyle(
          color: Colors.white54,
        ),

        prefixIcon: Icon(
          icon,
          color: Colors.white70,
        ),

        suffixIcon: suffixIcon,

        filled: true,

        fillColor:
            Colors.white.withOpacity(0.08),

        border: OutlineInputBorder(

          borderRadius:
              BorderRadius.circular(18),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}