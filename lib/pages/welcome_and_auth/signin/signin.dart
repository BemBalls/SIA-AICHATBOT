import 'package:omnichat/pages/jim_chat/chat_screen.dart';
import 'package:omnichat/pages/welcome_and_auth/signup/signup.dart';
import 'package:omnichat/pages/welcome_and_auth/widgets/auth_button.dart';
import 'package:omnichat/widgets/fade_slide_up.dart';
import 'package:omnichat/widgets/header.dart';
import 'package:omnichat/widgets/response_page.dart';
import 'package:flutter/material.dart';
import 'package:omnichat/pages/welcome_and_auth/widgets/input_field.dart';

class SignInScreen extends ResponsePage {
  const SignInScreen({super.key}) : super(endpoint: "");

  @override
  State<StatefulWidget> createState() => SignInScreenState();
}

class SignInScreenState extends ResponsePageState<SignInScreen> {
  bool showContent = false;
  String message = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _signinPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Email or username",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),

        const SizedBox(height: 8),

        InputField(obscureText: false, controller: _emailController),

        const SizedBox(height: 20),

        const Text(
          "Password",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),

        const SizedBox(height: 8),

        InputField(obscureText: true, controller: _passwordController),
        if (message.isNotEmpty)
          Padding(
            padding: EdgeInsetsGeometry.only(top: 10),
            child: Text(
              message,
              style: TextStyle(fontSize: 16, color: Colors.red),
            ),
          ),
      ],
    );
  }

  @override
  Widget loadPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Header(
              header: "Sign in",
              subheader: "Welcome back. Continue your progress.",
              onFinished: () {
                setState(() {
                  showContent = true;
                });
              },
              children: [
                HeaderButton(
                  icon: Icons.person_add,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  size: 28,
                ),
              ],
            ),
            if (showContent)
              FadeSlideUp(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 30),

                        _signinPassword(),

                        const SizedBox(height: 24),

                        AuthButton(
                          text: "Sign In",
                          onPressed: () async {
                            await request(
                              endpoint: "login_user",
                              payload: {
                                "email": _emailController.text,
                                "password": _passwordController.text,
                              },
                              loadingMessage: "Signing in",
                              type: "POST",
                              onSuccess: (data) async {
                                final navigator = Navigator.of(context);
                                if (data is Map &&
                                    data['token'] != null &&
                                    data['token'].toString().isNotEmpty) {
                                  final token = data['token'];
                                  await DeviceStorage.saveToken(token);
                                  // Directly navigate to the chatbot page (no onboarding)
                                  navigator.pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (_) => JimChatApp(token: token)),
                                    (route) => false,
                                  );
                                }
                              },
                              onFail: (status, reason, data) {
                                if (data is Map &&
                                    data['detail'] is List &&
                                    data['detail'].isNotEmpty) {
                                  setState(() {
                                    message =
                                        data['detail'][0]?['ctx']?['reason'];
                                  });
                                } else if (data is Map<String, dynamic>) {
                                  setState(() {
                                    message = data['detail'].toString();
                                  });
                                }
                              },
                            );
                          },
                        ),
                        AuthButton(text: "Forget Password", onPressed: () {}),

                        // const Center(
                        //   child: Text(
                        //     "OR CONTINUE WITH",
                        //     style: TextStyle(
                        //       fontSize: 12,
                        //       fontWeight: FontWeight.w600,
                        //       letterSpacing: 1,
                        //       color: Colors.grey,
                        //     ),
                        //   ),
                        // ),

                        // const SizedBox(height: 20),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: const [
                        //     SocialButton(
                        //       label: "Google",
                        //       imagePath: "assets/images/google_logo.png",
                        //     ),
                        //     SocialButton(
                        //       label: "Facebook",
                        //       imagePath: "assets/images/facebook_logo.png",
                        //     ),
                        //     SocialButton(
                        //       label: "Apple",
                        //       imagePath: "assets/images/apple_logo.png",
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
