import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'static/about_screen.dart';
import 'static/privacy_screen.dart';
import 'static/terms_screen.dart';
import 'static/contact_screen.dart';
import 'static/sell_with_us_screen.dart';
import '../widgets/app_header.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            searchController: TextEditingController(),
            onSearchChanged: (_) {},
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildListTile(context, 'من نحن', Icons.info_outline, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()));
                }),
                _buildListTile(context, 'اتصل بنا', Icons.phone_outlined, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactScreen()));
                }),
                _buildListTile(context, 'سياسة الخصوصية', Icons.lock_outline, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyScreen()));
                }),
                _buildListTile(context, 'الشروط والأحكام', Icons.description_outlined, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsScreen()));
                }),
                _buildListTile(context, 'تسوق معنا', Icons.storefront_outlined, () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SellWithUsScreen()));
                }),
                if (auth.user != null)
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('تسجيل الخروج'),
                    onTap: () async {
                      await auth.signOut();
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF6A11CB)),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}