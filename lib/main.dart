import 'package:fixy/providers/profile_provider.dart';
import 'package:fixy/providers/property_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixy/providers/auth_provider.dart';
import 'package:fixy/routes/fixy_routes.dart';
import 'package:fixy/widgets/google_bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  final profileProvider = ProfileProvider();
  final propertyProvider = PropertyProvider();
  await authProvider.loadAuthState();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<ProfileProvider>.value(value: profileProvider),
        ChangeNotifierProvider<PropertyProvider>.value(value: propertyProvider),
      ],
      child: const Fixy(),
    ),
  );
}

class Fixy extends StatelessWidget {
  const Fixy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fixy',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const GoogleBottomNavBar(),
      routes: routes,
    );
  }
}
