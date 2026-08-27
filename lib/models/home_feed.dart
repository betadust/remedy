// models/home_feed.dart

enum FeedType { video, text, image }

/// 首页信息流条目（特别关注的动态）
class HomeFeedItem {
  final String dynamicId;
  final int authorMid;
  final String authorName;
  final String authorFace;
  final int pubTs; // 发布时间戳（秒）

  final FeedType type;
  // 视频字段
  final String cover;
  final String title;
  final String durationText;
  final String jumpUrl;
  // 文字字段
  final String text;
  // 图片字段
  final List<String> images;

  HomeFeedItem({
    required this.dynamicId,
    required this.authorMid,
    required this.authorName,
    required this.authorFace,
    required this.pubTs,
    required this.type,
    this.cover = '',
    this.title = '',
    this.durationText = '',
    this.jumpUrl = '',
    this.text = '',
    this.images = const [],
  });

  /// 从动态 feed 的 item 解析，无法识别返回 null（跳过）
  static HomeFeedItem? fromDynamicJson(Map<String, dynamic> item) {
    try {
      final modules = item['modules'] as Map<String, dynamic>?;
      if (modules == null) return null;

      final author = modules['module_author'] as Map<String, dynamic>?;
      final dynamicModule = modules['module_dynamic'] as Map<String, dynamic>?;

      final authorMid = (author?['mid'] as num?)?.toInt();
      final authorName = author?['name'] as String? ?? '';
      final authorFace = author?['face'] as String? ?? '';
      // pub_ts 可能是 int 也可能是 String，需兼容两种类型
      final pubTsRaw = author?['pub_ts'];
      final pubTs = pubTsRaw is num
          ? pubTsRaw.toInt()
          : int.tryParse(pubTsRaw?.toString() ?? '') ?? 0;
      final dynamicId = item['id_str'] as String? ?? '';

      if (authorMid == null) return null;

      final major = dynamicModule?['major'] as Map<String, dynamic>?;

      // 视频动态：major.archive 非空
      final archive = major?['archive'] as Map<String, dynamic>?;
      if (archive != null) {
        return HomeFeedItem(
          dynamicId: dynamicId,
          authorMid: authorMid,
          authorName: authorName,
          authorFace: authorFace,
          pubTs: pubTs,
          type: FeedType.video,
          cover: archive['cover'] as String? ?? '',
          title: archive['title'] as String? ?? '',
          durationText: archive['duration_text'] as String? ?? '',
          jumpUrl: archive['jump_url'] as String? ?? '',
        );
      }

      // 图片动态：major.draw 非空
      final draw = major?['draw'] as Map<String, dynamic>?;
      if (draw != null) {
        final drawItems = draw['items'] as List? ?? [];
        final images = drawItems
            .map((e) => (e as Map<String, dynamic>?)?['src'] as String? ?? '')
            .where((s) => s.isNotEmpty)
            .toList();
        if (images.isNotEmpty) {
          final desc = dynamicModule?['desc'] as Map<String, dynamic>?;
          return HomeFeedItem(
            dynamicId: dynamicId,
            authorMid: authorMid,
            authorName: authorName,
            authorFace: authorFace,
            pubTs: pubTs,
            type: FeedType.image,
            text: desc?['text'] as String? ?? '',
            images: images,
          );
        }
      }

      // 文字动态：module_dynamic.desc.text 非空
      final desc = dynamicModule?['desc'] as Map<String, dynamic>?;
      final text = desc?['text'] as String? ?? '';
      if (text.isNotEmpty) {
        return HomeFeedItem(
          dynamicId: dynamicId,
          authorMid: authorMid,
          authorName: authorName,
          authorFace: authorFace,
          pubTs: pubTs,
          type: FeedType.text,
          text: text,
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}
