import 'dart:convert';
import 'package:omnichat/pages/welcome_and_auth/signin/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

// final String server = "http://26.54.204.199:8000/";
final String server = "http://127.0.0.1:8000/";

abstract class ResponsePage extends StatefulWidget {
  final String endpoint;
  final String token;
  final Object? json;
  final String type;

  const ResponsePage({
    super.key,
    required this.endpoint,
    this.token = "",
    this.json = const {},
    this.type = "GET",
  });
}

abstract class ResponsePageState<T extends ResponsePage> extends State<T> {
  int status = 0;
  String reason = "";
  bool _initialized = false;

  @override
  void initState() {
    _loadPage();
    super.initState();
  }

  Future<void> _loadPage() async {
    try {
      Object? data;
      final navigator = Navigator.of(context);
      final baseUrl = "$server${widget.endpoint}";

      final uri = Uri.parse(
        widget.json is String && (widget.json as String).isNotEmpty
            ? "$baseUrl/${widget.json}"
            : baseUrl,
      );
      final type = widget.type;
      final headers = widget.token.isNotEmpty
          ? {
              'Authorization': 'Bearer ${widget.token}',
              'Content-Type': 'application/json',
              'accept': 'application/json',
            }
          : {'accept': 'application/json'};
      late http.Response response;

      if (type == "GET") {
        response = await http.get(uri, headers: headers);
      } else if (type == "POST") {
        headers['Content-Type'] = 'application/json';
        response = await http.post(
          uri,
          headers: headers,
          body: jsonEncode(widget.json),
        );
      } else {
        throw Exception("Unsupported request type: $type");
      }

      if (!mounted) return;

      if (response.statusCode == 401) {
        // If unauthorized, redirect to Sign In
        navigator.push(
          MaterialPageRoute(
            builder: (context) {
              return const SignInScreen();
            },
          ),
        );
        return;
      }

      setState(() {
        status = response.statusCode;
        reason = response.reasonPhrase ?? '';
        data = jsonDecode(utf8.decode(response.bodyBytes));
      });

      if (!_initialized) {
        if (await init(data)) _initialized = true;
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        status = 503;
        reason = "Request Timeout\n(Please check your internet connection)";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (status == 0) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(179, 251, 112, 38),
          ),
        ),
      );
    }

    if (status == 1 && waiting() != null) {
      return waiting()!;
    }

    if (status != 200) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$status",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  reason,
                  style: TextStyle(color: Colors.grey, fontSize: 24),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      status = 0;
                    });
                    _loadPage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(179, 251, 112, 38),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'Reload',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return loadPage();
  }

  Future<bool> init(Object? data) async {
    return true;
  }

  Widget loadPage();
  Widget? waiting() {
    return null;
  }

  void updateStatus(int newStatus, [String reasonPhrase = '']) {
    setState(() {
      status = newStatus;
      reason = reasonPhrase;
    });
  }

  Future<void> request({
    required String endpoint,
    String? token,
    required String type,
    Object? payload,
    Map<String, String>? parameters,
    String? loadingMessage,
    void Function(Object? data)? onSuccess,
    void Function(int status, String reason, Object? data)? onFail,
  }) async {
    final NavigatorState navigator = Navigator.of(context);

    await requestEndpoint(
      endpoint: endpoint,
      type: type,
      c: context,
      payload: payload,
      parameters: parameters,
      token: token,
      onFail: (status, reason, Object? data) {
        if (loadingMessage != null) {
          if (!mounted) return;
          navigator.pop();
        }
        onFail?.call(status, reason, data);
      },
      onSuccess: (Object? data) {
        if (loadingMessage != null) {
          if (!mounted) return;
          navigator.pop();
        }
        onSuccess?.call(data);
      },
      onLoading: () async {
        if (!mounted) return;
        if (loadingMessage != null) {
          _showLoadingDialog(context, loadingMessage);
          await Future.delayed(Duration(seconds: 1));
        }
      },
    );
  }
}

Future<void> requestEndpoint({
  required String endpoint,
  String? token,
  required String type,
  Object? payload,
  Map<String, String>? parameters,
  void Function()? onLoading,
  void Function(Object? data)? onSuccess,
  void Function(int status, String reason, Object? data)? onFail,
  BuildContext? c,
}) async {
  ScaffoldMessengerState? messenger;
  if (c != null) {
    messenger = ScaffoldMessenger.of(c);
  }
  try {
    if (onLoading != null) onLoading.call();

    late http.Response response;

    final uri = Uri.parse(
      "$server$endpoint",
    ).replace(queryParameters: parameters);

    final headers = token != null
        ? {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'accept': 'application/json',
          }
        : {'accept': 'application/json', 'Content-Type': 'application/json'};

    if (type.toUpperCase() == "GET") {
      response = await http.get(uri, headers: headers);
    } else if (type.toUpperCase() == "POST") {
      response = await http.post(
        uri,
        headers: headers,
        body: jsonEncode(payload),
      );
    } else {
      throw Exception("Unsupported request type: $type");
    }
    if (c != null && !c.mounted) return;
    if (response.statusCode != 200 && onFail != null) {
      onFail.call(
        response.statusCode,
        response.reasonPhrase ?? '',
        jsonDecode(utf8.decode(response.bodyBytes)),
      );
    } else if (onSuccess != null) {
      onSuccess.call(jsonDecode(utf8.decode(response.bodyBytes)));
    }
  } catch (e) {
    if (c != null && !c.mounted) return;
    messenger?.showSnackBar(SnackBar(content: Text("Request timed out")));
    if (onFail != null) onFail.call(503, 'Request timed out', []);
  }
}

Future<void> _showLoadingDialog(BuildContext context, String message) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$message...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 24),

              const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(179, 251, 112, 38),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class DeviceStorage {
  static const _storage = FlutterSecureStorage();

  static const _jwtKey = 'jwt_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _jwtKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _jwtKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _jwtKey);
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
