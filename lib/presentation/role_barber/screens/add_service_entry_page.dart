import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'service_success_page.dart';

class AddServiceEntryPage extends StatefulWidget {
  final String barberName;
  const AddServiceEntryPage({super.key, required this.barberName});

  @override
  State<AddServiceEntryPage> createState() => _AddServiceEntryPageState();
}

class _AddServiceEntryPageState extends State<AddServiceEntryPage> {
  static const String baseUrl = "http://10.0.2.2:8082";

  List barbers = [];
  List services = [];

  int? selectedBarberId;
  int? selectedServiceId;

  String? selectedBarberName;
  String? selectedBarberImage;
  String? selectedServiceName;

  int quantity = 1;
  double unitPrice = 0;
  int estimatedDuration = 0;
  String estimatedTime = "0 min";

  bool isLoading = true;
  bool isSubmitting = false;

  // ---------------------------------------------------------
  // Service Icon Handler (Fix For PNG + URL)
  // ---------------------------------------------------------
  Widget serviceIcon(String? iconUrl) {
    if (iconUrl == null || iconUrl.isEmpty) {
      return const Icon(Icons.design_services, size: 26);
    }

    // If backend returns full URL (Spa case)
    if (iconUrl.startsWith("http")) {
      return Image.network(
        iconUrl,
        width: 26,
        height: 26,
        errorBuilder: (_, __, ___) =>
        const Icon(Icons.design_services, size: 26),
      );
    }

    // If backend returns file name like Haircut.png → load from assets/icons/
    return Image.asset(
      "assets/icons/$iconUrl",
      width: 26,
      height: 26,
      errorBuilder: (_, __, ___) =>
      const Icon(Icons.design_services, size: 26),
    );
  }

