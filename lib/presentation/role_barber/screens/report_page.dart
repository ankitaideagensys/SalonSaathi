import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  List<Map<String, dynamic>> entries = [];
  int totalEarnings = 0;
  int todayEarnings = 0;
  Map<String, int> barberTotals = {};
  String shopName = '';

  @override
  void initState() {
    super.initState();
    loadReportData();
  }

  Future<void> loadReportData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedEntries = prefs.getStringList('service_entries') ?? [];

    String? name = prefs.getString('shop_name') ?? 'My Shop';

    List<Map<String, dynamic>> parsedEntries = [];
    int total = 0;
    int todayTotal = 0;
    Map<String, int> barberMap = {};

    DateTime now = DateTime.now();

    for (String e in savedEntries) {
      try {
        Map<String, dynamic> entry = jsonDecode(e);
        parsedEntries.add(entry);
        int entryTotal = entry['total'] as int;

        total += entryTotal;
        barberMap[entry['barber']] =
            (barberMap[entry['barber']] ?? 0) + entryTotal;

        // Check if entry is from today
        DateTime entryDate = DateTime.parse(entry['date']);
        if (entryDate.year == now.year &&
            entryDate.month == now.month &&
            entryDate.day == now.day) {
          todayTotal += entryTotal;
        }
      } catch (_) {}
    }

    setState(() {
      shopName = name;
      entries = parsedEntries;
      totalEarnings = total;
      todayEarnings = todayTotal;
      barberTotals = barberMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$shopName Reports'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shop name and today’s summary
            Text(
              "Shop: $shopName",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              "Today's Earnings: ₹$todayEarnings",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const SizedBox(height: 6),
            Text(
              "Total Earnings: ₹$totalEarnings",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const Divider(height: 30, thickness: 1),

            const Text(
              "Earnings by Barber:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            barberTotals.isEmpty
                ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("No barber data available"),
            )
                : Column(
              children: barberTotals.entries
                  .map(
                    (e) => ListTile(
                  title: Text(e.key),
                  trailing: Text(
                    "₹${e.value}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black87),
                  ),
                ),
              )
                  .toList(),
            ),

            const Divider(height: 30, thickness: 1),
            const Text(
              "All Entries:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),

            Expanded(
              child: entries.isEmpty
                  ? const Center(child: Text("No entries found"))
                  : ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(
                          "${entry['barber']} - ${entry['service']}"),
                      subtitle: Text(
                          "Qty: ${entry['quantity']} • ₹${entry['total']}"),
                      trailing: Text(
                        entry['date']
                            .toString()
                            .substring(0, 16)
                            .replaceFirst('T', ' '),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
