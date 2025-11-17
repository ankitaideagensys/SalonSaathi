import 'package:flutter/material.dart';
import 'package:untitled/presentation/role_admin/screens/pick_shop_location_page.dart';
import '../../role_barber/screens/add_barbers_services_page.dart';
import 'app_preferences_page.dart';
import 'dashboard_page.dart';
import 'package:untitled/presentation/role_admin/screens/edit_salon_profile_page.dart';

import 'edit_services_page.dart';
import 'manage_team_page.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff7f7f7),

      // ------------------- APP BAR -------------------
        appBar: AppBar(
          backgroundColor: const Color(0xfff7f7f7),  // ✔ perfect grey app bar
          elevation: 0,                              // ✔ removes shadow
          surfaceTintColor: Colors.transparent,      // ✔ prevents color overlay
          centerTitle: true,
          title: const Text(
            "Settings",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),


        // ------------------- BODY -------------------
        body: Container(
          color: const Color(0xfff7f7f7),
            padding: const EdgeInsets.all(16),
            child: Column(
            children: [
            // -------- PROFILE CARD ----------
            _buildSettingsCard(
              title: "Profile",
              options: const ["Owner Name", "Phone  /  Email", "Salon Info"],
              buttonText: "Edit Profile",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditSalonProfilePage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // -------- TEAM MANAGEMENT ----------
            _buildSettingsCard(
              title: "Team Management",
              options: const ["Manage Staff", "Assign Roles"],
              buttonText: "Manage Team",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ManageTeamPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // -------- SERVICES ----------
            _buildSettingsCard(
              title: "Services & Pricing",
              options: const ["Add / Edit", "Update Prices"],
              buttonText: "Edit Services",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditServicesPage(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),

            // -------- APP PREFERENCES ----------
              _buildPreferencesCard(context),
            ],
        ),
          ),


      // ------------------- BOTTOM NAV BAR -------------------
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xfff7f7f7),
        type: BottomNavigationBarType.fixed,
        currentIndex: 3, // Settings selected
        selectedItemColor: const Color(0xFF363062),
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddBarbersServicesPage()),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PickShopLocationPage()),
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

  // ------------------- CARD WIDGET -------------------
  Widget _buildSettingsCard({
    required String title,
    required List<String> options,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 6),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: options
                .map(
                  (e) => Padding(
                padding: const EdgeInsets.only(bottom: 3),
                child: Text(
                  e,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                ),
              ),
            )
                .toList(),
          ),

        const SizedBox(height: 2), // move buttons slightly up

          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: 140,
              height: 40,
              child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff322a59),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onPressed,
              child: Text(
                buttonText,
                style: const TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ),
        ),
       ],
      ),
    );
  }

  // ------------------- PREFERENCES WIDGET -------------------
  Widget _buildPreferencesCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "App Preferences",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Dark Mode",
                style: TextStyle(fontSize: 15),
              ),
              Switch(
                value: false,
                onChanged: (value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AppPreferencesPage()),
                  );
                },
                activeColor: Colors.white,
                activeTrackColor: const Color(0xff322a59),
              ),
            ],
          ),

          const SizedBox(height: 6),

        ],
      ),
    );
  }
}
