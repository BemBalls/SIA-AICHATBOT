import 'package:omnichat/pages/welcome_and_auth/signin/signin.dart';
import 'package:omnichat/widgets/fade_slide_up.dart';
import 'package:omnichat/widgets/header.dart';
import 'package:omnichat/widgets/response_page.dart';
import 'package:flutter/material.dart';
import 'package:omnichat/pages/welcome_and_auth/widgets/signup_input_field.dart';

class SignUpScreen extends ResponsePage {
  const SignUpScreen({super.key}) : super(endpoint: "");

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ResponsePageState<SignUpScreen> {
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Validation states
  final Map<String, String?> _errors = {
    'username': null,
    'email': null,
    'password': null,
    'confirmPassword': null,
  };

  bool _isFormValid = false;
  bool showContent = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Email validation regex
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Password strength validation (optional - at least 8 chars)
  bool _isValidPassword(String password) {
    return password.length >= 8;
  }

  void _validateForm() {
    setState(() {
      // Reset errors
      _errors.updateAll((key, value) => null);

      bool isValid = true;

      // Email validation
      if (_emailController.text.isEmpty) {
        _errors['email'] = 'Email is required';
        isValid = false;
      } else if (!_isValidEmail(_emailController.text)) {
        _errors['email'] = 'Please enter a valid email';
        isValid = false;
      }

      // Password validation
      if (_passwordController.text.isEmpty) {
        _errors['password'] = 'Password is required';
        isValid = false;
      } else if (!_isValidPassword(_passwordController.text)) {
        _errors['password'] = 'Password must be at least 8 characters';
        isValid = false;
      }

      // Confirm password validation
      if (_confirmPasswordController.text.isEmpty) {
        _errors['confirmPassword'] = 'Please confirm your password';
        isValid = false;
      } else if (_passwordController.text != _confirmPasswordController.text) {
        _errors['confirmPassword'] = 'Passwords do not match';
        isValid = false;
      }

      _isFormValid = isValid;
    });
  }

  void _onSignUp() {
    _validateForm();
    if (_isFormValid) {
      // Handle successful signup
      // debugPrint('Form is valid! Proceed with signup:');
      // debugPrint('Username: ${_usernameController.text}');
      // debugPrint('Email: ${_emailController.text}');

      // TODO: Navigate to the OTP page
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const VerifyCodePage()),
      // );

      request(
        endpoint: "register_user",
        type: "POST",
        payload: {
          "email": _emailController.text,
          "password": _passwordController.text,
          "name": _usernameController.text,
        },
        loadingMessage: "Creating account",
        onSuccess: (data) {
          if (data is Map<String, dynamic> && data['detail'] != null) {
            showSuccessModal(context, data['detail']);
          } else {
            showSuccessModal(context, "Successfully signed up!");
          }
        },
        onFail: (status, reason, data) {
          String errorMsg = "Sign up failed";
          if (data is Map<String, dynamic>) {
            if (data['detail'] is String) {
              errorMsg = data['detail'];
            } else if (data['detail'] is List && (data['detail'] as List).isNotEmpty) {
              final firstError = (data['detail'] as List)[0];
              if (firstError is Map && firstError['msg'] != null) {
                errorMsg = firstError['msg'];
              }
            }
          } else if (reason.isNotEmpty) {
            errorMsg = reason;
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMsg),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        },
      );
    }
  }

  void showSuccessModal(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: Colors.white,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),

                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            179,
                            251,
                            112,
                            38,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 30, // controls width nicely
                          ),
                        ),
                        child: const Text(
                          "Proceed",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Close (X) Button
              Positioned(
                right: 8,
                top: 8,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget loadPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(
              header: "Sign Up",
              subheader: "Create your account to start your journey.",
              onFinished: () {
                setState(() {
                  showContent = true;
                });
              },
              children: [
                HeaderButton(
                  icon: Icons.login,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignInScreen(),
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
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          _signupFields(),
                          const SizedBox(height: 24),
                          // Sign up button
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isFormValid
                                  ? _onSignUp
                                  : null, // Disable if invalid
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFormValid
                                    ? Color.fromARGB(179, 251, 112, 38)
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                "Sign up",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
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
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _signupFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Username",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InputField(
          controller: _usernameController,
          obscureText: false,
          hintText: 'Enter your username',
        ),
        if (_errors['username'] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors['username']!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],

        const SizedBox(height: 20),
        const Text(
          "Email",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InputField(
          controller: _emailController,
          obscureText: false,
          hintText: 'Enter your email',
          onChanged: (value) => _validateForm(), // Real-time validation
        ),
        if (_errors['email'] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors['email']!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],

        const SizedBox(height: 20),
        const Text(
          "Password",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        InputField(
          controller: _passwordController,
          obscureText: true,
          hintText: 'Enter your password',
          onChanged: (value) => _validateForm(),
        ),
        if (_errors['password'] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors['password']!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],

        const SizedBox(height: 20),
        const Text(
          "Confirm password",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        InputField(
          controller: _confirmPasswordController,
          obscureText: true,
          hintText: 'Confirm your password',
          onChanged: (value) => _validateForm(),
        ),
        if (_errors['confirmPassword'] != null) ...[
          const SizedBox(height: 4),
          Text(
            _errors['confirmPassword']!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }
}
