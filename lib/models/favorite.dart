// models/favorite.dart

/// 收藏夹
class FavoriteFolder {
  final int id; // mlid，用作后续 media_id
  final String title;
  final int mediaCount;
  final bool isPublic;

  FavoriteFolder({
    required this.id,
    required this.title,
    required this.mediaCount,
    required this.isPublic,
  });

  factory FavoriteFolder.fromJson(Map<String, dynamic> json) {
    final attr = (json['attr'] as num?)?.toInt() ?? 0;
    return FavoriteFolder(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      mediaCount: (json['media_count'] as num?)?.toInt() ?? 0,
      isPublic: (attr & 1) == 0, // bit0: 0=公开 1=私有
    );
  }
}

/// 收藏夹内的视频
class FavoriteVideo {
  final String bvid;
  final String title;
  final String cover;
  final String upperName;
  final int upperMid;

  FavoriteVideo({
    required this.bvid,
    required this.title,
    required this.cover,
    required this.upperName,
    required this.upperMid,
  });

  factory FavoriteVideo.fromJson(Map<String, dynamic> json) {
    final upper = json['upper'] as Map<String, dynamic>? ?? {};
    return FavoriteVideo(
      bvid: json['bvid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      cover: json['cover'] as String? ?? '',
      upperName: upper['name'] as String? ?? '',
      upperMid: (upper['mid'] as num?)?.toInt() ?? 0,
    );
  }
}