  // ---------------------------------------------------------
  // Barber Image Handler
  // ---------------------------------------------------------
  String getImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return "$baseUrl/images/default_barber.png";
    }

    if (path.startsWith("/images")) return "$baseUrl$path";
    if (path.startsWith("http")) return path;

    return "$baseUrl/images/default_barber.png";
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  // ---------------------------------------------------------
  // LOAD BARBERS + SERVICES
  // ---------------------------------------------------------
  Future<void> _loadInitialData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token") ?? "";

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final barberRes =
      await http.get(Uri.parse("$baseUrl/api/barbers"), headers: headers);

      final serviceRes = await http.get(
          Uri.parse("$baseUrl/api/shop/services/shop/1"),
          headers: headers);

      if (barberRes.statusCode == 200 && serviceRes.statusCode == 200) {
        barbers = jsonDecode(barberRes.body);
        services = jsonDecode(serviceRes.body);

        // Preselect barber
        if (barbers.isNotEmpty) {
          selectedBarberId = barbers[0]["id"];
          selectedBarberName = barbers[0]["name"];
          selectedBarberImage = barbers[0]["photoUrl"];
        }

        // Preselect service
        if (services.isNotEmpty) {
          selectedServiceId = services[0]["id"];
          selectedServiceName = services[0]["name"];
          unitPrice = (services[0]["price"] as num).toDouble();
          estimatedDuration = services[0]["estimatedDuration"] ?? 0;
          estimatedTime = "$estimatedDuration min";
        }

        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  // ---------------------------------------------------------
  // SUBMIT ENTRY
  // ---------------------------------------------------------
  Future<void> _submitServiceEntry() async {
    if (selectedBarberId == null || selectedServiceId == null) return;

    setState(() => isSubmitting = true);

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token") ?? "";

    final headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = {
      "barberId": selectedBarberId,
      "shopId": 1,
      "serviceId": selectedServiceId,
      "quantity": quantity,
    };

    try {
      final res = await http.post(
        Uri.parse("$baseUrl/api/barber/entries/add"),
        headers: headers,
        body: jsonEncode(body),
      );

      setState(() => isSubmitting = false);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ServiceSuccessPage(
              name: selectedBarberName ?? "",
              service: selectedServiceName ?? "",
              total: data["totalPrice"].toString(),
              duration: "${data["duration"]} min",
              image: getImageUrl(selectedBarberImage),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to save entry")),
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  double get totalPrice => unitPrice * quantity;

  // ---------------------------------------------------------
  // UI
  // ---------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        toolbarHeight: 27,
        leading: IconButton(
          icon:
          const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Add Services Entry",
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.w700, color: Colors.black),
        ),
        centerTitle: true,
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding:
        const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "A service to your barber and set the\nquantity.",
                textAlign: TextAlign.center,
                style:
                TextStyle(fontSize: 15, color: Colors.black54),
              ),
            ),

            const SizedBox(height: 28),

            _buildBarberSelector(),
            const SizedBox(height: 28),

            _buildServiceSelector(),
            const SizedBox(height: 28),

            _buildQuantity(),
            const SizedBox(height: 32),

            _buildTotals(),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: _buildSaveButton(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // Barber Selector UI
  // ---------------------------------------------------------
  Widget _buildBarberSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Barber",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),

        GestureDetector(
          onTap: _openBarberSheet,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: _boxDecoration(),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage:
                  NetworkImage(getImageUrl(selectedBarberImage)),
                ),
                const SizedBox(width: 10),

                Text(selectedBarberName ?? "Select Barber",
                    style: const TextStyle(fontSize: 15)),

                const Spacer(),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openBarberSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 350,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: barbers.length,
                  itemBuilder: (context, index) {
                    final b = barbers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundImage:
                        NetworkImage(getImageUrl(b["photoUrl"])),
                      ),
                      title: Text(b["name"]),
                      onTap: () {
                        setState(() {
                          selectedBarberId = b["id"];
                          selectedBarberName = b["name"];
                          selectedBarberImage = b["photoUrl"];
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // Service Selector UI
  // ---------------------------------------------------------
  Widget _buildServiceSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Service",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),

        GestureDetector(
          onTap: _openServiceSheet,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: _boxDecoration(),
            child: Row(
              children: [
                if (selectedServiceId != null)
                  serviceIcon(
                    services.firstWhere(
                            (s) => s["id"] == selectedServiceId)["iconUrl"],
                  ),

                const SizedBox(width: 10),

                Text(selectedServiceName ?? "Select Service",
                    style: const TextStyle(fontSize: 15)),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_down_rounded),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _openServiceSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: 450,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final s = services[index];

                    return ListTile(
                      leading: serviceIcon(s["iconUrl"]),
                      title: Text(s["name"]),
                      subtitle: Text(
                          "Rs ${s["price"]} • ${s["estimatedDuration"]} min"),
                      onTap: () {
                        setState(() {
                          selectedServiceId = s["id"];
                          selectedServiceName = s["name"];
                          unitPrice = (s["price"] as num).toDouble();

                          estimatedDuration = s["estimatedDuration"] ?? 0;
                          estimatedTime = "$estimatedDuration min";
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // Quantity Selector
  // ---------------------------------------------------------
  Widget _buildQuantity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quantity",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),

        Row(
          children: [
            _qtyButton(Icons.remove, () {
              if (quantity > 1) setState(() => quantity--);
            }),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text("$quantity",
                  style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),

            _qtyButton(Icons.add, () {
              setState(() => quantity++);
            }),
          ],
        ),
      ],
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFD9D9D9)),
        ),
        child: Icon(icon, size: 18),
      ),
    );
  }

  // ---------------------------------------------------------
  // Totals UI
  // ---------------------------------------------------------
  Widget _buildTotals() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text("Rs ${totalPrice.toStringAsFixed(0)}",
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Estimated Time",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(estimatedTime,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  // Save Button
  // ---------------------------------------------------------
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : _submitServiceEntry,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF363062),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
        ),
        child: isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text("Save",
            style: TextStyle(fontSize: 24, color: Colors.white)),
      ),
    );
  }

  // ---------------------------------------------------------
  // Box Decoration Helper
  // ---------------------------------------------------------
  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: const Color(0xFFD9D9D9)),
    );
  }
}
