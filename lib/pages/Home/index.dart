// pages/Home/index.dart
import 'package:flutter/material.dart';
// 未来会导入：providers/ 或 viewmodels/

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 未来：动态列表数据
  // List<DynamicItem> _dynamics = [];

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

// 临时占位组件
class PlaceholderCard extends StatelessWidget {
  final String title;
  const PlaceholderCard({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Color(0xFFFB7299),
          child: const Icon(Icons.person, color: Colors.white),
        ),
        title: Text(title),
        subtitle: const Text('1小时前'),
      ),
    );
  }
}