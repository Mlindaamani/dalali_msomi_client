import 'package:fixy/providers/auth_provider.dart';
import 'package:fixy/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

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

        return child;
      },
    );
  }
}




// USAGE
// class WalletScreen extends StatelessWidget {
//   const WalletScreen({super.key}); 

//   @override
//   Widget build(BuildContext context) {
//     return AuthGuard(
//       child: const WalletScreenBody(),
//     );
//   }
// }

