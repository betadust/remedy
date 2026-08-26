// components/Home/PlaceholderCard.dart
import 'package:flutter/material.dart';

// 临时占位组件
class PlaceholderCard extends StatelessWidget {
  final String title;
  const PlaceholderCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFFFB7299),
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(title),
        subtitle: const Text('1小时前'),
      ),
    );
  }
}
