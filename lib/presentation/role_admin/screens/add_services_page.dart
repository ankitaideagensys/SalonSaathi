import 'package:flutter/material.dart';

class AddServicesPage extends StatefulWidget {
  const AddServicesPage({super.key});

  @override
  State<AddServicesPage> createState() => _AddServicesPageState();
}

class _AddServicesPageState extends State<AddServicesPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  InputDecoration _fieldDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
          width: 1.4,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color(0xFF322A59),
          width: 1.8,
        ),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Services",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 20),

            // ----------------------------------------
            // SERVICE NAME
            // ----------------------------------------
            const Text("Services Name",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),

            const SizedBox(height: 6),

            TextField(
              controller: nameController,
              decoration: _fieldDecoration("Enter service name"),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------
            // PRICE NAME
            // ----------------------------------------
            const Text("Price Name",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),

            const SizedBox(height: 6),

            TextField(
              controller: priceController,
              decoration: _fieldDecoration("Rs100"),
            ),

            const SizedBox(height: 20),

            // ----------------------------------------
            // DESCRIPTION
            // ----------------------------------------
            const Text("Description",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),

            const SizedBox(height: 6),

            TextField(
              controller: descController,
              decoration: _fieldDecoration("Enter service description"),
            ),

            const SizedBox(height: 30),

            // SAVE BUTTON
            Center(
              child: SizedBox(
                width: 150,
                height: 42,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF322A59),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, {
                      "name": nameController.text,
                      "price": priceController.text,
                      "description": descController.text,
                    });
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
