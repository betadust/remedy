// components/Favorite/FavoriteVideoCard.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_colors.dart';
import '../../models/favorite.dart';

class FavoriteVideoCard extends StatelessWidget {
  final FavoriteVideo video;
  const FavoriteVideoCard({super.key, required this.video});

  Future<void> _openVideo() async {
    if (video.bvid.isEmpty) return;
    final url = Uri.parse('https://www.bilibili.com/video/${video.bvid}');
    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _openVideo,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 封面
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  width: 96,
                  height: 60,
                  child: video.cover.isEmpty
                      ? Container(
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.video_library_outlined),
                        )
                      : Image.network(
                          video.cover,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.video_library_outlined),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // 标题 + UP主
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video.upperName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
