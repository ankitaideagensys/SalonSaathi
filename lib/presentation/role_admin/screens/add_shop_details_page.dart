import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddShopDetailsPage extends StatefulWidget {
  const AddShopDetailsPage({super.key});

  @override
  State<AddShopDetailsPage> createState() => _AddShopDetailsPageState();
}

class _AddShopDetailsPageState extends State<AddShopDetailsPage> {
  final shopNameCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final stateCtrl = TextEditingController();

  final workingHoursCtrl = TextEditingController();
  final gstCtrl = TextEditingController();

  bool isLoading = false;

  Future<void> saveShop() async {
    if (shopNameCtrl.text.isEmpty ||
        addressCtrl.text.isEmpty ||
        contactCtrl.text.isEmpty ||
        stateCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please fill all required fields")));
      return;
    }

    setState(() => isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";
    final ownerId = prefs.getInt("ownerId") ?? 1;

    const String url = "http://10.0.2.2:8082/api/shops";

    final Map<String, dynamic> body = {
      "shopName": shopNameCtrl.text.trim(),
      "contactNumber": contactCtrl.text.trim(),
      "address": addressCtrl.text.trim(),
      "city": "",          // removed; sending empty
      "state": stateCtrl.text.trim(),
      "owner": {"id": ownerId},
      "active": true
    };

    try {
      print("📡 Sending request to: $url");
      print("📦 Body: $body");
      print("🔑 Token: $token");
      print("👤 Owner ID: $ownerId");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response Body: ${response.body}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Shop registered successfully!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed: ${response.body}")));
      }
    } catch (e) {
      print("❌ ERROR: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Register New Salon Location",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _label("Shop Name"),
            _field(shopNameCtrl),

            _label("Address"),
            _field(addressCtrl),

            _label("Contact Number"),
            _field(contactCtrl, keyboardType: TextInputType.phone),

            _label("State"),
            _field(stateCtrl),

            _label("Working Hours (Optional)"),
            _field(workingHoursCtrl),

            _label("GST Number (Optional)"),
            _field(gstCtrl),

            const SizedBox(height: 45),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: isLoading ? null : saveShop,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C2769),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Save",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Color(0xFF647075),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, {TextInputType keyboardType = TextInputType.text}) {
    return SizedBox(
      height: 55,
      child: TextField(
        controller: c,
        keyboardType: keyboardType,
        decoration: _inputDeco(),
      ),
    );
  }

  InputDecoration _inputDeco() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF3C2769), width: 1.5),
      ),
    );
  }
}
