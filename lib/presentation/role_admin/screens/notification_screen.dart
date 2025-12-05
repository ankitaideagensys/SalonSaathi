import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_page.dart';
import 'package:untitled/presentation/role_admin/screens/pick_shop_location_page.dart';
import 'package:untitled/presentation/role_admin/screens/settings_page.dart';
import '../../role_barber/screens/add_barbers_services_page.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const String baseUrl = "http://10.0.2.2:8087/api/notifications";

  bool isLoading = true;
  List<dynamic> notifications = [];

  String? _token;
  int? _userId;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case "BARBER":
        return Icons.person_add_alt_1;
      case "REPORT":
        return Icons.insert_chart_outlined;
      case "SCHEDULE":
        return Icons.schedule;
      case "PAYMENT":
        return Icons.currency_rupee;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  String _getGroupLabel(DateTime date) {
    final now = DateTime.now();
    final diffDays = now.difference(date).inDays;

    if (diffDays == 0) return "Today";
    if (diffDays == 1) return "Yesterday";
    return "Earlier";
  }

  Future<void> fetchNotifications() async {
    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();

    final String? token = prefs.getString("token");
    final int? userId = prefs.getInt("userId");

    _token = token;
    _userId = userId;

    if (token == null || userId == null) {
      setState(() => isLoading = false);
      return;
    }

    final Uri url = Uri.parse("$baseUrl/user/$userId?page=0&size=50");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          notifications = (data["content"] ?? []) as List<dynamic>;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _markAllRead() async {
    if (_token == null || _userId == null) return;

    try {
      final url = Uri.parse("$baseUrl/user/${_userId}/read-all");
      await http.put(
        url,
        headers: {"Authorization": "Bearer $_token"},
      );
      await fetchNotifications();
    } catch (e) {
      debugPrint("markAllRead error: $e");
    }
  }

  Future<void> _markAsRead(dynamic item) async {
    if (_token == null) return;
    if (item["readStatus"] == true) return;

    try {
      final url = Uri.parse("$baseUrl/${item["id"]}/read");
      await http.put(
        url,
        headers: {"Authorization": "Bearer $_token"},
      );
      setState(() {
        item["readStatus"] = true;
      });
    } catch (e) {
      debugPrint("markAsRead error: $e");
    }
  }

  Future<void> _deleteNotification(dynamic item) async {
    if (_token == null) return;

    try {
      final url = Uri.parse("$baseUrl/${item["id"]}");
      await http.delete(
        url,
        headers: {"Authorization": "Bearer $_token"},
      );
      setState(() {
        notifications.removeWhere((n) => n["id"] == item["id"]);
      });
    } catch (e) {
      debugPrint("deleteNotification error: $e");
    }
  }

  // ---------------- CARD ----------------
  Widget _buildNotificationCard(BuildContext context, dynamic item) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium!.color;

    final createdAtString = item["createdAt"] as String?;
    DateTime createdAt;
    try {
      createdAt = createdAtString != null
          ? DateTime.parse(createdAtString)
          : DateTime.now();
    } catch (_) {
      createdAt = DateTime.now();
    }

    final bool isUnread = !(item["readStatus"] == true);

    return Dismissible(
      key: Key(item["id"].toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        _deleteNotification(item);
      },
      child: GestureDetector(
        onTap: () {
          _markAsRead(item);
          // TODO: handle navigation using targetUrl if needed
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isUnread
                ? theme.colorScheme.secondary.withOpacity(0.15)
                : theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.08),
                blurRadius: 8,
                spreadRadius: 1,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar or type icon
              (item["avatarUrl"] != null &&
                  (item["avatarUrl"] as String).isNotEmpty)
                  ? CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(item["avatarUrl"]),
              )
                  : CircleAvatar(
                radius: 22,
                backgroundColor: theme.cardColor,
                child: Icon(
                  _getIcon(item["type"] as String?),
                  color: textColor!.withOpacity(0.7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + timeAgo row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item['title'] ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item["timeAgo"] ?? "",
                          style: TextStyle(
                            fontSize: 11.5,
                            color: textColor!.withOpacity(0.45),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    if (item["subtitle"] != null)
                      Text(
                        item["subtitle"],
                        style: TextStyle(
                          fontSize: 13,
                          color: textColor!.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (item["subtitle"] != null) const SizedBox(height: 4),

                    Text(
                      item['message'] ?? "",
                      style: TextStyle(
                        fontSize: 13.5,
                        color: textColor!.withOpacity(0.85),
                      ),
                    ),
                  ],
                ),
              ),

              if (isUnread)
                Container(
                  margin: const EdgeInsets.only(left: 6, top: 4),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF3D00),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- GROUPED LIST ----------------
  Widget _buildGroupedList(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium!.color;

    if (notifications.isEmpty) {
      return Center(
        child: Text(
          "No notifications yet",
          style: TextStyle(color: textColor!.withOpacity(0.6)),
        ),
      );
    }

    final Map<String, List<dynamic>> grouped = {};

    for (var n in notifications) {
      final createdAtString = n["createdAt"] as String?;
      DateTime createdAt;
      try {
        createdAt = createdAtString != null
            ? DateTime.parse(createdAtString)
            : DateTime.now();
      } catch (_) {
        createdAt = DateTime.now();
      }
      final label = _getGroupLabel(createdAt);
      grouped.putIfAbsent(label, () => []).add(n);
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: grouped.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 12, top: 8),
              child: Text(
                entry.key,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            ...entry.value
                .map((n) => _buildNotificationCard(context, n))
                .toList(),
          ],
        );
      }).toList(),
    );
  }

  // ---------------- BUILD ----------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyMedium!.color;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Notification',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 23,
          ),
        ),
        actions: [
          IconButton(
            tooltip: "Mark all as read",
            icon: Icon(
              Icons.done_all_rounded,
              color: textColor,
              size: 22,
            ),
            onPressed: _markAllRead,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            if (isLoading)
              Expanded(
                child: Center(
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.primary,
                  ),
                ),
              )
            else
              Expanded(child: _buildGroupedList(context)),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: theme.scaffoldBackgroundColor,
        currentIndex: 0,
        selectedItemColor: textColor!.withOpacity(0.9),
        unselectedItemColor: textColor.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const DashboardPage(),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AddBarbersServicesPage(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PickShopLocationPage(),
              ),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              ),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_rounded),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: '',
          ),
        ],
      ),
    );
  }
}
