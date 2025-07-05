import 'package:fixy/providers/auth_provider.dart';
import 'package:fixy/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoleGuard extends StatelessWidget {
  final String requiredRole;
  final Widget child;

  const RoleGuard({super.key, required this.requiredRole, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (_, auth, __) {
        if (auth.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (auth.user == null) {
          Future.microtask(() {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginForm()),
              (route) => false,
            );
          });
          return const SizedBox.shrink();
        }

        if (auth.user?.role != requiredRole) {
          Future.microtask(() {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Access denied: wrong role'),
                backgroundColor: Colors.red,
              ),
            );
            auth.logout();

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginForm()),
              (route) => false,
            );
          });
          return const SizedBox.shrink();
        }

        return child;
      },
    );
  }
}

// USAGE
//Only the user with the 'BROKER' role can access this screen

// class BrokerScreen extends StatelessWidget {
//   const BrokerScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return RoleGuard(
//       requiredRole: 'BROKER',
//       child: const BrokerScreen(),
//     );
//   }
// }
