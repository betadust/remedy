// pages/Favorite/index.dart
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  // 未来：从 stores/ 或 viewmodels/ 读取数据
  final List<String> _watchLaterList = ['视频1', '视频2', '视频3'];
  final List<String> _favoriteList = ['收藏视频A', '收藏视频B'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('收藏'),
        backgroundColor: Color(0xFFFB8FAF),
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: const [
                Tab(text: '稍后再看'),
                Tab(text: '收藏'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(_watchLaterList, '暂无稍后再看'),
                  _buildList(_favoriteList, '暂无收藏'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<String> items, String emptyText) {
    if (items.isEmpty) {
      return Center(child: Text(emptyText));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.video_library_outlined),
            title: Text(items[index]),
            trailing: const Icon(Icons.more_vert),
          ),
        );
      },
    );
  }
}