import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'add_service_entry_page.dart';
import 'report_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> allEntries = [];
  List<Map<String, dynamic>> filteredEntries = [];
  String selectedFilter = "All";
  String shopName = "";

  @override
  void initState() {
    super.initState();
    loadEntries();
    loadShopName();
  }

  Future<void> loadShopName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      shopName = prefs.getString('shop_name') ?? 'My Shop';
    });
  }

  Future<void> loadEntries() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedData = prefs.getStringList('service_entries') ?? [];
    List<Map<String, dynamic>> decodedEntries =
    savedData.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    setState(() {
      allEntries = decodedEntries;
      filteredEntries = decodedEntries;
    });
  }

  void applyFilter(String barberName) {
    setState(() {
      selectedFilter = barberName;
      if (barberName == "All") {
        filteredEntries = allEntries;
      } else {
        filteredEntries =
            allEntries.where((entry) => entry['barber'] == barberName).toList();
      }
    });
  }

  int calculateTodayTotal() {
    final today = DateTime.now();
    return allEntries
        .where((entry) {
      final entryDate = DateTime.parse(entry['date']);
      return entryDate.year == today.year &&
          entryDate.month == today.month &&
          entryDate.day == today.day;
    })
        .fold(0, (sum, entry) => sum + (entry['total'] as int));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("$shopName Dashboard"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadEntries,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filter by Barber:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: selectedFilter,
                  onChanged: (value) => applyFilter(value!),
                  items: ["All", "Ramesh", "Suresh", "Anil"]
                      .map((b) => DropdownMenuItem(
                    value: b,
                    child: Text(b),
                  ))
                      .toList(),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Today's Total: ₹${calculateTodayTotal()}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: filteredEntries.isEmpty
                  ? const Center(child: Text("No saved service entries"))
                  : ListView.builder(
                itemCount: filteredEntries.length,
                itemBuilder: (context, index) {
                  var entry = filteredEntries[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                          "${entry['service']} - ₹${entry['total']}"),
                      subtitle: Text(
                          "Barber: ${entry['barber']} | Qty: ${entry['quantity']}"),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddServiceEntryPage(),
                  ),
                );
                loadEntries();
              },
              icon: const Icon(Icons.add),
              label: const Text("Add Service Entry"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.black87,
              ),
              child: const Text(
                "View Reports",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
