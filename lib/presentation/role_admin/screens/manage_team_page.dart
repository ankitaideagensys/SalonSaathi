import 'package:flutter/material.dart';

import 'add_barber_page.dart';

class ManageTeamPage extends StatelessWidget {
  const ManageTeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      appBar: AppBar(
        backgroundColor: Color(0xFFF7F7F7),
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
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 26,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------- STAFF TITLE ----------------
            const Text(
              "Salon Staff",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            // ---------------- STAFF CARD ----------------
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 38, horizontal: 28),
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

                  staffTile("Salman"),
                  const SizedBox(height: 25),

                  staffTile("Aadil"),
                  const SizedBox(height: 25),

                  staffTile("Aman"),
                  const SizedBox(height: 25),

                  // ---------- Salon Details ----------
                  const Text(
                    "Salon Details",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 18),

                  detailTile(Icons.person_outline, "Salon Name"),
                  const SizedBox(height: 18),

                  detailTile(Icons.location_on_outlined, "Address"),
                  const SizedBox(height: 25),

                  // ---------- ADD STAFF BUTTON ----------
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

            const SizedBox(height: 18),

            // ---------------- SAVE BUTTON ----------------
            Center(
              child: SizedBox(
                width: 130,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF363062),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 45),
          ],
        ),
      ),
    );
  }

  // ---------------- STAFF TILE WIDGET ----------------
  Widget staffTile(String name) {
    return Row(
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
    );
  }


  // ---------------- DETAILS TILE WIDGET ----------------
  Widget detailTile(IconData icon, String label) {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 22,
            color: Colors.grey.shade700,
          ),
        ),

        const SizedBox(width: 12),

        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
