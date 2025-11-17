import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:untitled/presentation/role_admin/screens/pick_shop_location_page.dart';
import 'package:untitled/presentation/role_admin/screens/settings_page.dart';
import '../../role_barber/screens/add_barbers_services_page.dart';
import 'dashboard_page.dart';

class SalonDashboardPage extends StatefulWidget {
  final String shopName; // dynamic shop name

  const SalonDashboardPage({super.key, required this.shopName});

  @override
  State<SalonDashboardPage> createState() => _SalonDashboardPageState();
}

class _SalonDashboardPageState extends State<SalonDashboardPage> {
  String selectedPeriod = "Today";

  final List<Map<String, dynamic>> appointments = [
    {"time": "10:00 AM", "customer": "   Priya", "service": "Haircut", "barber": "Salman", "status": "Completed"},
    {"time": "11:00 AM", "customer": "   Rahul", "service": "Beard Trim", "barber": "Aadil", "status": "In Progress"},
    {"time": "12:15 PM", "customer": "   Sunita", "service": "Color Hair", "barber": "Aman", "status": "Upcoming"},
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed": return Colors.green;
      case "In Progress": return Colors.orange;
      case "Upcoming": return Colors.blue;
      default: return Colors.grey;
    }
  }

  String getSubtitleText() {
    if (selectedPeriod == "Today") {
      return "Here’s what’s happening in your shop today.";
    } else if (selectedPeriod == "Yesterday") {
      return "Here’s what happened in your shop yesterday.";
    } else {
      return "Here’s what’s happening in your shop this month.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,  // Home icon selected by default
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
          else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SettingsPage()),
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

      body: SafeArea(
        child: Column(
          children: [
            // ----------------- HEADER -----------------
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.home_filled, size: 26, color: Color(0xFF363062)),
                      const SizedBox(width: 10),
                      Text(
                        widget.shopName,   // Dynamic shop name
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF363062),
                        ),
                      ),
                    ],
                  ),

                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/images/barber1.png'),
                  ),
                ],
              ),
            ),

            Container(height: 1, color: Colors.grey.shade300, margin: const EdgeInsets.symmetric(horizontal: 16)),

            // ----------------- BODY -----------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting
                    const Text(
                      "Good afternoon, Manil 👋",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),

                    Text(
                      getSubtitleText(),
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),

                    // ---------------- FILTER BUTTONS ----------------
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPeriodButton("Today", isSelected: selectedPeriod == "Today"),
                            _buildPeriodButton("Yesterday", isSelected: selectedPeriod == "Yesterday"),
                            _buildPeriodButton("Month", isSelected: selectedPeriod == "Month"),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ---------------- DASHBOARD CARDS ----------------
                    Row(
                      children: [
                        Expanded(child: _buildCard("     Revenue", "  Rs 5,400")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildCard("    Bookings", "      27")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildCard("     Services", "       20")),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(child: _buildCard("          Active Staff", "            3")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildCard("              Rating", "          4.7 / 5")),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ---------------- APPOINTMENTS (NEW DASHBOARD STYLE) ----------------
                    Text(
                      "${selectedPeriod}'s Appointments",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      color: Colors.grey.shade100,
                      child: const Row(
                        children: [
                          Expanded(flex: 2, child: Text("Time", style: TextStyle(fontWeight: FontWeight.w600),maxLines: 1, overflow: TextOverflow.ellipsis,)),
                          Expanded(flex: 3, child: Text("Customer", style: TextStyle(fontWeight: FontWeight.w600))),
                          Expanded(flex: 3, child: Text("Service", style: TextStyle(fontWeight: FontWeight.w600))),
                          Expanded(flex: 2, child: Text("Barber", style: TextStyle(fontWeight: FontWeight.w600))),
                          Expanded(flex: 2, child: Text("Status", style: TextStyle(fontWeight: FontWeight.w600))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 6),

                    Column(
                      children: List.generate(appointments.length, (index) {
                        final item = appointments[index];
                        final isLast = index == appointments.length - 1;

                        return Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Expanded(flex: 2, child: Text(item['time'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))),
                                  Expanded(flex: 3, child: Text(item['customer'], style: const TextStyle(fontSize: 13))),
                                  Expanded(flex: 3, child: Text(item['service'], style: const TextStyle(fontSize: 13))),
                                  Expanded(flex: 2, child: Text(item['barber'], style: const TextStyle(fontSize: 13))),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(item['status']).withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        item['status'],
                                        style: TextStyle(
                                          color: _getStatusColor(item['status']),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            if (!isLast)
                              Container(
                                height: 1,
                                color: const Color(0xFFE0E0E0),
                                margin: const EdgeInsets.symmetric(horizontal: 12),
                              ),
                          ],
                        );
                      }),
                    ),

                    const SizedBox(height: 24),

// ---------------- SERVICES BY TYPE (NEW DASHBOARD STYLE) ----------------
                    const Text(
                      "Services by Type",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(height: 10, width: 10, decoration: const BoxDecoration(color: Color(0xFF3C2769), shape: BoxShape.circle)),
                                    const SizedBox(width: 8),
                                    const Text("Haircut (48%)"),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    Container(height: 10, width: 10, decoration: const BoxDecoration(color: Color(0xFF73A4FF), shape: BoxShape.circle)),
                                    const SizedBox(width: 8),
                                    const Text("Shaving (30%)"),
                                  ],
                                ),
                                const SizedBox(height: 18),
                                Row(
                                  children: [
                                    Container(height: 10, width: 10, decoration: const BoxDecoration(color: Color(0xFFD1D9F0), shape: BoxShape.circle)),
                                    const SizedBox(width: 8),
                                    const Text("Beard Trim (22%)"),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 180,
                            width: 180,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 0,
                                borderData: FlBorderData(show: false),
                                sections: [
                                  PieChartSectionData(color: const Color(0xFF3C2769), value: 48, title: '48%', radius: 70, titleStyle: const TextStyle(color: Colors.white)),
                                  PieChartSectionData(color: const Color(0xFF73A4FF), value: 30, title: '30%', radius: 70, titleStyle: const TextStyle(color: Colors.white)),
                                  PieChartSectionData(color: const Color(0xFFD1D9F0), value: 22, title: '22%', radius: 70, titleStyle: const TextStyle(color: Colors.black87)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------- WIDGETS -----------------

  Widget _buildPeriodButton(String label, {required bool isSelected}) {
    return GestureDetector(
      onTap: () async {
        if (label == "Month") {
          // Open date picker
          DateTime? selected = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color(0xFF34A853),
                    onPrimary: Colors.white,
                    onSurface: Colors.black,
                  ),
                ),
                child: child!,
              );
            },
          );
          setState(() => selectedPeriod = "Month");
        } else {
          setState(() => selectedPeriod = label);
        }
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 36,
        width: 90, // EXACT SIZE from old Dashboard
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF34A853) : const Color(0xFFD9D9D9),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? const Color(0xFF34A853) : const Color(0xFFD9D9D9),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 6),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _appointmentRow({
    required String time,
    required String customer,
    required String service,
    required String barber,
    required String status,
  }) {
    final color = _getStatusColor(status);
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(time)),
              Expanded(flex: 3, child: Text(customer)),
              Expanded(flex: 3, child: Text(service)),
              Expanded(flex: 2, child: Text(barber)),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(height: 1, color: Colors.grey.shade300),
      ],
    );
  }

  Widget _legendDot(Color color, String text) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
