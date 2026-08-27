// stores/user_store.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../api/auth_api.dart';
import '../api/favorite_api.dart';
import '../api/special_follow_api.dart';
import '../api/watch_later_api.dart';
import '../models/favorite.dart';
import '../models/home_feed.dart';
import '../models/special_follow.dart';
import '../models/user_info.dart';
import '../models/watch_later.dart';
import 'settings_store.dart';

class UserStore extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();
  late final FavoriteApi _favoriteApi = FavoriteApi(_authApi.client);
  late final WatchLaterApi _watchLaterApi = WatchLaterApi(_authApi.client);
  late final SpecialFollowApi _specialFollowApi = SpecialFollowApi(_authApi.client);
  final SettingsStore _settingsStore;

  UserStore({required SettingsStore settingsStore})
      : _settingsStore = settingsStore;

  UserInfo? _user;              // 用户信息
  String? _qrUrl;               // 二维码 URL
  bool _isGenerating = false;   // 是否正在生成二维码
  String _qrLoginStatus = '';   // 登录状态文字
  Timer? _pollTimer;            // 轮询定时器
  String? _currentQrcodeKey;    // 当前二维码 key

  // 收藏夹相关状态
  List<FavoriteFolder> _folders = [];                    // 公开收藏夹
  Map<int, List<FavoriteVideo>> _folderVideos = {};      // 收藏夹 id -> 视频列表
  FavoriteVideo? _todayVideo;                            // 今日推荐视频
  bool _isLoadingFolders = false;                        // 是否正在加载收藏夹
  bool _isLoadingToday = false;                          // 是否正在加载今日推荐

  // 稍后再看相关状态
  List<WatchLaterVideo> _watchLaterVideos = [];          // 今日随机推荐的稍后再看视频
  bool _isLoadingWatchLater = false;                     // 是否正在加载稍后再看

  // 首页信息流相关状态
  List<SpecialFollow> _specialFollows = [];              // 特别关注 UP 主列表
  List<HomeFeedItem> _homeFeed = [];                     // 首页信息流
  bool _isLoadingHomeFeed = false;                       // 是否正在加载首页信息流

  bool get isLoggedIn => _user != null;
  UserInfo? get user => _user;
  String? get qrUrl => _qrUrl;
  bool get isGenerating => _isGenerating;
  String get qrLoginStatus => _qrLoginStatus;
  List<FavoriteFolder> get folders => _folders;
  Map<int, List<FavoriteVideo>> get folderVideos => _folderVideos;
  FavoriteVideo? get todayVideo => _todayVideo;
  bool get isLoadingFolders => _isLoadingFolders;
  bool get isLoadingToday => _isLoadingToday;
  List<WatchLaterVideo> get watchLaterVideos => _watchLaterVideos;
  bool get isLoadingWatchLater => _isLoadingWatchLater;
  List<SpecialFollow> get specialFollows => _specialFollows;
  List<HomeFeedItem> get homeFeed => _homeFeed;
  bool get isLoadingHomeFeed => _isLoadingHomeFeed;

  /// 生成二维码并启动轮询（登录流程的入口，UI 层只调用这一个方法）
  ///
  /// 注意：本方法在第一个 await 之前就同步调用了 [notifyListeners]，
  /// 因此不能在 initState/build 阶段同步调用（会触发
  /// "setState() or markNeedsBuild() called during build"）。
  /// 需要延迟执行时用 Future.microtask 或 addPostFrameCallback 包裹。
  Future<void> generateQrCode() async {
    _stopPolling();
    _isGenerating = true;
    _qrUrl = null;
    _qrLoginStatus = '正在生成二维码...';
    notifyListeners();

    try {
      final qrcode = await _authApi.generateQRCode();
      _currentQrcodeKey = qrcode.qrcodeKey;
      _qrUrl = qrcode.url;
      _isGenerating = false;
      _qrLoginStatus = '请打开哔哩哔哩App扫码';
      notifyListeners();

      _startPolling();
    } catch (e) {
      _isGenerating = false;
      _qrLoginStatus = '生成二维码失败，请重试';
      notifyListeners();
    }
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      final key = _currentQrcodeKey;
      if (key == null) {
        timer.cancel();
        return;
      }

      try {
        final status = await _authApi.pollQRCode(key);

        switch (status.status) {
          case QRPollStatus.success:
            timer.cancel();
            try {
              await _fetchUserInfo();
              _qrLoginStatus = '登录成功！';
            } catch (e) {
              // 扫码已成功（cookie 已保存），仅拉取用户信息失败
              debugPrint('获取用户信息失败: $e');
              _qrLoginStatus = '获取用户信息失败，请重新获取二维码';
            }
            notifyListeners();
            // 登录后异步加载收藏夹、稍后再看和首页信息流（不阻塞跳转）
            loadFavorites();
            loadWatchLater();
            loadHomeFeed();
            return;

          case QRPollStatus.expired:
            timer.cancel();
            _qrLoginStatus = '二维码已过期，请重新获取';
            notifyListeners();
            return;

          case QRPollStatus.scanned:
            _qrLoginStatus = '已扫码，请在手机上确认';
            notifyListeners();
            break;

          case QRPollStatus.notScanned:
            break;
        }
      } catch (e) {
        debugPrint('轮询异常: $e');
      }
    });
  }

  Future<void> _fetchUserInfo() async {
    _user = await _authApi.fetchCurrentUser();
  }

  /// 加载公开收藏夹 + 今日随机推荐
  Future<void> loadFavorites() async {
    final mid = _user?.uid;
    if (mid == null) return;

    _isLoadingFolders = true;
    _isLoadingToday = true;
    notifyListeners();

    try {
      final all = await _favoriteApi.getFavoriteFolders(int.parse(mid));
      _folders = all.where((f) => f.isPublic).toList();
    } catch (e) {
      debugPrint('加载收藏夹失败: $e');
      _folders = [];
    } finally {
      _isLoadingFolders = false;
      notifyListeners();
    }

    await _loadTodayVideo();
  }

  /// 展开收藏夹时懒加载其视频列表
  Future<void> loadFolderVideos(int mediaId) async {
    if (_folderVideos.containsKey(mediaId)) return;

    try {
      final videos = await _favoriteApi.getFolderVideos(mediaId);
      _folderVideos[mediaId] = videos;
      notifyListeners();
    } catch (e) {
      debugPrint('加载收藏夹视频失败: $e');
    }
  }

  /// 日期作为随机种子，随机选一个公开收藏夹，再随机选一个视频作为今日推荐
  Future<void> _loadTodayVideo() async {
    if (_folders.isEmpty) {
      _isLoadingToday = false;
      notifyListeners();
      return;
    }

    try {
      final now = DateTime.now();
      final seed = now.year * 10000 + now.month * 100 + now.day;
      final random = Random(seed);

      final folder = _folders[random.nextInt(_folders.length)];
      final videos = await _favoriteApi.getFolderVideos(folder.id);

      if (videos.isEmpty) {
        _todayVideo = null;
      } else {
        _todayVideo = videos[random.nextInt(videos.length)];
      }
    } catch (e) {
      debugPrint('加载今日推荐失败: $e');
      _todayVideo = null;
    } finally {
      _isLoadingToday = false;
      notifyListeners();
    }
  }

  /// 加载稍后再看，按日期种子随机取 10 个
  Future<void> loadWatchLater() async {
    if (_user == null) return;

    _isLoadingWatchLater = true;
    notifyListeners();

    try {
      final all = await _watchLaterApi.getWatchLater();

      final now = DateTime.now();
      final seed = now.year * 10000 + now.month * 100 + now.day;
      final random = Random(seed);

      // Fisher-Yates 洗牌
      final shuffled = List<WatchLaterVideo>.from(all);
      for (var i = shuffled.length - 1; i > 0; i--) {
        final j = random.nextInt(i + 1);
        final tmp = shuffled[i];
        shuffled[i] = shuffled[j];
        shuffled[j] = tmp;
      }

      _watchLaterVideos = shuffled.take(_settingsStore.watchLaterCount).toList();
    } catch (e) {
      debugPrint('加载稍后再看失败: $e');
      _watchLaterVideos = [];
    } finally {
      _isLoadingWatchLater = false;
      notifyListeners();
    }
  }

  /// 加载首页信息流：特别关注列表 + 过滤后的动态
  Future<void> loadHomeFeed() async {
    if (_user == null) return;

    _isLoadingHomeFeed = true;
    notifyListeners();

    try {
      // 1. 拿特别关注列表
      _specialFollows = await _specialFollowApi.getSpecialFollows();
      final followMids = _specialFollows.map((f) => f.mid).toSet();
      debugPrint('特别关注数量: ${followMids.length}, mids: $followMids');

      // 2. 翻页拉取动态，直到覆盖 homeFeedDays 天窗口或没有更多
      final cutoffTs = DateTime.now()
              .subtract(Duration(days: _settingsStore.homeFeedDays))
              .millisecondsSinceEpoch ~/
          1000;

      final feed = <HomeFeedItem>[];
      String? offset;
      var pageCount = 0;
      var reachedCutoff = false;

      while (!reachedCutoff && pageCount < 20) {
        pageCount++;
        final (items, hasMore, nextOffset) =
            await _specialFollowApi.getFollowFeedPage(offset: offset);

        for (final item in items) {
          final parsed = HomeFeedItem.fromDynamicJson(item);
          if (parsed == null) {
            continue;
          }
          if (parsed.pubTs < cutoffTs) {
            // 已超出时间窗口，停止翻页
            reachedCutoff = true;
            break;
          }
          if (followMids.contains(parsed.authorMid)) {
            feed.add(parsed);
          }
        }

        debugPrint('第 $pageCount 页: ${items.length} 条, hasMore=$hasMore');
        if (!hasMore || nextOffset == null) break;
        offset = nextOffset;
      }

      // 3. 按发布时间倒序
      feed.sort((a, b) => b.pubTs.compareTo(a.pubTs));
      _homeFeed = feed;
      debugPrint('首页信息流最终 ${feed.length} 条');
    } catch (e) {
      debugPrint('加载首页信息流失败: $e');
      _specialFollows = [];
      _homeFeed = [];
    } finally {
      _isLoadingHomeFeed = false;
      notifyListeners();
    }
  }

  void _stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  // 停止轮询（页面销毁时调用）
  // 不调用 notifyListeners：dispose 发生在 widget 树锁定阶段，
  // 此时通知会触发 "setState() called when widget tree was locked"。
  void stopPolling() {
    _stopPolling();
    _isGenerating = false;
  }

  void logout() {
    _stopPolling();
    _user = null;
    _qrUrl = null;
    _qrLoginStatus = '';
    _isGenerating = false;
    _currentQrcodeKey = null;
    _folders = [];
    _folderVideos = {};
    _todayVideo = null;
    _isLoadingFolders = false;
    _isLoadingToday = false;
    _watchLaterVideos = [];
    _isLoadingWatchLater = false;
    _specialFollows = [];
    _homeFeed = [];
    _isLoadingHomeFeed = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopPolling();
    _authApi.close();
    super.dispose();
  }
}
