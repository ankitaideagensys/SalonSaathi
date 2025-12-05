import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/theme/theme_provider.dart';
import '../../role_admin/screens/pick_shop_location_page.dart';
import '../../role_barber/screens/add_barbers_services_page.dart';
import 'dashboard_page.dart';
import 'edit_salon_profile_page.dart';
import 'edit_services_page.dart';
import 'manage_team_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, dynamic>? settingsData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSettingsData();
  }

  Future<void> fetchSettingsData() async {
    try {
      setState(() => isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";
      final ownerId = prefs.getInt("ownerId");

      if (token.isEmpty || ownerId == null) return;

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

      if (ownerRes.statusCode != 200 || shopsRes.statusCode != 200) return;

      final owner = jsonDecode(ownerRes.body);
      final shops = jsonDecode(shopsRes.body);

      if (shops.isEmpty) return;

      final shopId = shops[0]["id"];
      final shopName = shops[0]["shopName"] ?? "My Salon";

      prefs.setInt("selectedShopId", shopId);

      final barberRes = await http.get(
        Uri.parse("http://10.0.2.2:8082/api/barbers/shop/$shopId"),
        headers: headers,
      );

      final serviceRes = await http.get(
        Uri.parse("http://10.0.2.2:8082/api/shop/services/shop/$shopId"),
        headers: headers,
      );

      final barbers = barberRes.statusCode == 200 ? jsonDecode(barberRes.body) : [];
      final services = serviceRes.statusCode == 200 ? jsonDecode(serviceRes.body) : [];

      setState(() {
        settingsData = {
          "profile": {
            "ownerName": owner["name"] ?? "",
            "email": owner["email"] ?? "",
            "phone": owner["phone"] ?? "",
            "salonInfo": shopName,
          },
          "teamManagement": {
            "staffCount": barbers.length,
          },
          "servicesPricing": {
            "servicesCount": services.length,
          }
        };
        isLoading = false;
      });

    } catch (e) {
      print("Settings error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: theme.textTheme.bodyMedium!.color,
          ),
        ),
      ),

      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSettingsCard(
              context: context,
              title: "Profile",
              options: isLoading
                  ? ["Loading...", "Loading...", "Loading..."]
                  : [
                settingsData?["profile"]["ownerName"],
                "${settingsData?["profile"]["phone"]} / ${settingsData?["profile"]["email"]}",
                settingsData?["profile"]["salonInfo"]
              ],
              buttonText: "Edit Profile",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const EditSalonProfilePage()));
              },
            ),
            const SizedBox(height: 16),

            _buildSettingsCard(
              context: context,
              title: "Team Management",
              options: isLoading
                  ? ["Loading..."]
                  : ["Staff Count: ${settingsData?["teamManagement"]["staffCount"]}"],
              buttonText: "Manage Team",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ManageTeamPage()));
              },
            ),
            const SizedBox(height: 16),

            _buildSettingsCard(
              context: context,
              title: "Services & Pricing",
              options: isLoading
                  ? ["Loading..."]
                  : ["Total Services: ${settingsData?["servicesPricing"]["servicesCount"]}"],
              buttonText: "Edit Services",
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const EditServicesPage()));
              },
            ),
            const SizedBox(height: 16),

            _buildPreferencesCard(context),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: 3,
        selectedItemColor: const Color(0xFF363062),
        unselectedItemColor:
        isDark ? Colors.white70 : Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,

        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddBarbersServicesPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PickShopLocationPage()),
            );
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: ''),
        ],
      ),
    );
  }

  // ---------------- CARD UI ----------------
  Widget _buildSettingsCard({
    required BuildContext context,
    required String title,
    required List<String> options,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.white12
                : Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.textTheme.bodyMedium!.color,
            ),
          ),
          const SizedBox(height: 6),

          for (var line in options)
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                line,
                style: TextStyle(
                  fontSize: 15,
                  color: theme.textTheme.bodyMedium!.color,
                ),
              ),
            ),

          const SizedBox(height: 4),

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 140,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF363062),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onPressed,
                child: const Text(
                  "Edit Profile",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // ---------------- DARK MODE CARD ----------------
  Widget _buildPreferencesCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.white10
                : Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "App Preferences",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: theme.textTheme.bodyMedium!.color,
            ),
          ),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dark Mode",
                style: TextStyle(
                  fontSize: 15,
                  color: theme.textTheme.bodyMedium!.color,
                ),
              ),

              Switch(
                value: isDark,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme(value);
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF363062),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
