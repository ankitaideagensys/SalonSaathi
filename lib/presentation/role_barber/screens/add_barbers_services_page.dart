import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../role_admin/screens/dashboard_page.dart';
import '../../role_admin/screens/overview_page.dart';
import '../../role_admin/screens/pick_shop_location_page.dart';
import '../../role_admin/screens/settings_page.dart';
import 'add_new_barber_page.dart';
import 'add_service_entry_page.dart';

class AddBarbersServicesPage extends StatefulWidget {
  const AddBarbersServicesPage({super.key});

  @override
  State<AddBarbersServicesPage> createState() => _AddBarbersServicesPageState();
}

class _AddBarbersServicesPageState extends State<AddBarbersServicesPage> {
  final List<Map<String, String>> barbers = [
    {"name": "Aman", "image": "assets/images/barber1.png"},
    {"name": "Salman", "image": "assets/images/barber2.png"},
    {"name": "Aadil", "image": "assets/images/barber3.png"},
  ];

  final List<Map<String, String>> services = [
    {"image": "assets/images/Haircut.png", "label": "Haircut"},
    {"image": "assets/images/Shaving.png", "label": "Shaving"},
    {"image": "assets/images/Coloring.png", "label": "Coloring"},
    {"image": "assets/images/Massage.png", "label": "Massage"},
    {"image": "assets/images/spa.png", "label": "Spa"},
    {"image": "assets/images/waxing.png", "label": "Waxing"},
    {"image": "assets/images/Makeup.png", "label": "Makeup"},
    {"image": "assets/images/Facial.png", "label": "Facial"},
  ];

  File? _pickedImage;

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _pickedImage = File(picked.path));
    }
  }

  void _showAddBarberDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Add New Barber"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
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
                      color: Color(0xFF3C2769),
                      size: 36,
                    )
                        : null,
                  ),
                  const SizedBox(height: 8),
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
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Barber Name",
                filled: true,
                fillColor: const Color(0xFFF7F8FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  barbers.add({
                    "name": nameController.text,
                    "image":
                    _pickedImage?.path ?? "assets/images/default_barber.png",
                  });
                });
                _pickedImage = null;
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C2769),
            ),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      // 🔹 AppBar with reduced bottom padding
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        toolbarHeight: 30,
        title: const Text(
          "Add Barbers & Services",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
      ),

      // 🔹 Body with removed scaffold padding
      body: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔹 Centered Subtitle (closer to title)
                Center(
                  child: Text(
                    "Add your team and the service they offer",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // ---------------- BARBERS SECTION ----------------
                const Text(
                  "Barbers",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ...barbers.map((barber) => Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddServiceEntryPage(
                                  barberName: barber['name']!,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage:
                                AssetImage(barber['image'] ?? ''),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                barber['name']!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddNewBarberPage(),
                            ),
                          );
                        },
                        child: Container(
                          width: 120,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: const Color(0xFF3C2769), width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "+ Add Barber",
                              style: TextStyle(
                                color: Color(0xFF3C2769),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ---------------- SERVICES SECTION ----------------
                const Text(
                  "Services",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 16),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: services.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) {
                    final item = services[index];
                    return Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEDECF2),
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              item['image']!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['label']!,
                          style: const TextStyle(
                            fontSize: 12.5,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20),

                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: const [
                      Icon(Icons.add, color: Color(0xFF3C2769), size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Add Services",
                        style: TextStyle(
                          color: Color(0xFF3C2769),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),

      // ---------------- BOTTOM NAV BAR ----------------
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        selectedItemColor: const Color(0xFF3C2769),
        unselectedItemColor: Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          }else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PickShopLocationPage()),
            );
          }
          else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: ''),
        ],
      ),
    );
  }
}
