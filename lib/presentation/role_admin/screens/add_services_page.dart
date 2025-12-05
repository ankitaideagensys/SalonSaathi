import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddServicesPage extends StatefulWidget {
  const AddServicesPage({super.key});

  @override
  State<AddServicesPage> createState() => _AddServicesPageState();
}

class _AddServicesPageState extends State<AddServicesPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  static const String baseUrl = "http://10.0.2.2:8082";

  // -------------------------------------------------------------
  // AUTO ICON ASSIGNER BASED ON SERVICE NAME
  // -------------------------------------------------------------
  String assignIcon(String name) {
    name = name.toLowerCase();

    if (name.contains("hair")) return "Haircut.png";
    if (name.contains("massage")) return "Massage.png";
    if (name.contains("spa")) return "Spa.png";
    if (name.contains("facial")) return "Facial.png";
    if (name.contains("shav")) return "Shaving.png";
    if (name.contains("makeup")) return "Makeup.png";
    if (name.contains("color")) return "Coloring.png";
    if (name.contains("wax")) return "waxing.png";

    return "Haircut.png"; // default fallback
  }

  // ---------------- THEME-AWARE FIELD DECORATION ----------------
  InputDecoration _fieldDecoration(String hint, ThemeData theme) {
    final textColor = theme.textTheme.bodyMedium!.color;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: textColor?.withOpacity(0.6)),
      filled: true,
      fillColor: theme.cardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.8),
      ),
    );
  }

  // ---------------- SAVE SERVICE ----------------
  Future<void> _saveService() async {
    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        durationController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please fill all fields")));
      return;
    }

    final price = double.tryParse(priceController.text);
    final duration = int.tryParse(durationController.text);

    if (price == null || duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter valid numeric values")));
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final shopId = prefs.getInt("shopId") ?? 1;
    final token = prefs.getString("token") ?? "";

    final icon = assignIcon(nameController.text);

    final body = {
      "shopId": shopId,
      "name": nameController.text,
      "price": price,
      "description": descController.text,
      "iconUrl": icon,
      "estimatedDuration": duration,
    };

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/shop/services/add"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        Navigator.pop(context, {
          "name": nameController.text,
          "price": priceController.text,
          "description": descController.text,
          "iconUrl": assignIcon(nameController.text),
          "duration": durationController.text,
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed: ${res.body}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  // -------------------------------------------------------------
  // UI
  // -------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium!.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Add Services",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ---------------- Service Name ----------------
              Text(
                "Service Name",
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600, color: textColor),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: nameController,
                style: TextStyle(color: textColor),
                decoration: _fieldDecoration("Enter service name", theme),
              ),

              const SizedBox(height: 20),

              // ---------------- Price ----------------
              Text(
                "Price",
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600, color: textColor),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                style: TextStyle(color: textColor),
                decoration: _fieldDecoration("Rs100", theme),
              ),

              const SizedBox(height: 20),

              // ---------------- Estimated Duration ----------------
              Text(
                "Estimated Duration (minutes)",
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600, color: textColor),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                style: TextStyle(color: textColor),
                decoration: _fieldDecoration("25", theme),
              ),

              const SizedBox(height: 20),

              // ---------------- Description ----------------
              Text(
                "Description",
                style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w600, color: textColor),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: descController,
                maxLines: 2,
                style: TextStyle(color: textColor),
                decoration: _fieldDecoration("Enter service description", theme),
              ),

              const SizedBox(height: 40),

              // ---------------- SAVE BUTTON ----------------
              Center(
                child: SizedBox(
                  width: 150,
                  height: 42,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF363062),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _saveService,
                    child: const Text("Save",
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
