// components/Home/FeedImageCard.dart
import 'package:flutter/material.dart';

import '../../models/home_feed.dart';

/// 首页图片动态卡片：UP主头像昵称 + 图片网格 + 文字
class FeedImageCard extends StatelessWidget {
  final HomeFeedItem item;
  const FeedImageCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // UP主头像昵称
            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: item.authorFace.isNotEmpty
                      ? NetworkImage(item.authorFace)
                      : null,
                  child: item.authorFace.isEmpty
                      ? const Icon(Icons.person, size: 18)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    item.authorName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // 图片网格
            _buildImageGrid(),
            // 文字
            if (item.text.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                item.text,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    final images = item.images;
    if (images.length == 1) {
      // 单图：16:9 展示
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: _image(images.first),
        ),
      );
    }
    // 多图：3 列九宫格
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemCount: images.length > 9 ? 9 : images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: _image(images[index]),
        );
      },
    );
  }

  Widget _image(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.broken_image_outlined),
      ),
    );
  }
}
