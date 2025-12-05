import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled/presentation/role_admin/screens/dashboard_page.dart';
import '../core/constants/theme/theme_provider.dart';
import 'presentation/auth/login_page.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salon App',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: const LoginPage(),

      routes: {
        "/dashboard": (context) => const DashboardPage(),
        // ✔ One shared dashboard
      },
    );
  }
}