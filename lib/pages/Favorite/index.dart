// pages/Favorite/index.dart
import 'package:flutter/material.dart';

import '../../components/Favorite/FavoriteItemCard.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  // 占位数据，未来从 stores/ 读取
  static const List<String> _watchLaterList = ['视频1', '视频2', '视频3'];
  static const List<String> _favoriteList = ['收藏视频A', '收藏视频B'];

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
            const TabBar(
              tabs: [
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
        return FavoriteItemCard(title: items[index]);
      },
    );
  }
}
