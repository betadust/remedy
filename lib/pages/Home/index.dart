// pages/Home/index.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/Home/FeedImageCard.dart';
import '../../components/Home/FeedTextCard.dart';
import '../../components/Home/FeedVideoCard.dart';
import '../../models/home_feed.dart';
import '../../stores/user_store.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userStore = context.watch<UserStore>();

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
      body: _buildBody(userStore),
    );
  }

  Widget _buildBody(UserStore userStore) {
    if (!userStore.isLoggedIn) {
      return const Center(child: Text('请先登录'));
    }

    if (userStore.isLoadingHomeFeed) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userStore.homeFeed.isEmpty) {
      return const Center(child: Text('暂无特别关注动态'));
    }

    final videos =
        userStore.homeFeed.where((e) => e.type == FeedType.video).toList();
    final posts = userStore.homeFeed
        .where((e) => e.type == FeedType.text || e.type == FeedType.image)
        .toList();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: '视频'),
              Tab(text: '动态'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildList(videos, '暂无视频动态'),
                _buildList(posts, '暂无动态'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<HomeFeedItem> items, String emptyText) {
    if (items.isEmpty) {
      return Center(child: Text(emptyText));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        switch (item.type) {
          case FeedType.video:
            return FeedVideoCard(item: item);
          case FeedType.text:
            return FeedTextCard(item: item);
          case FeedType.image:
            return FeedImageCard(item: item);
        }
      },
    );
  }
}
