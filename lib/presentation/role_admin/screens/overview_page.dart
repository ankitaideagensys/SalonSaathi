import 'package:flutter/material.dart';
import 'pick_shop_location_page.dart';
import '../../role_barber/screens/add_barbers_services_page.dart';
import 'dashboard_page.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  DateTime? selectedMonthDate;
  String selectedTab = "Today";

  String getSummaryTitle() {
    if (selectedTab == "Today") {
      return "Today's Total";
    } else if (selectedTab == "Yesterday") {
      return "Yesterday's Total";
    } else {
      return "Month's Total";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: const Color(0xFFF8F8F8),
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          toolbarHeight: 44,
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.black, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  "Daily Performance Overview",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    height: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),


      // 🔹 Body
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Subtitle
          const Padding(
          padding: EdgeInsets.only(top: 0),
          child: Text(
            "Quick view of your salon's daily\nperformance",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              height: 1.2,
                ),
              ),
            ),
              const SizedBox(height: 22),

              // 🔹 Tabs (pill-shaped, OG-aligned)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTabButton("Today"),
                  _buildTabButton("Yesterday"),
                  _buildTabButton("Month"),
                ],
              ),

              const SizedBox(height: 50),

              // 🔹 Summary Cards Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryCard(getSummaryTitle(), "R\$1,000"),
                  _buildSummaryCard("Total Customers", "20"),
                  _buildSummaryCard("Active Barbers", "3"),
                ],
              ),

              const SizedBox(height: 55), // ✅ Space between summary cards & barber list card (OG exact)

              // 🔹 Barbers Performance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14), // ✅ OG roundness
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  children: [
                    _buildBarberTile("Aman", "Rs700 · 7 services", "assets/images/barber1.png"),
                    _divider(),
                    _buildBarberTile("Salman", "Rs450 · 2 services", "assets/images/barber2.png"),
                    _divider(),
                    _buildBarberTile("Aadil", "Rs450 · 2 services", "assets/images/barber3.png"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // 🔹 Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: 0, // assuming location (Overview) page index is 2
        selectedItemColor: const Color(0xFF363062),
        unselectedItemColor: Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            // 🏠 Navigate to DashboardPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardPage()),
            );
          } else if (index == 1) {
            // ➕ Navigate to AddBarbersServicesPage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AddBarbersServicesPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PickShopLocationPage()),
            );
          } else if (index == 3) {
            // ⚙️ Settings placeholder
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Settings tapped")),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: ""),
        ],
      ),

    );
  }

  // 🔹 Pill-shaped Tab Button (OG accurate)
  Widget _buildTabButton(String label) {
    final bool isSelected = label == selectedTab;

    return GestureDetector(
      onTap: () async {
        if (label == "Month") {
          // OPEN DATE PICKER 📅
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );

          // user selects OR cancels — still show Month tab
          setState(() {
            selectedTab = "Month";
            selectedMonthDate = picked; // optional data storage
          });
        } else {
          // TODAY or YESTERDAY
          setState(() {
            selectedTab = label;
          });
        }
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 38,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF34A853) : const Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 13.5,
          ),
        ),
      ),
    );
  }


  // 🔹 Summary Card
  Widget _buildSummaryCard(String title, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 12.5,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Barber Tile
  Widget _buildBarberTile(String name, String detail, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 Divider (exact OG)
  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Divider(
        height: 1,
        thickness: 0.8,
        color: Color(0xFFDADADA), // ✅ soft OG line
      ),
    );
  }
}
