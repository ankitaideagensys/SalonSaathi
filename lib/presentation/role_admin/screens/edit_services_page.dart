import 'package:flutter/material.dart';
import 'add_services_page.dart';

class EditServicesPage extends StatefulWidget {
  const EditServicesPage({super.key});

  @override
  State<EditServicesPage> createState() => _EditServicesPageState();
}

// -----------------------------------------------------------
// AUTO ICON MAPPING BASED ON SERVICE NAME
// -----------------------------------------------------------
final Map<String, String> serviceIcons = {
  "Haircut": "assets/images/Haircut.png",
  "Shaving": "assets/images/Shaving.png",
  "Coloring": "assets/images/Coloring.png",
  "Massage": "assets/images/Massage.png",
  "Spa": "assets/images/spa.png",
  "Facial": "assets/images/Facial.png",
  "Makeup": "assets/images/Makeup.png",
  "Waxing": "assets/images/waxing.png",
};

class _EditServicesPageState extends State<EditServicesPage> {

  // EXISTING SERVICES LIST
  List<Map<String, String>> services = [
    {"name": "Haircut", "price": "Rs100", "icon": "assets/images/Haircut.png"},
    {"name": "Shaving", "price": "Rs90", "icon": "assets/images/Shaving.png"},
    {"name": "Coloring", "price": "Rs250", "icon": "assets/images/Coloring.png"},
    {"name": "Massage", "price": "Rs500", "icon": "assets/images/Massage.png"},
    {"name": "Spa", "price": "Rs250", "icon": "assets/images/spa.png"},
  ];

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
        centerTitle: true,
        title: const Text(
          "Edit Services",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
            children: [

            // ---------- SERVICE LIST ----------
              Column(
                children: [
                  for (var s in services) ...[
                    _serviceTile(
                      s["name"]!,
                      s["price"]!,
                      s["icon"]!,
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              ),

              const SizedBox(height: 24), // space between last card & button (adjust as you like)


              // ---------- ADD SERVICE BUTTON ----------
            SizedBox(
              width: 150,
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF322A59),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                onPressed: () async {
                  // WAIT FOR RESULT FROM ADD PAGE
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddServicesPage(),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      services.add({
                        "name": result["name"],
                        "price": result["price"],
                        "icon": serviceIcons[result["name"]]
                            ?? "assets/images/Haircut.png",
                      });
                    });
                  }
                },

                child: const Text(
                  "Add Services",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
        ),
    );
  }

  // -----------------------------------------------------------
  // SERVICE TILE WIDGET
  // -----------------------------------------------------------
  Widget _serviceTile(String title, String price, String iconPath) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [

          // ICON
          Image.asset(
            iconPath,
            height: 24,
            width: 24,
          ),

          const SizedBox(width: 15),

          // TITLE
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // PRICE
          Text(
            price,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
