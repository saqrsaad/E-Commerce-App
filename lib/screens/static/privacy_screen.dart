import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('سياسة الخصوصية')),
      body: FutureBuilder(
        future: FirestoreService.instance.collection('siteContent').doc('privacy').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'نحن نحمي بياناتك. نجمع فقط البريد الإلكتروني والاسم. لا نشاركها مع طرف ثالث.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final data = snapshot.data!.data() as Map<String, dynamic>;
          return SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title'] ?? 'سياسة الخصوصية', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Text(data['body'] ?? '', style: TextStyle(fontSize: 16)),
              ],
            ),
          );
        },
      ),
    );
  }
}