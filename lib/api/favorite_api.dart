// api/favorite_api.dart
import 'package:bilibili_api/bilibili_api.dart';

import '../models/favorite.dart';
import '../utils/retry.dart';

/// 封装哔哩哔哩收藏夹相关的网络请求
class FavoriteApi {
  final BiliHttpClient _client;

  FavoriteApi(this._client);

  /// 获取用户创建的所有收藏夹（含私有，调用方自行过滤公开）
  Future<List<FavoriteFolder>> getFavoriteFolders(int mid) async {
    const url = 'https://api.bilibili.com/x/v3/fav/folder/created/list-all';

    final response = await retry(() => _client.get<List<FavoriteFolder>>(
          url,
          params: {'up_mid': mid},
          dataParser: (data) {
            final list = (data as Map<String, dynamic>)['list'] as List? ?? [];
            return list
                .map((e) => FavoriteFolder.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        ));

    return response.data ?? [];
  }

  /// 获取收藏夹内容（视频列表）
  Future<List<FavoriteVideo>> getFolderVideos(
    int mediaId, {
    int pn = 1,
    int ps = 20,
  }) async {
    const url = 'https://api.bilibili.com/x/v3/fav/resource/list';

    final response = await retry(() => _client.get<List<FavoriteVideo>>(
          url,
          params: {
            'media_id': mediaId,
            'pn': pn,
            'ps': ps,
            'platform': 'web',
          },
          dataParser: (data) {
            final medias = (data as Map<String, dynamic>)['medias'] as List? ?? [];
            return medias
                .map((e) => FavoriteVideo.fromJson(e as Map<String, dynamic>))
                .toList();
          },
        ));

    return response.data ?? [];
  }
}
