// components/Home/FeedVideoCard.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/home_feed.dart';

/// 首页视频动态卡片：封面 + 标题 + UP主 + 时长
class FeedVideoCard extends StatelessWidget {
  final HomeFeedItem item;
  const FeedVideoCard({super.key, required this.item});

  Future<void> _open() async {
    if (item.jumpUrl.isNotEmpty) {
      final url = Uri.parse(item.jumpUrl);
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _open,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面（16:9）+ 时长角标
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: item.cover.isEmpty
                      ? Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.video_library_outlined),
                        )
                      : Image.network(
                          item.cover,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.video_library_outlined),
                          ),
                        ),
                ),
                if (item.durationText.isNotEmpty)
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        item.durationText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: item.authorFace.isNotEmpty
                            ? NetworkImage(item.authorFace)
                            : null,
                        child: item.authorFace.isEmpty
                            ? const Icon(Icons.person, size: 14)
                            : null,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.authorName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
