// components/Favorite/WatchLaterVideoCard.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/watch_later.dart';

/// 竖版视频卡片（两列网格用）：封面在上、标题在下
class WatchLaterVideoCard extends StatelessWidget {
  final WatchLaterVideo video;
  const WatchLaterVideoCard({super.key, required this.video});

  Future<void> _openVideo() async {
    final id = video.bvid.isNotEmpty ? video.bvid : 'av${video.aid}';
    if (video.bvid.isEmpty && video.aid == 0) return;
    final url = Uri.parse('https://www.bilibili.com/video/$id');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: _openVideo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 封面：自适应剩余高度，避免固定比例 + 文字区撑爆格子
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: video.cover.isEmpty
                    ? Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.video_library_outlined),
                      )
                    : Image.network(
                        video.cover,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.video_library_outlined),
                        ),
                      ),
              ),
            ),
            // 标题 + UP主（固定高度，保证各卡片文字行数一致）
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 34,
                    child: Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 15,
                    child: Text(
                      video.ownerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.3,
                        color: Colors.grey.shade600,
                      ),
                    ),
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
