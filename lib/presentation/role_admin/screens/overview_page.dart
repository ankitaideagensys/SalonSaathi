import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'pick_shop_location_page.dart';
import '../../role_barber/screens/add_barbers_services_page.dart';
import 'dashboard_page.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({super.key});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  // Android Emulator requires 10.0.2.2 instead of localhost
  static const String baseUrl = "http://10.0.2.2:8082/api/dashboard";

  bool _loading = true;
  String? _error;

  double total = 0.0;
  int customers = 0;
  int activeBarbers = 0;
  List<Barber> barbers = [];

  String selectedTab = "Today";
  DateTime? selectedMonthDate;

  @override
  void initState() {
    super.initState();
    _fetchOverview();
  }

  // ---------------------- API CALL ------------------------
  Future<void> _fetchOverview() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      String url;

      if (selectedTab == "Today") {
        url = "$baseUrl/overview/today?shopId=1";
      } else if (selectedTab == "Yesterday") {
        url = "$baseUrl/overview/yesterday?shopId=1";
      } else {
        if (selectedMonthDate == null) {
          selectedMonthDate = DateTime.now();
        }
        final monthStr =
            "${selectedMonthDate!.year}-${selectedMonthDate!.month.toString().padLeft(2, '0')}";
        url = "$baseUrl/overview/month?shopId=1&date=$monthStr";
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      final res = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode != 200) {
        throw Exception("Invalid status ${res.statusCode}");
      }

      final data = jsonDecode(res.body);

      setState(() {
        total = (data["totalRevenue"] ?? 0).toDouble();
        customers = data["totalCustomers"] ?? 0;
        activeBarbers = data["activeBarbers"] ?? 0;

        barbers = (data["barbers"] as List)
            .map((b) => Barber.fromJson(b))
            .toList();

        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = "Error loading overview: $e";
        _loading = false;
      });
    }
  }

  // ---------------------- UI ------------------------
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
          title: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.black, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
              const Expanded(
                child: Text(
                  "Daily Performance Overview",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton(
                  onPressed: _fetchOverview,
                  child: const Text("Retry")),
            ],
          ),
        )
            : SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding:
          const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const Text(
                "Quick view of your salon's daily\nperformance",
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: 16, color: Colors.black87),
              ),

              const SizedBox(height: 22),

              // Tabs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTabButton("Today"),
                  _buildTabButton("Yesterday"),
                  _buildTabButton("Month"),
                ],
              ),

              const SizedBox(height: 50),

              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSummaryCard(
                      getSummaryTitle(), "Rs${total.toInt()}"),
                  _buildSummaryCard(
                      "Total Customers", customers.toString()),
                  _buildSummaryCard(
                      "Active Barbers", activeBarbers.toString()),
                ],
              ),

              const SizedBox(height: 55),

              // -------- Barber List (FIXED) --------
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border:
                  Border.all(color: const Color(0xFFE0E0E0)),
                ),
                child: Column(
                  children: barbers.isEmpty
                      ? [
                    const Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        "No barbers found",
                        style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14),
                      ),
                    )
                  ]
                      : List.generate(barbers.length * 2 - 1, (i) {
                    if (i.isOdd) return _divider();
                    final index = i ~/ 2;
                    final b = barbers[index];

                    return _buildBarberTile(
                      b.name,
                      "Rs${b.earnings} · ${b.serviceCount} services",
                      (b.photoUrl != null &&
                          b.photoUrl!.isNotEmpty)
                          ? b.photoUrl
                          : null,
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF363062),
        unselectedItemColor: Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardPage()));
          } else if (index == 1) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddBarbersServicesPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const PickShopLocationPage()));
          }
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_rounded), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded), label: ""),
        ],
      ),
    );
  }

  // ---------------------- WIDGETS ------------------------

  Widget _buildTabButton(String label) {
    final isSelected = (label == selectedTab);

    return GestureDetector(
      onTap: () async {
        setState(() => selectedTab = label);

        if (label == "Month") {
          selectedMonthDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
        }

        _fetchOverview();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 38,
        width: 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF34A853)
              : const Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 13.5),
        ),
      ),
    );
  }

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
            Text(title,
                textAlign: TextAlign.center,
                style:
                const TextStyle(fontSize: 12.5, color: Colors.black54)),
            const SizedBox(height: 5),
            Text(value,
                style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
          ],
        ),
      ),
    );
  }

  Widget _buildBarberTile(String name, String detail, String? imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(
              imageUrl != null && imageUrl.isNotEmpty
                  ? imageUrl
                  : "http://10.0.2.2:8082/images/default_barber.png",
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black)),
              const SizedBox(height: 3),
              Text(detail,
                  style: const TextStyle(
                      fontSize: 13, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }


  Widget _divider() =>
      const Divider(height: 1, thickness: 0.8, color: Color(0xFFDADADA));

  String getSummaryTitle() {
    switch (selectedTab) {
      case "Today":
        return "Today's Total";
      case "Yesterday":
        return "Yesterday's Total";
      default:
        return "Month's Total";
    }
  }
}

// ---------------------- MODEL ------------------------
class Barber {
  final String name;
  final double earnings;
  final int serviceCount;
  final String? photoUrl;

  Barber({
    required this.name,
    required this.earnings,
    required this.serviceCount,
    this.photoUrl,
  });

  factory Barber.fromJson(Map<String, dynamic> json) => Barber(
    name: json["name"] ?? "",
    earnings: (json["earnings"] ?? 0).toDouble(),
    serviceCount: json["serviceCount"] ?? 0,
    photoUrl: json["photoUrl"],
  );
}
