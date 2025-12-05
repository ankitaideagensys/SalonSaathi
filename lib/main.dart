import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/theme/theme_provider.dart';
import 'app.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}
