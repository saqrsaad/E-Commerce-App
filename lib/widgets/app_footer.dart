import 'package:e_commerce_app/screens/static/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/static/about_screen.dart';
import '../screens/static/privacy_screen.dart';
// import '../screens/static/terms_screen.dart';
// import '../screens/static/contact_screen.dart';
// import '../screens/static/sell_with_us_screen.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF5F5F5),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Three horizontal sections
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shop with us section
              Expanded(
                child: _FooterSection(
                  title: 'تسوق معنا',
                  children: [
                    _FooterLink('جميع المنتجات', onTap: () {}),
                    _FooterLink('العروض', onTap: () {}),
                    _FooterLink('الأكثر مبيعًا', onTap: () {}),
                  ],
                ),
              ),

              // About us section
              Expanded(
                child: _FooterSection(
                  title: 'من نحن',
                  children: [
                    _FooterLink('قصة المتجر', onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AboutScreen()),
                      );
                    }),
                  ],
                ),
              ),

              // Contact us section
              Expanded(
                child: _FooterSection(
                  title: 'تواصل معنا',
                  children: [
                    Text(
                      'info@example.com',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '+966 123 456 789',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
          Divider(),
          SizedBox(height: 8),

          // Privacy policy and terms links
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PrivacyScreen()),
                ),
                child: Text(
                  'سياسة الخصوصية',
                  style: TextStyle(fontSize: 12),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => TermsScreen()),
                ),
                child: Text(
                  'الشروط والأحكام',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),

          // Copyright text
          Text(
            '© 2026 متجري. جميع الحقوق محفوظة.',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _FooterSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 8),
        ...children,
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink(
    this.text, {
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}