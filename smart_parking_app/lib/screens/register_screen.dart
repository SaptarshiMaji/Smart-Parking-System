import 'package:flutter/material.dart';

import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final TextEditingController
      nameController =
      TextEditingController();

  final TextEditingController
      emailController =
      TextEditingController();

  final TextEditingController
      phoneController =
      TextEditingController();

  final TextEditingController
      passwordController =
      TextEditingController();

  final TextEditingController
      confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;

  bool obscureConfirmPassword = true;

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

                const SizedBox(height: 30),

                Container(

                  padding:
                      const EdgeInsets.all(22),

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

                    Icons.person_add_alt_1,

                    size: 75,

                    color: Color(0xFF38BDF8),
                  ),
                ),

                const SizedBox(height: 25),

                const Text(

                  "Create Account",

                  style: TextStyle(

                    fontSize: 30,

                    fontWeight:
                        FontWeight.bold,

                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(

                  "Register to continue",

                  style: TextStyle(

                    fontSize: 16,

                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 40),

                buildTextField(

                  controller: nameController,

                  hint: "Full Name",

                  icon: Icons.person,
                ),

                const SizedBox(height: 18),

                buildTextField(

                  controller: emailController,

                  hint: "Email",

                  icon: Icons.email,
                ),

                const SizedBox(height: 18),

                buildTextField(

                  controller: phoneController,

                  hint: "Phone Number",

                  icon: Icons.phone,
                ),

                const SizedBox(height: 18),

                buildTextField(

                  controller:
                      passwordController,

                  hint: "Password",

                  icon: Icons.lock,

                  obscure: obscurePassword,

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

                const SizedBox(height: 18),

                buildTextField(

                  controller:
                      confirmPasswordController,

                  hint: "Confirm Password",

                  icon: Icons.lock_outline,

                  obscure:
                      obscureConfirmPassword,

                  suffixIcon: IconButton(

                    onPressed: () {

                      setState(() {

                        obscureConfirmPassword =
                            !obscureConfirmPassword;
                      });
                    },

                    icon: Icon(

                      obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,

                      color: Colors.white70,
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

                    onPressed: () async {

                      if (

                          passwordController.text !=
                          confirmPasswordController.text
                      ) {

                        ScaffoldMessenger.of(context)
                            .showSnackBar(

                          const SnackBar(

                            content:
                                Text("Passwords do not match"),
                          ),
                        );

                        return;
                      }

                      final response =
                          await ApiService.registerUser(

                        name:
                            nameController.text,

                        email:
                            emailController.text,

                        phone:
                            phoneController.text,

                        password:
                            passwordController.text,
                      );

                      ScaffoldMessenger.of(context)
                          .showSnackBar(

                        SnackBar(

                          content:
                              Text(response["message"]),
                        ),
                      );

                      if (response["success"]) {

                        Navigator.pop(context);
                      }
                    },

                    child: const Text(

                      "Register",

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

                      "Already have an account?",

                      style: TextStyle(

                        color: Colors.white70,
                      ),
                    ),

                    TextButton(

                      onPressed: () {

                        Navigator.pop(context);
                      },

                      child: const Text(

                        "Login",

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