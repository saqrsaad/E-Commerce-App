import 'package:flutter/material.dart';
import '../../services/firestore_service.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('من نحن')),
      body: FutureBuilder(
        future: FirestoreService.instance.collection('siteContent').doc('about').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'متجرنا تأسس عام 2026، نقدم منتجات عالية الجودة بأفضل الأسعار.',
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
                Text(data['title'] ?? 'من نحن', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
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