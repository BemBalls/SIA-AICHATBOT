import 'package:omnichat/pages/jim_chat/chat_screen.dart';
import 'package:omnichat/pages/welcome_and_auth/signin/signin.dart';
import 'package:omnichat/widgets/response_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final token = await DeviceStorage.getToken();

  Widget home = const SignInScreen();

  if (token != null && !JwtDecoder.isExpired(token)) {
    home = JimChatApp(token: token);
  }

  runApp(MyApp(home: home));
}

class MyApp extends StatelessWidget {
  final Widget home;

  const MyApp({super.key, required this.home});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.nunitoTextTheme()),
      debugShowCheckedModeBanner: false,
      home: home,
    );
  }
}
