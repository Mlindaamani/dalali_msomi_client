import 'package:fixy/providers/auth_provider.dart';
import 'package:fixy/routes/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Role Based App',
      onGenerateRoute: (settings) =>
          RouteGenerator.generateRoute(settings, context),
      initialRoute: '/',
    );
  }
}
