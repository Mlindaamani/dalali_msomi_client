import 'package:fixy/providers/auth_provider.dart';
import 'package:fixy/screen/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoleProtectedRoute extends MaterialPageRoute {
  RoleProtectedRoute({
    required WidgetBuilder builder,
    required BuildContext context,
    required String requiredRole,
  }) : super(
         builder: (BuildContext ctx) {
           final auth = Provider.of<AuthProvider>(ctx, listen: false);

           if (auth.user == null) {
             Future.microtask(() {
               Navigator.of(ctx).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (_) => const LoginForm()),
                 (route) => false,
               );
             });
             return const SizedBox.shrink();
           }

           if (auth.user?.role != requiredRole) {
             Future.microtask(() {
               ScaffoldMessenger.of(ctx).showSnackBar(
                 const SnackBar(
                   content: Text('Access denied: unauthorized role'),
                   backgroundColor: Colors.red,
                 ),
               );
               auth.logout();

               Navigator.of(ctx).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (_) => const LoginForm()),
                 (route) => false,
               );
             });
             return const SizedBox.shrink();
           }

           return builder(ctx);
         },
       );
}
