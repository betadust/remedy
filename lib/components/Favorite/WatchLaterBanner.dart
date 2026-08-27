// components/Favorite/WatchLaterBanner.dart
import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

/// 稍后再看顶部的随机提醒文案
class WatchLaterBanner extends StatefulWidget {
  const WatchLaterBanner({super.key});

  @override
  State<WatchLaterBanner> createState() => _WatchLaterBannerState();
}

class _WatchLaterBannerState extends State<WatchLaterBanner> {
  static const List<String> _messages = [
    '今天推荐的稍后再看视频，别忘了看哦～',
    '攒了这么多稍后再看，今天挑几部看看吧',
    '别让稍后再看一直吃灰，抽空看一部吧',
    '今天随机抽几部稍后再看，重温一下吧',
    '你还有稍后再看没清空，今天安排一部？',
  ];

  late final String _message;

  @override
  void initState() {
    super.initState();
    _message = _messages[Random().nextInt(_messages.length)];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.biliPinkLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.schedule, size: 18, color: AppColors.biliPink),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _message,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.biliPink,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
