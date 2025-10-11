import 'package:flutter/material.dart';

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
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedBarber,
              onChanged: (String? newValue) {
                setState(() {
                  selectedBarber = newValue!;
                });
              },
              items: ['Ramesh', 'Suresh', 'Anil']
                  .map<DropdownMenuItem<String>>(
                      (barber) => DropdownMenuItem<String>(
                    value: barber,
                    child: Text(barber),
                  ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text("Select Service"),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedService,
              onChanged: (String? newValue) {
                setState(() {
                  selectedService = newValue!;
                });
              },
              items: ['Haircut', 'Shave', 'Beard Trim']
                  .map<DropdownMenuItem<String>>(
                      (service) => DropdownMenuItem<String>(
                    value: service,
                    child: Text(service),
                  ))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text("Quantity"),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text(quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text("Total: ₹$total", style: const TextStyle(fontSize: 18)),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle saving logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
