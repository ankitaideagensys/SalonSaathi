import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Screens
import '../../role_admin/screens/add_new_service_page.dart';
import '../../role_admin/screens/dashboard_page.dart';
import '../../role_admin/screens/pick_shop_location_page.dart';
import '../../role_admin/screens/settings_page.dart';
import 'add_new_barber_page.dart';
import 'add_service_entry_page.dart';

class AddBarbersServicesPage extends StatefulWidget {
  const AddBarbersServicesPage({super.key});

  @override
  State<AddBarbersServicesPage> createState() => _AddBarbersServicesPageState();
}

class _AddBarbersServicesPageState extends State<AddBarbersServicesPage> {
  List<dynamic> barbers = [];
  List<dynamic> services = [];

  final String baseUrl = "http://10.0.2.2:8082";

  @override
  void initState() {
    super.initState();
    _fetchBarbers();
    _fetchServices();
  }

  // ---------------- FETCH BARBERS ----------------
  Future<void> _fetchBarbers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      String salonName = prefs.getString("salonName") ?? "";

      if (salonName.isEmpty) return;

      final response = await http.get(
        Uri.parse("$baseUrl/api/barbers/salon/$salonName"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        setState(() => barbers = jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error loading barbers: $e");
    }
  }

  // ---------------- DELETE SERVICE ----------------
  Future<void> _deleteService(int serviceId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final response = await http.delete(
        Uri.parse("$baseUrl/api/shop/services/$serviceId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        _fetchServices();
      }
    } catch (e) {
      debugPrint("Error deleting service: $e");
    }
  }

  void _confirmDelete(BuildContext context, int id) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium!.color;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.cardColor,
        title: Text("Delete Service", style: TextStyle(color: textColor)),
        content: Text("Are you sure?", style: TextStyle(color: textColor)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: textColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteService(id);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ---------------- FETCH SERVICES ----------------
  Future<void> _fetchServices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final shopId = prefs.getInt("shopId") ?? 1;
      final token = prefs.getString("token");

      final response = await http.get(
        Uri.parse("$baseUrl/api/shop/services/shop/$shopId"),
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        List list = jsonDecode(response.body);
        setState(() => services = list);
      }
    } catch (e) {
      debugPrint("Error loading services: $e");
    }
  }

  // ---------------- BARBER IMAGE ----------------
  ImageProvider _buildBarberImage(dynamic barber) {
    String? url = barber["photoUrl"];
    if (url == null || url.isEmpty) {
      return const NetworkImage("http://10.0.2.2:8082/images/default_barber.png");
    }
    if (url.startsWith("/images")) {
      return NetworkImage("http://10.0.2.2:8082$url");
    }
    return NetworkImage(url);
  }

  // ---------------- SERVICE ICON ----------------
  Widget buildIcon(String? iconUrl) {
    if (iconUrl == null || iconUrl.isEmpty) {
      return const Icon(Icons.miscellaneous_services, size: 26);
    }

    if (iconUrl.startsWith("http")) {
      return Image.network(iconUrl, width: 26, height: 26);
    }

    return Image.asset("assets/icons/$iconUrl", width: 26, height: 26);
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium!.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        toolbarHeight: 30,
        title: Text(
          "Add Barbers & Services",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w700,
            fontSize: 25,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Add your team and the service they offer",
                  style: TextStyle(color: textColor!.withOpacity(0.6), fontSize: 16),
                ),
              ),

              const SizedBox(height: 20),

              Text("Barbers",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor)),
              const SizedBox(height: 12),

              Row(
                children: [
                  ...barbers.map((b) => Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddServiceEntryPage(barberName: b["name"]),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: _buildBarberImage(b),
                          ),
                          const SizedBox(height: 6),
                          Text(b["name"], style: TextStyle(color: textColor)),
                        ],
                      ),
                    ),
                  )),

                  const Spacer(),

                  GestureDetector(
                    onTap: () async {
                      final added = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddNewBarberPage()),
                      );
                      if (added == true) _fetchBarbers();
                    },
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.colorScheme.primary, width: 1.2),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.add, color: theme.colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            "Add Barber",
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Text("Services",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor)),
              const SizedBox(height: 16),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final s = services[index];

                  return GestureDetector(
                    onLongPress: () => _confirmDelete(context, s["id"]),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity(0.08),
                                blurRadius: 6,
                              )
                            ],
                          ),
                          child: Center(child: buildIcon(s["iconUrl"])),
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: 90,
                          child: Text(
                            s["name"],
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: textColor),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              GestureDetector(
                onTap: () async {
                  final added = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddNewServicePage()),
                  );
                  if (added == true) _fetchServices();
                },
                child: Row(
                  children: [
                    Icon(Icons.add, color: theme.colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      "Add Services",
                      style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.scaffoldBackgroundColor,
        currentIndex: 1,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: textColor.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,

        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardPage()));
          } else if (index == 2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PickShopLocationPage()));
          } else if (index == 3) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
          }
        },

        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.location_on_rounded), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: ''),
        ],
      ),
    );
  }
}
