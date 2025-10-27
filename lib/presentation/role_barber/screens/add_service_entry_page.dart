import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AddServiceEntryPage extends StatefulWidget {
  const AddServiceEntryPage({super.key});

  @override
  State<AddServiceEntryPage> createState() => _AddServiceEntryPageState();
}

class _AddServiceEntryPageState extends State<AddServiceEntryPage> {
  String selectedBarber = 'Ramesh';
  String selectedService = 'Haircut';
  int quantity = 1;
  int pricePerService = 100;

  Future<void> saveEntry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? shopName = prefs.getString('shop_name');
    List<String> savedEntries = prefs.getStringList('service_entries') ?? [];
    List<Map<String, dynamic>> decodedEntries =
    savedEntries.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();

    int total = quantity * pricePerService;

    // Check for duplicate entry (same barber + service)
    int existingIndex = decodedEntries.indexWhere((e) =>
    e['barber'] == selectedBarber && e['service'] == selectedService);

    if (existingIndex != -1) {
      // Update existing entry
      decodedEntries[existingIndex]['quantity'] += quantity;
      decodedEntries[existingIndex]['total'] += total;
      decodedEntries[existingIndex]['date'] = DateTime.now().toString();
    } else {
      // Add new entry
      decodedEntries.add({
        'barber': selectedBarber,
        'service': selectedService,
        'quantity': quantity,
        'price': pricePerService,
        'total': total,
        'date': DateTime.now().toString(),
        'shop': shopName,
      });
    }

    // Save back to SharedPreferences
    List<String> updatedList =
    decodedEntries.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('service_entries', updatedList);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Service entry saved successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    int total = quantity * pricePerService;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Service Entry'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Select Barber"),
            DropdownButton<String>(
              value: selectedBarber,
              onChanged: (String? newValue) {
                setState(() => selectedBarber = newValue!);
              },
              items: ['Ramesh', 'Suresh', 'Anil']
                  .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text("Select Service"),
            DropdownButton<String>(
              value: selectedService,
              onChanged: (String? newValue) {
                setState(() => selectedService = newValue!);
              },
              items: ['Haircut', 'Shave', 'Beard Trim']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text("Quantity"),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) setState(() => quantity--);
                  },
                ),
                Text(quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => setState(() => quantity++),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Total: ₹$total", style: const TextStyle(fontSize: 18)),
            const Spacer(),
            ElevatedButton(
              onPressed: saveEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Save Entry"),
            ),
          ],
        ),
      ),
    );
  }
}
