import 'package:fixy/screen/auth/login_screen.dart';
import 'package:fixy/screen/profiles/owner/owner_screen.dart';
import 'package:fixy/screen/profiles/tenants/tenant_screen.dart';
import 'package:flutter/material.dart';
import '../providers/auth_provider.dart';
import 'package:provider/provider.dart';

void navigateBasedOnRole(BuildContext context, String role) {
  Widget screen;

  switch (role) {
    case 'TENANT':
      screen = const TenantScreen();
      break;

    case 'PROPERTY_OWNER':
      screen = const OwnerScreen();
      break;
    default:
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid user role. Logging out...'),
          backgroundColor: Colors.red,
        ),
      );
      Provider.of<AuthProvider>(context, listen: false).logout();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginForm()),
        (route) => false,
      );
      return;
  }

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => screen),
    (route) => false,
  );
}
