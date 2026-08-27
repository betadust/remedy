// api/watch_later_api.dart
import 'package:bilibili_api/bilibili_api.dart';

import '../models/watch_later.dart';
import '../utils/retry.dart';

/// 封装哔哩哔哩稍后再看相关的网络请求
class WatchLaterApi {
  final BiliHttpClient _client;

  WatchLaterApi(this._client);

  /// 获取稍后再看视频列表（最多 100 个）
  Future<List<WatchLaterVideo>> getWatchLater() async {
    const url = 'https://api.bilibili.com/x/v2/history/toview';

    final response = await retry(() => _client.get<List<WatchLaterVideo>>(
          url,
          dataParser: (data) {
            final list = (data as Map<String, dynamic>)['list'] as List? ?? [];
            return list
                .map((e) => WatchLaterVideo.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        ));

    return response.data ?? [];
  }
}
