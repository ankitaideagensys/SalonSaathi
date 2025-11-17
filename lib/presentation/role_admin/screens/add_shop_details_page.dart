import 'package:flutter/material.dart';

class AddShopDetailsPage extends StatelessWidget {
  const AddShopDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Register New Salon Location",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: [
          const SizedBox(width: 30),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // SHOP NAME
            const Text("Shop Name",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color:Color(0xFF647075))),
            const SizedBox(height: 6),
            SizedBox(
              height: 55,   // ⬆️ bigger box
              child: TextField(decoration: _inputDeco()),
            ),
            const SizedBox(height: 28),

            // ADDRESS
            const Text("Address",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color:Color(0xFF647075))),
            const SizedBox(height: 6),
            SizedBox(
              height: 55,
              child: TextField(decoration: _inputDeco()),
            ),
            const SizedBox(height: 28),

            // CONTACT NUMBER
            const Text("Contact Number",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color:Color(0xFF647075))),
            const SizedBox(height: 6),
            SizedBox(
              height: 55,
              child: TextField(
                keyboardType: TextInputType.phone,
                decoration: _inputDeco(),
              ),
            ),
            const SizedBox(height: 28),

            // WORKING HOURS
            const Text("Working Hours",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color:Color(0xFF647075))),
            const SizedBox(height: 6),
            SizedBox(
              height: 55,
              child: TextField(decoration: _inputDeco()),
            ),
            const SizedBox(height: 28),

            // GST NUMBER
            const Text("GST Number (Optional)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color:Color(0xFF647075))),
            const SizedBox(height: 6),
            SizedBox(
              height: 55,
              child: TextField(decoration: _inputDeco()),
            ),
            const SizedBox(height: 45),

            // SAVE BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C2769),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 Input design matching screenshot
  InputDecoration _inputDeco() {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF5F5F5), // 🎨 Very light grey matching screenshot
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