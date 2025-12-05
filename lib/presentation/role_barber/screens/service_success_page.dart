import 'package:flutter/material.dart';
import '../../role_admin/screens/dashboard_page.dart';
import '../../role_admin/screens/overview_page.dart';
import '../../role_admin/screens/pick_shop_location_page.dart';
import 'add_barbers_services_page.dart';

class ServiceSuccessPage extends StatefulWidget {
  final String name;
  final String service;
  final String total;
  final String duration;
  final String image; // 🔥 added

  const ServiceSuccessPage({
    super.key,
    required this.name,
    required this.service,
    required this.total,
    required this.duration,
    required this.image,   // 🔥 added
  });

  @override
  State<ServiceSuccessPage> createState() => _ServiceSuccessPageState();
}

class _ServiceSuccessPageState extends State<ServiceSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),

              const CircleAvatar(
                radius: 45,
                backgroundColor: Color(0xFF22C55E),
                child: Icon(Icons.check, color: Colors.white, size: 45),
              ),

              const SizedBox(height: 24),

              const Text(
                "Service Added\nSuccessfully!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Your service has been added for ${widget.name}.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 40),

              // ---- Barber Card ----
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xFFE0E0E0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: NetworkImage(widget.image),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _infoRow("Service", widget.service),
                    _infoRow("Total", "Rs ${widget.total}"),
                    _infoRow("Duration", widget.duration),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const OverviewPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF363062),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Finish & Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),

      // ---- Bottom Navigation ----
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
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AddBarbersServicesPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const PickShopLocationPage()),
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

  // 🔹 Reusable info row
  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500)),
          Text(value,
              style: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
