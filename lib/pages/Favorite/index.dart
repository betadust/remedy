// pages/Favorite/index.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/Favorite/FavoriteFolderTile.dart';
import '../../components/Favorite/FavoriteVideoCard.dart';
import '../../components/Favorite/WatchLaterBanner.dart';
import '../../components/Favorite/WatchLaterVideoCard.dart';
import '../../stores/user_store.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

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
                  _buildWatchLaterTab(context),
                  _buildFavoriteTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWatchLaterTab(BuildContext context) {
    final userStore = context.watch<UserStore>();

    if (!userStore.isLoggedIn) {
      return const Center(child: Text('请先登录'));
    }

    if (userStore.isLoadingWatchLater) {
      return const Center(child: CircularProgressIndicator());
    }

    if (userStore.watchLaterVideos.isEmpty) {
      return const Center(child: Text('暂无稍后再看视频'));
    }

    return Column(
      children: [
        const WatchLaterBanner(),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 170,
            ),
            itemCount: userStore.watchLaterVideos.length,
            itemBuilder: (context, index) {
              return WatchLaterVideoCard(video: userStore.watchLaterVideos[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteTab(BuildContext context) {
    final userStore = context.watch<UserStore>();

    if (!userStore.isLoggedIn) {
      return const Center(child: Text('请先登录'));
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // 上半部分：公开收藏夹
        if (userStore.isLoadingFolders)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (userStore.folders.isEmpty)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('暂无公开收藏夹')),
          )
        else
          ...userStore.folders.map((folder) {
            final videos = userStore.folderVideos[folder.id] ?? [];
            return FavoriteFolderTile(
              folder: folder,
              videos: videos,
              loaded: userStore.folderVideos.containsKey(folder.id),
              onExpand: () => userStore.loadFolderVideos(folder.id),
            );
          }),

        const SizedBox(height: 16),

        // 下半部分：今日推荐
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Text(
            '今日推荐',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        if (userStore.isLoadingToday)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (userStore.todayVideo == null)
          const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('暂无收藏视频')),
          )
        else
          FavoriteVideoCard(video: userStore.todayVideo!),
      ],
    );
  }
}
