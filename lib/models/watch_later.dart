// models/watch_later.dart

/// 稍后再看视频
class WatchLaterVideo {
  final int aid; // 稿件 avid，跳转主用
  final String bvid; // 可选兜底
  final String title;
  final String cover;
  final String ownerName;

  WatchLaterVideo({
    required this.aid,
    required this.bvid,
    required this.title,
    required this.cover,
    required this.ownerName,
  });

  factory WatchLaterVideo.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'] as Map<String, dynamic>? ?? {};
    return WatchLaterVideo(
      aid: (json['aid'] as num?)?.toInt() ?? 0,
      bvid: json['bvid'] as String? ?? '',
      title: json['title'] as String? ?? '',
      cover: json['pic'] as String? ?? '',
      ownerName: owner['name'] as String? ?? '',
    );
  }
}
