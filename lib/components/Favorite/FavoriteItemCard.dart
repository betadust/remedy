// components/Favorite/FavoriteItemCard.dart
import 'package:flutter/material.dart';

class FavoriteItemCard extends StatelessWidget {
  final String title;
  const FavoriteItemCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.video_library_outlined),
        title: Text(title),
        trailing: const Icon(Icons.more_vert),
      ),
    );
  }
}
