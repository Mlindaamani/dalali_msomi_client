import 'package:fixy/widgets/profile_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixy/providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFF4F46E5);
    const redAccent = Colors.redAccent;

    final auth = Provider.of<AuthProvider>(context);
    final profilePictureUrl = auth.user?.profilePicture;
    final userName = auth.user?.firstName ?? 'Guest';
    final userEmail = auth.user?.email ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.white,
            expandedHeight: 140,
            pinned: true,
            elevation: 1,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.indigo.shade100,
                          backgroundImage: profilePictureUrl != null
                              ? NetworkImage(
                                  profilePictureUrl,
                                  headers: {
                                    'ngrok-skip-browser-warning': 'true',
                                  },
                                )
                              : null,
                          child: profilePictureUrl == null
                              ? const Icon(
                                  Icons.person,
                                  size: 30,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () => showEditPictureSheet(
                              context,
                              profilePictureUrl,
                            ),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.edit,
                                size: 24,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Welcome back,',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: brandColor,
                          ),
                        ),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _buildNavItem(
                    Icons.attach_money,
                    'My Earnings',
                    onTap: () {
                      Navigator.pushNamed(context, '/earnings');
                    },
                  ),
                  _buildNavItem(
                    Icons.assignment_turned_in,
                    'Contracts',
                    onTap: () {
                      Navigator.pushNamed(context, '/contracts');
                    },
                  ),
                  _buildNavItem(
                    Icons.qr_code,
                    'My QR Codes',
                    onTap: () {
                      Navigator.pushNamed(context, '/qr-codes');
                    },
                  ),
                  _buildNavItem(
                    Icons.home_work,
                    'My Properties',
                    onTap: () {
                      Navigator.pushNamed(context, '/properties');
                    },
                  ),
                  _buildNavItem(
                    Icons.privacy_tip,
                    'Privacy and Policy',
                    onTap: () {
                      Navigator.pushNamed(context, '/privacy-policy');
                    },
                  ),
                  _buildNavItem(
                    Icons.security,
                    'Insurance',
                    onTap: () {
                      Navigator.pushNamed(context, '/insurance');
                    },
                  ),
                  _buildNavItem(
                    Icons.help_outline,
                    'Help Center',
                    onTap: () {
                      Navigator.pushNamed(context, '/help-center');
                    },
                  ),
                  _buildNavItem(
                    Icons.settings,
                    'Settings',
                    onTap: () {
                      Navigator.pushNamed(context, '/stepper');
                    },
                  ),
                  const SizedBox(height: 16),

                  ListTile(
                    onTap: () {
                      auth.logout();
                      Navigator.pushNamed(context, '/login');
                    },
                    contentPadding: const EdgeInsets.only(left: 8),
                    leading: const Icon(Icons.logout, color: redAccent),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        color: redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: redAccent,
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {Function()? onTap}) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.only(left: 4),
      leading: Icon(icon, color: Colors.indigo),
      title: Text(label),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.indigo,
      ),
    );
  }
}
