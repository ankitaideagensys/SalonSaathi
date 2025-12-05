import 'package:flutter/material.dart';

class AppPreferencesPage extends StatefulWidget {
  const AppPreferencesPage({super.key});

  @override
  State<AppPreferencesPage> createState() => _AppPreferencesPageState();
}

class _AppPreferencesPageState extends State<AppPreferencesPage> {
  bool darkMode = true;
  bool notifications = false;

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
          "App Preferences",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // ------------------ DARK MODE CARD ------------------
            _preferenceCard(
              title: "Dark Mode",
              value: darkMode,
              onChanged: (val) {
                setState(() => darkMode = val);
              },
            ),

            const SizedBox(height: 20),

            // ------------------ NOTIFICATIONS CARD ------------------
            _preferenceCard(
              title: "Notifications",
              value: notifications,
              onChanged: (val) {
                setState(() => notifications = val);
              },
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // REUSABLE CARD WIDGET (Matches UI Exactly!!)
  // -----------------------------------------------------------
  Widget _preferenceCard({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          // Custom Switch
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF363062), // purple like screenshot
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
