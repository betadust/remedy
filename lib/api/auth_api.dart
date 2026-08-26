// api/auth_api.dart
import 'package:bilibili_api/bilibili_api.dart' hide UserInfo;
import 'package:flutter/foundation.dart';

import '../models/user_info.dart';
import '../utils/retry.dart';

// 把 store 层需要用到的类型透传出去，store 只需 import 本文件
export 'package:bilibili_api/bilibili_api.dart'
    show QRCodeData, QRPollData, QRPollStatus;

/// 封装哔哩哔哩登录相关的网络请求
class AuthApi {
  late final BiliHttpClient _client;
  late final LoginApi _loginApi;
  late final LoginInfoApi _loginInfoApi;
  late final UserApi _userApi;

  AuthApi() {
    _client = BiliHttpClient(cookieManager: CookieManager());
    _loginApi = LoginApi(_client);
    _loginInfoApi = LoginInfoApi(_client);
    _userApi = UserApi(_client);
  }

  Future<QRCodeData> generateQRCode() => retry(_loginApi.generateQRCode);

  Future<QRPollData> pollQRCode(String qrcodeKey) =>
      _loginApi.pollQRCode(qrcodeKey);

  /// 获取当前登录用户信息，转换为应用层 [UserInfo]
  ///
  /// 先 getNavInfo：既拿到 mid，也会刷新 WBI 密钥（getUserInfo 的签名需要）。
  /// 再用 getUserInfo 拿详细字段；但该接口的 fromJson 对 rank/silence 等
  /// 字段做了非空强转，字段为 null 时会崩（bilibili_api 包 bug），
  /// 因此失败时降级用 nav 接口的 uname/face。
  Future<UserInfo> fetchCurrentUser() async {
    final navInfo = await retry(_loginInfoApi.getNavInfo);
    final mid = navInfo.mid;
    if (mid == null) {
      throw Exception('获取用户信息失败：未登录（mid 为空）');
    }

    try {
      final detail = await retry(() => _userApi.getUserInfo(mid));
      return UserInfo(
        name: detail.name,
        avatar: detail.face,
        uid: mid.toString(),
      );
    } catch (e) {
      debugPrint('getUserInfo 失败，降级使用 nav 信息: $e');
      return UserInfo(
        name: navInfo.uname ?? '',
        avatar: navInfo.face ?? '',
        uid: mid.toString(),
      );
    }
  }

  void close() => _client.close();
}
