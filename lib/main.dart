import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/maintenance/presentation/providers/maintenance_provider.dart';
import 'features/maintenance/presentation/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MaintenanceProvider(),
      child: MaterialApp(
        title: 'Car Maintenance Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
