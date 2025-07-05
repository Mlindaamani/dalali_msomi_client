import 'package:fixy/screen/auth/login_screen.dart';
import 'package:fixy/screen/auth/register_screen.dart';
import 'package:flutter/material.dart';

final Map<String, WidgetBuilder> routes = {
  '/login': (context) => const LoginForm(),
  '/register': (context) => const RegistrationScreen(),
  // Add a not-found route
  '/not-found': (context) => Scaffold(
    body: Center(
      child: Text(
        'Page not found',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    ),
  ),
};
