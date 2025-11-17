import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:untitled/presentation/role_admin/screens/pick_shop_location_page.dart';
import 'package:untitled/presentation/role_admin/screens/settings_page.dart';
import '../../role_barber/screens/add_barbers_services_page.dart';
import 'notification_screen.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String selectedPeriod = "Today";

  final List<Map<String, dynamic>> appointments = [
    {"time": "10:00 AM", "customer": "   Priya", "service": "Haircut", "barber": "Salman", "status": "Completed"},
    {"time": "11:00 AM", "customer": "   Rahul", "service": "Beard Trim", "barber": "Aadil", "status": "In Progress"},
    {"time": "12:15 PM", "customer": "   Sunita", "service": "Color Hair", "barber": "Aman", "status": "Upcoming"},
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "In Progress":
        return Colors.orange;
      case "Upcoming":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String getSubtitleText() {
    if (selectedPeriod == "Today") {
      return "Here’s what’s happening at your salon today.";
    } else if (selectedPeriod == "Yesterday") {
      return "Here’s what happened at your salon yesterday.";
    } else {
      return "Here’s what’s happening at your salon this month.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        selectedItemColor: const Color(0xFF468A49),
        unselectedItemColor: Colors.black54,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 1) {
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
            Navigator.push(
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
            // ✅ Fixed Header
            Container(
              color: const Color(0xFFF8F8F8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/logo.png', height: 28),
                      const SizedBox(width: 8),
                      const Text(
                        "SalonSaathi",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF363062),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFFFF3D00)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),

            Container(
              height: 1,
              color: const Color(0xFFE0E0E0),
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            // ✅ Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🔹 Filter Buttons (perfectly matched to Figma)
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          color:  Colors.transparent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child:Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildPeriodButton("Today", isSelected: selectedPeriod == "Today"),
                            _buildPeriodButton("Yesterday", isSelected: selectedPeriod == "Yesterday"),
                            _buildPeriodButton("Month", isSelected: selectedPeriod == "Month"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),


                    // 🔹 Greeting
                    const Text(
                      "Good afternoon, Rohit 👋",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      getSubtitleText(),
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    const SizedBox(height: 20),

                    // 🔹 Dashboard Cards
                    Row(
                      children: [
                        Expanded(child: _buildDashboardCard("   Revenue", "  Rs5,400")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDashboardCard("Total Booking", "      27")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDashboardCard("    Services", "      20")),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildDashboardCard("         Active Staff", "            3")),
                        const SizedBox(width: 12),
                        Expanded(child: _buildDashboardCard("    Customer Ratings", "        4.7 / 5")),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Appointments
                    Text(
                      "${selectedPeriod}'s Appointments",
                      style: TextStyle(
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
                          Expanded(flex: 2, child: Text("Time", style: TextStyle(fontWeight: FontWeight.w600))),
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
                        return _buildAppointmentRow(
                          item['time']!,
                          item['customer']!,
                          item['service']!,
                          item['barber']!,
                          item['status']!,
                          showDivider: !isLast,
                        );
                      }),
                    ),
                    const SizedBox(height: 24),

                    // 🔹 Services by Type (visible, subtle card)
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
                          // ✅ Soft, minimal elevation to make it visible
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05), // very subtle
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // ⬅️ Expanded LABELS (THIS fixes overflow)
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLegendDot(const Color(0xFF3C2769), "Haircut (48%)"),
                                  const SizedBox(height: 18),
                                  _buildLegendDot(const Color(0xFF73A4FF), "Shaving (30%)"),
                                  const SizedBox(height: 18),
                                  _buildLegendDot(const Color(0xFFD1D9F0), "Beard Trim (22%)"),
                                ],
                              ),
                            ),

                            // ➡️ Move Piechart slightly RIGHT
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: SizedBox(
                                height: 180,
                                width: 180,
                                child: PieChart(
                                  PieChartData(
                                    sectionsSpace: 0,
                                    centerSpaceRadius: 0,
                                    borderData: FlBorderData(show: false),
                                    sections: [
                                      PieChartSectionData(
                                        color: Color(0xFF3C2769),
                                        value: 48,
                                        title: '48%',
                                        radius: 70,
                                        titleStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      PieChartSectionData(
                                        color: Color(0xFF73A4FF),
                                        value: 30,
                                        title: '30%',
                                        radius: 70,
                                        titleStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      PieChartSectionData(
                                        color: Color(0xFFD1D9F0),
                                        value: 22,
                                        title: '22%',
                                        radius: 70,
                                        titleStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )

                    ),

                    const SizedBox(height: 16
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                    primary: Color(0xFF34A853), // header color
                    onPrimary: Colors.white, // text color
                    onSurface: Colors.black, // body text color
                  ),
                ),
                child: child!,
              );
            },
          );

          // Even if a date is selected or cancelled, keep same data
          setState(() {
            selectedPeriod = "Month";
          });
        } else {
          // Today or Yesterday
          setState(() {
            selectedPeriod = label;
          });
        }
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 36,
        width: 90, // perfect width for equal spacing
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


  Widget _buildDashboardCard(String title, String value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE0E0E0), // light gray border like in Figma
          width: 1,
        ),
        boxShadow: const [], // remove shadow completely
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAppointmentRow(String time, String customer, String service, String barber, String status,
      {bool showDivider = true}) {
    final color = _getStatusColor(status);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(flex: 2, child: Text(time, style: const TextStyle(fontSize: 13))),
              Expanded(flex: 3, child: Text(customer, style: const TextStyle(fontSize: 13))),
              Expanded(flex: 3, child: Text(service, style: const TextStyle(fontSize: 13))),
              Expanded(flex: 2, child: Text(barber, style: const TextStyle(fontSize: 13))),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FittedBox(
                    child: Text(
                      status,
                      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Container(height: 1, color: const Color(0xFFE0E0E0), margin: const EdgeInsets.symmetric(horizontal: 12)),
      ],
    );
  }

  Widget _buildLegendDot(Color color, String label) {
    return Row(
      children: [
        Container(height: 10, width: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
