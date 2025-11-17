import 'package:flutter/material.dart';
import 'service_success_page.dart';

class AddServiceEntryPage extends StatefulWidget {
  const AddServiceEntryPage({super.key, required String barberName});


  @override
  State<AddServiceEntryPage> createState() => _AddServiceEntryPageState();
}


class _AddServiceEntryPageState extends State<AddServiceEntryPage> {
  String? selectedBarber = "Aman";
  String? selectedService = "Haircut";
  int quantity = 1;
  bool isBarberDropdownOpen = false;
  bool isServiceDropdownOpen = false;

  final List<Map<String, String>> _services = [
    {"image": "assets/images/Haircut.png", "label": "Haircut"},
    {"image": "assets/images/Shaving.png", "label": "Shaving"},
    {"image": "assets/images/Coloring.png", "label": "Coloring"},
    {"image": "assets/images/Massage.png", "label": "Massage"},
    {"image": "assets/images/spa.png", "label": "Spa"},
    {"image": "assets/images/waxing.png", "label": "Waxing"},
    {"image": "assets/images/Makeup.png", "label": "Makeup"},
    {"image": "assets/images/Facial.png", "label": "Facial"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        toolbarHeight: 27,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Services Entry",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "A service to your barber and set the quantity.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 18),

            // 🔹 Select Barber
            const Text(
              "Select Barber",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: const Color(0xFFD9D9D9),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedBarber,
                        isExpanded: true,
                        icon: Icon(isBarberDropdownOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded),
                        items: [
                          _buildBarberDropdownItem("Aman", "assets/images/barber1.png"),
                          _buildBarberDropdownItem("Salman", "assets/images/barber2.png"),
                          _buildBarberDropdownItem("Aadil", "assets/images/barber3.png"),
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedBarber = value;
                            isBarberDropdownOpen = false;
                          });
                        },
                        onTap: () {
                          setState(() {
                            isBarberDropdownOpen = true;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // 🔹 Select Service
            const Text(
              "Select Service",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Color(0xFFD9D9D9),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedService,
                        isExpanded: true,
                        icon: Icon(isServiceDropdownOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded),
                        dropdownColor: const Color(0xFFF9F9F9),

                        // ✅ Selected item with icon + label
                        selectedItemBuilder: (BuildContext context) {
                          return _services.map((service) {
                            return Row(
                              children: [
                                Image.asset(service['image']!, height: 22, width: 22),
                                const SizedBox(width: 10),
                                Text(service['label']!, style: const TextStyle(fontSize: 15)),
                              ],
                            );
                          }).toList();
                        },

                        // ✅ Dropdown menu items
                        items: _services.map((service) {
                          return DropdownMenuItem<String>(
                            value: service['label'],
                            child: Row(
                              children: [
                                Image.asset(service['image']!, height: 22, width: 22),
                                const SizedBox(width: 10),
                                Text(service['label']!, style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                          );
                        }).toList(),

                        onChanged: (value) {
                          setState(() {
                            selectedService = value;
                            isServiceDropdownOpen = false;
                          });
                        },
                        onTap: () {
                          setState(() {
                            isServiceDropdownOpen = true;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 26),

            // 🔹 Quantity
            const Text(
              "Quantity",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _quantityButton(Icons.remove, () {
                  if (quantity > 1) setState(() => quantity--);
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "$quantity",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _quantityButton(Icons.add, () {
                  setState(() => quantity++);
                }),
              ],
            ),

            const SizedBox(height: 32),

            // 🔹 Total + Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Total", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text("Rs100", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Estimated Time", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                Text("30 min", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),

            const Spacer(),

            // 🔹 Save Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child:ElevatedButton(
                onPressed: () {
                  // Show temporary confirmation (optional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Service entry added!")),
                  );

                  // Redirect to success page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ServiceSuccessPage(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF363062),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),

            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  // 🔹 Barber Dropdown Item
  DropdownMenuItem<String> _buildBarberDropdownItem(String name, String imagePath) {
    return DropdownMenuItem(
      value: name,
      child: Row(
        children: [
          CircleAvatar(radius: 16, backgroundImage: AssetImage(imagePath)),
          const SizedBox(width: 10),
          Text(name, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  // 🔹 Service Dropdown Item
  DropdownMenuItem<String> _buildServiceDropdownItem(String name, IconData icon) {
    return DropdownMenuItem(
      value: name,
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 10),
          Text(name, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  // 🔹 Quantity Buttons ( + / - )
  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFD9D9D9)),
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}