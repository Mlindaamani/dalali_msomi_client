import 'package:fixy/providers/profile_provider.dart';
import 'package:fixy/providers/property_provider.dart';
import 'package:fixy/providers/stepper_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fixy/providers/auth_provider.dart';
import 'package:fixy/routes/fixy_routes.dart';
import 'package:fixy/widgets/google_bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  final stepperProvider = FormStepProvider();
  final profileProvider = ProfileProvider();
  final propertyProvider = PropertyProvider();
  await authProvider.loadAuthState();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<ProfileProvider>.value(value: profileProvider),
        ChangeNotifierProvider<PropertyProvider>.value(value: propertyProvider),
        ChangeNotifierProvider<FormStepProvider>.value(value: stepperProvider),
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
      theme: ThemeData(
        primaryColor: Colors.indigo[600],
        hintColor: Colors.indigoAccent,
        textTheme: GoogleFonts.poppinsTextTheme(),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.indigo[600],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.indigo[600]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.indigoAccent, width: 2),
          ),
          labelStyle: GoogleFonts.poppins(color: Colors.indigo[600]),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      home: GoogleBottomNavBar(),
      routes: routes,
    );
  }
}
