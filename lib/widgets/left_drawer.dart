import 'package:all_things_athletic_mobile/home.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import '../features/artikel/screens/article_page.dart';
import '../features/auth/screens/login.dart';
import '../features/auth/user.dart';
import '../features/rate_product/screens/rating_page.dart';
import '../features/review_product/screens/review_page.dart';

class LeftDrawer extends StatelessWidget {
  const LeftDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xffadba5e),
            ),
            child: Column(
              children: [
                Text(
                  'All Things Athletic',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                ),
                Text(
                  "Empower Your Performance, Fuel Your Spirit",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.shop_2),
            title: const Text('Daftar Katalog'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.reviews),
            title: const Text('Daftar Review'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ReviewPage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.rate_review),
            title: const Text('Daftar Rating'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RatingListPage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text('Daftar Artikel'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ArticlePage()),
            ),
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              final response = await request.logout("http://localhost:8000/auth/logout/");

              if (response["message"] == 'Logout berhasil!') {
                User.userId = -1;
                
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
