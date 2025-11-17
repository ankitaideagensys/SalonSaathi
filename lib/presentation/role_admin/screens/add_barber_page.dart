import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddBarberPage extends StatefulWidget {
  const AddBarberPage({super.key});

  @override
  State<AddBarberPage> createState() => _AddNewBarberPageState();
}

class _AddNewBarberPageState extends State<AddBarberPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _skillsController = TextEditingController();

  File? _pickedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  void _saveBarber() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barber added successfully!")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // slightly taller
        child: AppBar(
          backgroundColor: const Color(0xFFF8F8F8),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: 26,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 16), // ✅ pushes title one line lower
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Add a New Barber to",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    height: 1.2,
                  ),
                ),
                Text(
                  "Your Team",
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

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔹 Upload Photo Section
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
                        color: Color(0xFF3C2769),
                        size: 40,
                      )
                          : null,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Upload Photo",
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 Full Name
              _buildInputField("Full Name", _nameController, TextInputType.name),
              const SizedBox(height: 16),

              // 🔹 Phone Number
              _buildInputField("Phone Number", _phoneController, TextInputType.phone),
              const SizedBox(height: 16),

              // 🔹 Experience (year)
              _buildInputField(
                "Experience (year)",
                _experienceController,
                TextInputType.number,
              ),
              const SizedBox(height: 16),

              // 🔹 Specialty / Skills
              _buildInputField(
                  "Specialty / Skills", _skillsController, TextInputType.text),

              const SizedBox(height: 40),

              // 🔹 Save Button
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

  // 🔹 Input field builder for clean UI
  Widget _buildInputField(
      String hint, TextEditingController controller, TextInputType type) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      validator: (value) => value!.isEmpty ? "Please enter $hint" : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 14,
        ),
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
}
