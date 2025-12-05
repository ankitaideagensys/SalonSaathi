import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'add_barber_page.dart';

class ManageTeamPage extends StatefulWidget {
  const ManageTeamPage({super.key});

  @override
  State<ManageTeamPage> createState() => _ManageTeamPageState();
}

class _ManageTeamPageState extends State<ManageTeamPage> {
  bool isLoading = true;

  List<dynamic> staffList = [];
  String salonName = "";
  String salonAddress = "";

  @override
  void initState() {
    super.initState();
    fetchTeamData();
  }

  Future<void> fetchTeamData() async {
    final url = Uri.parse(
      "https://8f4d00a1-35af-4fa5-83ab-e665e09b68c1.mock.pstmn.io/team",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          staffList = data["team"]["staff"];
          salonName = data["team"]["salonName"];
          salonAddress = data["team"]["salonAddress"];
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching /team API: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7F7),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Manage Team",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STAFF TITLE
            const Text(
              "Salon Staff",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // STAFF CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 38, horizontal: 28),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- STAFF LIST WITH DELETE ICON ---
                  ...List.generate(staffList.length, (index) {
                    final member = staffList[index];
                    return Column(
                      children: [
                        staffTile(member["name"], index),
                        const SizedBox(height: 25),
                      ],
                    );
                  }),

                  // ADD STAFF BUTTON
                  SizedBox(
                    width: 110,
                    height: 38,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF363062),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddBarberPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Add Staff",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 45),
          ],
        ),
      ),
    );
  }

  // STAFF TILE WITH DELETE
  Widget staffTile(String name, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.grey,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        // DELETE ICON
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            setState(() {
              staffList.removeAt(index);
            });
          },
        ),
      ],
    );
  }
}
