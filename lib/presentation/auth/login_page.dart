import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/presentation/auth/screens/forgot_password_page.dart';
import 'package:untitled/presentation/auth/screens/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    const String apiUrl = "http://10.0.2.2:8081/api/auth/login";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email.toLowerCase(),
          "password": password
        }),
      );

      print("STATUS → ${response.statusCode}");
      print("BODY → ${response.body}");
      print("URL → $apiUrl");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["token"] != null) {
        // COMMON: Save token, role, id
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        await prefs.setString('token', data["token"]);
        await prefs.setString('role', data["role"]);
        await prefs.setString('email', email);
        await prefs.setInt('userId', data["id"]);

        String role = data["role"];

// -----------------------------------
// ROLE: ADMIN → Directly open dashboard
// -----------------------------------
        if (role == "ADMIN") {
          print("ADMIN login → No owner/shop lookup needed.");
          Navigator.pushReplacementNamed(context, "/dashboard");
          return;
        }

// -----------------------------------
// ROLE: BARBER → Directly open dashboard
// (If barber-specific data later needed, add here)
// -----------------------------------
        if (role == "BARBER") {
          print("BARBER login → No owner/shop lookup needed.");
          Navigator.pushReplacementNamed(context, "/dashboard");
          return;
        }

// -----------------------------------
// ROLE: OWNER → Fetch owner + shops
// -----------------------------------
        if (role == "OWNER") {
          print("OWNER login → fetching owner + shops...");

          // Fetch owner
          final ownerRes = await http.get(
            Uri.parse("http://10.0.2.2:8082/api/owners/email/$email"),
            headers: {"Authorization": "Bearer ${data['token']}"},
          );

          if (ownerRes.statusCode == 200 && ownerRes.body.isNotEmpty) {
            final ownerData = jsonDecode(ownerRes.body);

            await prefs.setInt('ownerId', ownerData["id"]);

            // Fetch shops under owner
            final shopsRes = await http.get(
              Uri.parse("http://10.0.2.2:8082/api/owners/${ownerData["id"]}/shops"),
              headers: {"Authorization": "Bearer ${data['token']}"},
            );

            if (shopsRes.statusCode == 200) {
              final raw = jsonDecode(shopsRes.body);
              dynamic shop;

              if (raw is List && raw.isNotEmpty) {
                shop = raw[0];
              } else if (raw is Map) {
                shop = raw;
              }

              if (shop != null) {
                prefs.setInt("shopId", shop["id"]);
                prefs.setString("salonName", shop["shopName"]);
                print("Owner Shop Saved");
              }
            }
          }

          Navigator.pushReplacementNamed(context, "/dashboard");
          return;
        }

       // -----------------------------------
        // Fallback: Unknown role
        // -----------------------------------
        Navigator.pushReplacementNamed(context, "/dashboard");

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["error"] ?? "Login failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome back",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),

              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Sign in to your SalonSaathi owner dashboard.",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),

              const SizedBox(height: 30),

              Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 90,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "SalonSaathi",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C2769),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email address",
                  prefixIcon: const Icon(Icons.email_outlined),
                  filled: true,
                  fillColor: const Color(0xFFF7F8FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF7F8FA),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ForgotPasswordPage()),
                    );
                  },
                  child: const Text(
                    "Forgot password?",
                    style: TextStyle(color: Color(0xFF3C2769)),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF363062),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Login in to Dashboard",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),

              const SizedBox(height: 25),

              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text("or"),
                  ),
                  Expanded(child: Divider(thickness: 1)),
                ],
              ),

              const SizedBox(height: 25),

              OutlinedButton.icon(
                onPressed: () {},
                icon: Image.asset('assets/icons/google.png', height: 20),
                label: const Text("Login In with Google",
                    style: TextStyle(color: Colors.black87)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Color(0xFF363262)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
