import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddNewServicePage extends StatefulWidget {
  const AddNewServicePage({super.key});

  @override
  State<AddNewServicePage> createState() => _AddNewServicePageState();
}

class _AddNewServicePageState extends State<AddNewServicePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  File? _pickedImage;

  final String baseUrl = "http://10.0.2.2:8082";

  // 🔹 PICK IMAGE
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  // 🔹 SAVE SERVICE (POST API)
  Future<void> _saveService() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final shopId = prefs.getInt("shopId");
    final token = prefs.getString("token");

    final body = {
      "id": null,
      "shopId": shopId,
      "name": _nameController.text.trim(),
      "price": double.parse(_priceController.text.trim()),
      "description": _descController.text.trim(),
      "iconUrl": "" // (in future → Firebase image URL)
    };

    final response = await http.post(
      Uri.parse("$baseUrl/api/shop/services/add"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Service added successfully!")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${response.body}")),
      );
    }
  }

  // 🔹 Input field builder
  Widget _buildField(String hint, TextEditingController controller,
      TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (v) => v!.isEmpty ? "Please enter $hint" : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 16),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // UI BUILD
  // -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      // 🔹 App bar identical style
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: const Color(0xFFF8F8F8),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // BACK BUTTON (Left)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 26, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // CENTER TITLE
                const Text(
                  "Add a New Service\n     to Your Shop",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
    ),

      // 🔹 Body
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔹 Upload Photo section
              GestureDetector(
                onTap: _pickImage,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: const Color(0xFFEDECF2),
                      backgroundImage: _pickedImage != null
                          ? FileImage(_pickedImage!)
                          : null,
                      child: _pickedImage == null
                          ? const Icon(
                        Icons.add_photo_alternate_outlined,
                        color: Color(0xFF362062),
                        size: 40,
                      )
                          : null,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Upload Service Icon",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 Service name
              _buildField("Service Name", _nameController, TextInputType.text),
              const SizedBox(height: 16),

              // 🔹 Price
              _buildField("Price", _priceController, TextInputType.number),
              const SizedBox(height: 16),

              // 🔹 Description
              _buildField(
                  "Description", _descController, TextInputType.multiline),

              const SizedBox(height: 40),

              // 🔹 SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveService,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF363062),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
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
