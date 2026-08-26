// pages/Home/index.dart
import 'package:flutter/material.dart';

import '../../components/Home/PlaceholderCard.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('首页'),
        backgroundColor: Color(0xFFFB8FAF),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: 跳转通知列表
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: const [
          // 占位：动态卡片
          PlaceholderCard(title: 'UP主更新了视频'),
          PlaceholderCard(title: '你的特别关注有新动态'),
          PlaceholderCard(title: '直播预告：今晚8点'),
        ],
      ),
    );
  }
}
