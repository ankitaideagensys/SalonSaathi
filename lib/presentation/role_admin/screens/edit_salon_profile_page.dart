import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditSalonProfilePage extends StatefulWidget {
  const EditSalonProfilePage({super.key});

  @override
  State<EditSalonProfilePage> createState() => _EditSalonProfilePageState();
}

class _EditSalonProfilePageState extends State<EditSalonProfilePage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? photo =
    await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (photo != null) {
      setState(() {
        _selectedImage = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xfff7f7f7),  // ✔ perfect grey app bar
        elevation: 0,                              // ✔ removes shadow
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 30,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SizedBox(),  // <-- removed title
        centerTitle: true,
      ),

              body: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),   // reduce top padding
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 0),

            Center(
              child: GestureDetector(
                onTap: _pickImage,
               child: Column(
                children: [
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7E7E7), // light grey just like original
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: _selectedImage == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade600,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 26,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      )
                          : Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Upload Photo",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
            ),

            const SizedBox(height: 15),

            // Owner Information Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Owner Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            _infoCard(
              title1: "Full Name",
              value1: "Salman",
              title2: "Phone Number",
              value2: "+91 1234567890",
              title3: "Email Address",
              value3: "alex.johnson@gmail.com",
            ),

            const SizedBox(height: 18),

            // Salon Information Title
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Salon Information",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 8),

            _infoCard(
              title1: "Salon Name",
              value1: "Hema Salon",
              title2: "Salon Address",
              value2: "123 Main ST",
              title3: "City, State, Country",
              value3: "Anytown, CA, 1235",
            ),

            const SizedBox(height: 8),

            // Save Button
            Center(
              child: SizedBox(
                width: 140,
                height: 42,
                child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4C3575),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required String title1,
    required String value1,
    required String title2,
    required String value2,
    required String title3,
    required String value3,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoItem(title1, value1),
          const SizedBox(height: 12),
          _infoItem(title2, value2),
          const SizedBox(height: 12),
          _infoItem(title3, value3),
        ],
      ),
    );
  }

  Widget _infoItem(String title, String value) {
    TextEditingController controller = TextEditingController(text: value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),

        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade600, width: 1.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
