// components/Favorite/FavoriteFolderTile.dart
import 'package:flutter/material.dart';

import '../../models/favorite.dart';
import 'FavoriteVideoCard.dart';

class FavoriteFolderTile extends StatelessWidget {
  final FavoriteFolder folder;
  final List<FavoriteVideo> videos;
  final bool loaded;
  final VoidCallback onExpand;

  const FavoriteFolderTile({
    super.key,
    required this.folder,
    required this.videos,
    required this.loaded,
    required this.onExpand,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        leading: const Icon(Icons.folder_outlined),
        title: Text(folder.title),
        subtitle: Text('${folder.mediaCount} 个视频'),
        onExpansionChanged: (expanded) {
          if (expanded && !loaded) {
            onExpand();
          }
        },
        children: [
          if (!loaded)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (videos.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('该收藏夹暂无视频'),
            )
          else
            // 限制展开区域最大高度，超出部分内部滚动
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 320),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: videos.length,
                itemBuilder: (context, index) =>
                    FavoriteVideoCard(video: videos[index]),
              ),
            ),
        ],
      ),
    );
  }
}
