import 'package:flutter/material.dart';
import 'package:untitled/presentation/role_admin/screens/settings_page.dart';
import ' salon_dashboard_page.dart';
import '../../role_barber/screens/add_barbers_services_page.dart';
import 'add_shop_details_page.dart';
import 'dashboard_page.dart';

class PickShopLocationPage extends StatefulWidget {
  const PickShopLocationPage({super.key});

  @override
  State<PickShopLocationPage> createState() => _PickShopLocationPageState();
}

class _PickShopLocationPageState extends State<PickShopLocationPage> {
  final List<Map<String, String>> shopList = [
    {"name": "Hema Salon", "city": "Bangalore", "booking": "  12", "revenue": "Rs2215"},
    {"name": "Classic Salon", "city": "Mumbai", "booking": "  20", "revenue": "Rs8999"},
    {"name": "Star Salon", "city": "Delhi", "booking": "  10", "revenue": "Rs2000"},
  ];

  String searchQuery = "";

  List<Map<String, String>> get filteredShopList {
    if (searchQuery.isEmpty) {
      return shopList;
    }
    return shopList.where((shop) {
      return shop['name']!.toLowerCase().contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ✅ Clean AppBar (no back arrow)
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Pick Your Shop Location",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),

      // ✅ Body
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Bar
            Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFF7F8FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE0E0E0)),
              ),
              child: TextField(
                textAlignVertical: TextAlignVertical.center,
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Search Shops",
                  hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.black54, size: 20),
                  border: InputBorder.none,
                  isCollapsed: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 11),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🧾 Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                children: const [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Shop Name",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "City",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Today's Booking",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      " Revenue",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFFE0E0E0), thickness: 1, height: 10),

            // ✅ Shop List
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: filteredShopList.length + 1, // +1 for divider + add shop button
                itemBuilder: (context, index) {
                  if (index < filteredShopList.length) {
                    final shop = filteredShopList[index];
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  shop['name']!,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  shop['city']!,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  shop['booking']!,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shop['revenue']!,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 29, // ✅ Figma height
                                      width: 110, // ✅ Figma width
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SalonDashboardPage(
                                                shopName: shop['name']!,
                                              ),
                                            ),
                                          );
                                        },

                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xFF363062),
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text(
                                          "View Dashboard",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ✅ Add Divider after every row including Star Salon
                        const Divider(
                          color: Color(0xFFE0E0E0),
                          thickness: 1,
                          height: 20,
                        ),
                      ],
                    );
                  } else {
                    // ➕ Add Another Shop Button
                    return Padding(
                      padding: const EdgeInsets.only(top: 12, bottom: 20),
                      child: Center(
                        child: SizedBox(
                          height: 42,
                          width: 230,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AddShopDetailsPage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add,
                                color: Color(0xFF3C2769), size: 18),
                            label: const Text(
                              "Add Another Shop",
                              style: TextStyle(
                                color: Color(0xFF3C2769),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color(0xFF3C2769), width: 1.2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.white,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 16),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),

      // ⚙️ Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
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
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AddBarbersServicesPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_rounded), label: ''),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: ''),
        ],
      ),
    );
  }
}