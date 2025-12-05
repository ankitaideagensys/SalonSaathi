import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/theme/theme_provider.dart';

class EditSalonProfilePage extends StatefulWidget {
  const EditSalonProfilePage({super.key});

  @override
  State<EditSalonProfilePage> createState() => _EditSalonProfilePageState();
}

class _EditSalonProfilePageState extends State<EditSalonProfilePage> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  bool isLoading = true;

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final TextEditingController salonNameController = TextEditingController();
  final TextEditingController salonAddressController = TextEditingController();
  final TextEditingController cityStateController = TextEditingController();

  String? backendPhotoUrl;

  // -------------------------------------------------
  // FETCH OWNER + SHOP DETAILS
  // -------------------------------------------------
  Future<void> fetchProfileFromAPI() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final token = prefs.getString("token");
      final ownerId = prefs.getInt("ownerId");
      final shopId = prefs.getInt("shopId");
      final userId = prefs.getInt("userId");

      if (token == null || ownerId == null) return;

      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      final ownerRes = await http.get(
        Uri.parse("http://10.0.2.2:8082/api/owners/$ownerId"),
        headers: headers,
      );

      final shopsRes = await http.get(
        Uri.parse("http://10.0.2.2:8082/api/owners/$ownerId/shops"),
        headers: headers,
      );

      final userRes = await http.get(
        Uri.parse("http://10.0.2.2:8082/api/users/$userId"),
        headers: headers,
      );

      if (ownerRes.statusCode == 200 &&
          shopsRes.statusCode == 200 &&
          userRes.statusCode == 200) {
        final owner = jsonDecode(ownerRes.body);
        final shops = jsonDecode(shopsRes.body);
        final user = jsonDecode(userRes.body);

        final shop = shops[0];

        setState(() {
          isLoading = false;

          fullNameController.text = owner["name"] ?? "";
          phoneController.text = owner["phone"] ?? "";
          emailController.text = owner["email"] ?? "";

          salonNameController.text = shop["shopName"] ?? "";
          salonAddressController.text = shop["address"] ?? "";
          cityStateController.text = shop["state"] ?? "";

          backendPhotoUrl = user["profileImageUrl"];
        });
      }
    } catch (e) {
      print("fetchProfile Error: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfileFromAPI();
  }

  // -------------------------------------------------
  // UPLOAD PHOTO
  // -------------------------------------------------
  Future<void> uploadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getInt('userId');

    if (_selectedImage == null || token == null || userId == null) return;

    final uri = Uri.parse("http://10.0.2.2:8082/api/users/$userId/upload-photo");

    final request = http.MultipartRequest("POST", uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath('file', _selectedImage!.path),
    );

    final streamedResponse = await request.send();
    final response = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode == 200) {
      final json = jsonDecode(response);
      setState(() => backendPhotoUrl = json["profileImageUrl"]);
    }
  }

  // -------------------------------------------------
  // SAVE PROFILE
  // -------------------------------------------------
  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");
    final ownerId = prefs.getInt("ownerId");
    final shopId = prefs.getInt("shopId");

    if (token == null || ownerId == null || shopId == null) return;

    final headers = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };

    final ownerBody = jsonEncode({
      "name": fullNameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
    });

    final shopBody = jsonEncode({
      "shopName": salonNameController.text,
      "address": salonAddressController.text,
      "state": cityStateController.text,
      "contactNumber": phoneController.text,
    });

    try {
      await http.put(
        Uri.parse("http://10.0.2.2:8082/api/owners/$ownerId"),
        headers: headers,
        body: ownerBody,
      );

      await http.put(
        Uri.parse("http://10.0.2.2:8082/api/shops/$shopId"),
        headers: headers,
        body: shopBody,
      );

      if (_selectedImage != null) {
        await uploadProfileImage();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully!")),
      );

      Navigator.pop(context);

    } catch (e) {
      print("saveProfile Error: $e");
    }
  }

  // -------------------------------------------------
  // UI
  // -------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium!.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: 30,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 0),

            // ---------------- PROFILE PHOTO ----------------
            Center(
              child: GestureDetector(
                onTap: () async {
                  final XFile? photo = await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 70,
                  );
                  if (photo != null) {
                    setState(() => _selectedImage = File(photo.path));
                  }
                },
                child: Column(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: _selectedImage != null
                            ? Image.file(_selectedImage!,
                            fit: BoxFit.cover)
                            : backendPhotoUrl != null
                            ? Image.network(
                          "http://10.0.2.2:8082$backendPhotoUrl",
                          fit: BoxFit.cover,
                        )
                            : Icon(
                          Icons.person,
                          size: 60,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Upload Photo",
                      style: TextStyle(fontSize: 14, color: textColor),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            Text(
              "Owner Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 8),

            _infoCard(theme),

            const SizedBox(height: 18),

            Text(
              "Salon Information",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),

            const SizedBox(height: 8),

            _infoCard2(theme),

            const SizedBox(height: 10),

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
                  onPressed: saveProfile,
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- INFO CARD 1 ----------------
  Widget _infoCard(ThemeData theme) {
    final textColor = theme.textTheme.bodyMedium!.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black26
                : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoItem("Full Name", fullNameController, textColor, theme),
          const SizedBox(height: 12),
          _infoItem("Phone Number", phoneController, textColor, theme),
          const SizedBox(height: 12),
          _infoItem("Email Address", emailController, textColor, theme),
        ],
      ),
    );
  }

  // ---------------- INFO CARD 2 ----------------
  Widget _infoCard2(ThemeData theme) {
    final textColor = theme.textTheme.bodyMedium!.color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black26
                : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoItem("Salon Name", salonNameController, textColor, theme),
          const SizedBox(height: 12),
          _infoItem("Salon Address", salonAddressController, textColor, theme),
          const SizedBox(height: 12),
          _infoItem("City, State, Country", cityStateController, textColor, theme),
        ],
      ),
    );
  }

  // ---------------- FIELD ----------------
  Widget _infoItem(
      String title,
      TextEditingController controller,
      Color? textColor,
      ThemeData theme,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          style: TextStyle(fontSize: 12, color: textColor),
          decoration: InputDecoration(
            fillColor: theme.scaffoldBackgroundColor,
            filled: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: theme.colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
