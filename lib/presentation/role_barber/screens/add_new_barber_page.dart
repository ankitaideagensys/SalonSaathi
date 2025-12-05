import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddNewBarberPage extends StatefulWidget {
  const AddNewBarberPage({super.key});

  @override
  State<AddNewBarberPage> createState() => _AddNewBarberPageState();
}

class _AddNewBarberPageState extends State<AddNewBarberPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  final TextEditingController _salonNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  File? _pickedImage;
  final String baseUrl = "http://10.0.2.2:8082";

  // CLEAN INPUT (remove invisible characters)
  String clean(String v) =>
      v.replaceAll(RegExp(r'[^\x00-\x7F]'), '').trim();

  @override
  void initState() {
    super.initState();
    _loadSalonInfo();
  }

  // AUTOLOAD SALON NAME + ADDRESS
  Future<void> _loadSalonInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final shopId = prefs.getInt("shopId");
    final token = prefs.getString("token");

    if (shopId == null || token == null) return;

    final res = await http.get(
      Uri.parse("$baseUrl/api/shops/$shopId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode == 200) {
      final shop = jsonDecode(res.body);

      setState(() {
        _salonNameController.text = shop["shopName"] ?? "";
        _addressController.text = shop["address"] ?? "";
      });
      prefs.setString("salonName", shop["shopName"]);
    }
  }

  // PICK IMAGE
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  // SAVE BARBER
  Future<void> _saveBarber() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final shopId = prefs.getInt("shopId");
    final token = prefs.getString("token");

    if (shopId == null || token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Missing shopId or token")),
      );
      return;
    }

    final body = {
      "name": clean(_nameController.text),
      "phone": clean(_phoneController.text),
      "email": clean(_emailController.text),
      "experienceYears": int.tryParse(_experienceController.text.trim()) ?? 0,
      "skills": clean(_skillsController.text),
      "salonName": clean(_salonNameController.text),
      "salonAddress": clean(_addressController.text), // <-- correct field
      "photoUrl": ""
    };


    final response = await http.post(
      Uri.parse("$baseUrl/api/barbers/register"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barber added successfully!")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: AppBar(
          backgroundColor: const Color(0xFFF8F8F8),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Column(
              children: [
                Text(
                  "Add a New Barber to",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 22),
                ),
                Text(
                  "Your Team",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 22),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundColor: const Color(0xFFEDECF2),
                      backgroundImage:
                      _pickedImage != null ? FileImage(_pickedImage!) : null,
                      child: _pickedImage == null
                          ? const Icon(
                          Icons.add_photo_alternate_outlined,
                          color: Color(0xFF363062),
                          size: 40)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Upload Photo",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              _buildInputField("Full Name", _nameController, TextInputType.name),
              const SizedBox(height: 16),

              _buildInputField("Salon Name", _salonNameController, TextInputType.text),
              const SizedBox(height: 16),

              _buildInputField("Address", _addressController, TextInputType.streetAddress),
              const SizedBox(height: 16),

              _buildInputField("Email", _emailController, TextInputType.emailAddress),
              const SizedBox(height: 16),

              _buildInputField("Phone Number", _phoneController, TextInputType.phone),
              const SizedBox(height: 16),

              _buildInputField("Experience (years)", _experienceController, TextInputType.number),
              const SizedBox(height: 16),

              _buildInputField("Specialty / Skills", _skillsController, TextInputType.text),
              const SizedBox(height: 16),

              const SizedBox(height: 5),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _saveBarber,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF363062),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      String hint, TextEditingController controller, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (value) => value!.isEmpty ? "Please enter $hint" : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
