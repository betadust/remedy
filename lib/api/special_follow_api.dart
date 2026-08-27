// api/special_follow_api.dart
import 'package:bilibili_api/bilibili_api.dart';

import '../models/special_follow.dart';
import '../utils/retry.dart';

/// 封装哔哩哔哩特别关注相关的网络请求
class SpecialFollowApi {
  final BiliHttpClient _client;
  late final DynamicApi _dynamicApi;

  SpecialFollowApi(this._client) {
    _dynamicApi = DynamicApi(_client);
  }

  /// 获取特别关注列表（tagid=-10 为内置特别关注分组）
  Future<List<SpecialFollow>> getSpecialFollows() async {
    const url = 'https://api.bilibili.com/x/relation/tag';

    final response = await retry(() => _client.get<List<SpecialFollow>>(
          url,
          params: {'tagid': -10, 'ps': 50, 'pn': 1},
          dataParser: (data) {
            final list = data as List? ?? [];
            return list
                .map((e) => SpecialFollow.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        ));

    return response.data ?? [];
  }

  /// 获取关注动态 feed 的一页原始数据
  /// 返回 (items, hasMore, nextOffset)
  Future<(List<Map<String, dynamic>>, bool, String?)> getFollowFeedPage(
      {String? offset}) async {
    final data = await retry(
        () => _dynamicApi.getAllDynamics(type: 'all', offset: offset));
    final items = (data['items'] as List? ?? []).cast<Map<String, dynamic>>();
    final hasMore = (data['has_more'] as bool?) ?? false;
    final nextOffset = data['offset'] as String?;
    return (items, hasMore, nextOffset);
  }
}
