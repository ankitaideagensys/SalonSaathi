import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled/presentation/auth/screens/reset_password_page.dart';

class OtpVerificationPage extends StatefulWidget {
  final String email; // optional: pass email from previous screen
  const OtpVerificationPage({super.key, this.email = ""});

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final int _otpLength = 4;
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(4, (_) => FocusNode());

  bool _verifying = false;

  // resend timer
  static const int _startSeconds = 180; // 03:00
  int _secondsLeft = _startSeconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    for (final n in _nodes) n.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _timer?.cancel();
    setState(() => _secondsLeft = _startSeconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  String get _formattedLeft {
    final m = (_secondsLeft ~/ 60).toString().padLeft(2, '0');
    final s = (_secondsLeft % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  void _onChanged(int index, String value) {
    // only keep last digit
    if (value.length > 1) {
      _controllers[index].text = value[value.length - 1];
      _controllers[index].selection = TextSelection.fromPosition(
          TextPosition(offset: _controllers[index].text.length));
    }
    if (value.isNotEmpty && index < _otpLength - 1) {
      _nodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      // backspace to previous field
      _nodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  String get _otp =>
      _controllers.map((c) => c.text.trim()).join();

  Future<void> _verify() async {
    if (_otp.length != _otpLength || _otp.contains(RegExp(r'[^0-9]'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 4-digit code')),
      );
      return;
    }
    setState(() => _verifying = true);

    // TODO: call your verify API here
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _verifying = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Verified: $_otp')),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ResetPasswordPage()),
    );

    // TODO: Navigate to next screen (reset password / dashboard)
  }

  void _resend() {
    if (_secondsLeft == 0) {
      // TODO: call resend API
      _startCountdown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP resent to your email')),
      );
    }
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 56,
      child: TextField(
        controller: _controllers[index],
        focusNode: _nodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        onChanged: (v) => _onChanged(index, v),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: const Color(0xFFF7F8FA),
          hintText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: (_controllers[index].text.isNotEmpty)
                  ? const Color(0xFF3C2769)
                  : Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF3C2769), width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canResend = _secondsLeft == 0;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Email verification",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Please type OTP code that we give you",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 28),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: List.generate(_otpLength, (i) {
                  return Padding(
                    padding: EdgeInsets.only(right: i == _otpLength - 1 ? 0 : 14),
                    child: _otpBox(i),
                  );
                }),
              ),

              const SizedBox(height: 12),

              // Resend timer/link
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: canResend ? _resend : null,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black54),
                        children: [
                          const TextSpan(text: "Resend on "),
                          TextSpan(
                            text: canResend ? "now" : _formattedLeft,
                            style: const TextStyle(
                              color: Color(0xFF3C2769),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Verify button
              _verifying
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _verify,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF363062),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Verify Email",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
