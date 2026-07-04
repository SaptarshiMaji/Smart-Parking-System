import 'package:flutter/material.dart';

import '../services/api_service.dart';

class ForgotPasswordScreen
    extends StatefulWidget {

  const ForgotPasswordScreen(
      {super.key});

  @override
  State<ForgotPasswordScreen>
      createState() =>
          _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final confirmController =
      TextEditingController();

  bool isLoading = false;

  Future<void> resetPassword() async {

    if (passwordController.text !=
        confirmController.text) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content: Text(
              "Passwords do not match"),
        ),
      );

      return;
    }

    setState(() {

      isLoading = true;
    });

    final response =
        await ApiService
            .forgotPassword(

      email: emailController.text
          .trim(),

      newPassword:
          passwordController.text
              .trim(),
    );

    setState(() {

      isLoading = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(

      SnackBar(

        content: Text(
            response["message"]),
      ),
    );

    if (response["success"]) {

      Navigator.pop(context);
    }
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
            "Forgot Password"),
      ),

      body: Padding(

        padding:
            const EdgeInsets.all(20),

        child: Column(

          children: [

            TextField(

              controller:
                  emailController,

              decoration:
                  const InputDecoration(

                labelText: "Email",
              ),
            ),

            const SizedBox(
                height: 15),

            TextField(

              controller:
                  passwordController,

              obscureText: true,

              decoration:
                  const InputDecoration(

                labelText:
                    "New Password",
              ),
            ),

            const SizedBox(
                height: 15),

            TextField(

              controller:
                  confirmController,

              obscureText: true,

              decoration:
                  const InputDecoration(

                labelText:
                    "Confirm Password",
              ),
            ),

            const SizedBox(
                height: 30),

            ElevatedButton(

              onPressed:
                  isLoading
                      ? null
                      : resetPassword,

              child: isLoading

                  ? const CircularProgressIndicator()

                  : const Text(
                      "Reset Password"),
            ),
          ],
        ),
      ),
    );
  }
}