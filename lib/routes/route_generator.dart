import 'package:fixy/providers/auth_provider.dart';
import 'package:fixy/routes/role_protected_route.dart';
import 'package:fixy/screen/auth/login_screen.dart';
import 'package:fixy/screen/profiles/owner/owner_screen.dart';
import 'package:fixy/screen/profiles/tenants/tenant_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(
    RouteSettings settings,
    BuildContext context,
  ) {
    Provider.of<AuthProvider>(context, listen: false);

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginForm());

      case '/tenant':
        return RoleProtectedRoute(
          builder: (_) => const TenantScreen(),
          context: context,
          requiredRole: 'TENANT',
        );

      case '/owner':
        return RoleProtectedRoute(
          builder: (_) => const OwnerScreen(),
          context: context,
          requiredRole: 'PROPERTY_OWNER',
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
