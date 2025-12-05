import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'add_services_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EditServicesPage extends StatefulWidget {
  const EditServicesPage({super.key});

  @override
  State<EditServicesPage> createState() => _EditServicesPageState();
}

class _EditServicesPageState extends State<EditServicesPage> {
  List<dynamic> services = [];
  bool isLoading = true;
  String? errorMessage;

  final String baseUrl = "http://10.0.2.2:8082/api/shop/services";

  @override
  void initState() {
    super.initState();
    _fetchServices();
  }

  Future<void> _fetchServices() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final shopId = prefs.getInt("selectedShopId");

      final url = Uri.parse("$baseUrl/shop/$shopId");
      final res = await http.get(url, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      if (res.statusCode == 200) {
        setState(() {
          services = jsonDecode(res.body);
          isLoading = false;
        });
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _deleteService(int serviceId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      final url = Uri.parse("$baseUrl/$serviceId");

      final res = await http.delete(url, headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      });

      if (res.statusCode != 200) throw Exception("Delete failed");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting service: $e")),
      );
    }
  }

  Future<void> _addService() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddServicesPage()),
    );

    if (result == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");
      final shopId = prefs.getInt("selectedShopId");

      final url = Uri.parse("$baseUrl/add");

      final body = jsonEncode({
        "shopId": shopId,
        "name": result["name"],
        "price": double.parse(result["price"]),
        "description": result["description"],
        "iconUrl": result["iconUrl"],
        "estimatedDuration": result["duration"] ?? 30,
      });

      final res = await http.post(url,
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
          body: body);

      if (res.statusCode == 200) {
        setState(() => services.add(jsonDecode(res.body)));
      } else {
        throw Exception(res.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error adding service: $e")));
    }
  }

  Widget buildIcon(String? iconUrl, Color? iconColor) {
    if (iconUrl == null || iconUrl.isEmpty) {
      return Icon(Icons.miscellaneous_services, size: 24, color: iconColor);
    }

    if (iconUrl.startsWith("http")) {
      return Image.network(
        iconUrl,
        width: 26,
        height: 26,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.miscellaneous_services, size: 24, color: iconColor),
      );
    }

    if (iconUrl.endsWith(".svg")) {
      return SvgPicture.asset(
        "assets/icons/$iconUrl",
        width: 26,
        height: 26,
        colorFilter: ColorFilter.mode(iconColor!, BlendMode.srcIn),
      );
    }

    return Image.asset(
      "assets/icons/$iconUrl",
      width: 26,
      height: 26,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.miscellaneous_services, size: 24, color: iconColor),
    );
  }

  Widget _serviceTile(dynamic s, ThemeData theme) {
    final textColor = theme.textTheme.bodyMedium!.color;
    final borderColor = theme.dividerColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.white10
                : Colors.black12,
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          buildIcon(s["iconUrl"], textColor),
          const SizedBox(width: 15),

          Expanded(
            child: Text(
              s["name"] ?? "",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: textColor,
              ),
            ),
          ),

          Text(
            "Rs${s["price"]?.toStringAsFixed(0)}",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium!.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Edit Services",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  for (var s in services)
                    Dismissible(
                      key: ValueKey(s["id"]),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete,
                            color: Colors.white, size: 30),
                      ),
                      onDismissed: (_) async {
                        await _deleteService(s["id"]);
                        setState(() => services.remove(s));
                      },
                      child: _serviceTile(s, theme),
                    ),

                  const SizedBox(height: 20),

                  Center(
                    child: SizedBox(
                      width: 150,
                      height: 42,
                      child: ElevatedButton(
                        onPressed: _addService,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF322A59),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Add Services",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
