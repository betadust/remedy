// stores/user_store.dart
import 'package:flutter/material.dart';
import 'package:bilibili_api/bilibili_api.dart';


//new

// stores/user_store.dart
import 'dart:async';

class UserInfo {
  final String name;
  final String avatar;
  final String uid;
  UserInfo({required this.name, required this.avatar, required this.uid});
}

class UserStore extends ChangeNotifier {
  // ✅ 显式创建 CookieManager 和 BiliHttpClient
  final CookieManager _cookieManager = CookieManager();
  late final BiliHttpClient _client;
  late final LoginApi _loginApi;

  UserInfo? _user;                //用户信息
  String _qrLoginStatus = '';     //二维码登录状态
  bool _isLoadingQr = false;      //正在登录吗
  Timer? _pollTimer;              //轮询次数
  String? _currentQrcodeKey;      //当前二维码key

  bool get isLoggedIn => _user != null;
  String get qrLoginStatus => _qrLoginStatus;
  bool get isLoadingQr => _isLoadingQr;
  UserInfo? get user => _user;

  UserStore() {
    // 初始化客户端
    _client = BiliHttpClient(cookieManager: _cookieManager);
    _loginApi = LoginApi(_client);
  }

  // 生成二维码
  Future<String> generateQrCode() async {
    try {
      final qrcode = await _loginApi.generateQRCode();
      _currentQrcodeKey = qrcode.qrcodeKey;
      return qrcode.url;
    } catch (e) {
      throw Exception('生成二维码失败: $e');
    }
  }

  // 手动轮询（基于官方文档的 pollQRCode）
  void startPolling() {
    _qrLoginStatus = '等待扫码...';
    _isLoadingQr = true;
    notifyListeners();

    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
      if (_currentQrcodeKey == null) {
        timer.cancel();
        return;
      }

      try {
        // final loginApi = LoginApi(_client);
        // ✅ 使用官方提供的 pollQRCode 方法
        print("LX! 调用pollQRCode");
        final status = await _loginApi.pollQRCode(_currentQrcodeKey!);

        switch (status.status) {
          case QRPollStatus.success:
          // 登录成功！
            timer.cancel();
            _isLoadingQr = false;
            await _fetchUserInfo();
            _qrLoginStatus = '登录成功！';
            notifyListeners();
            return;

          case QRPollStatus.expired:
            timer.cancel();
            _isLoadingQr = false;
            _qrLoginStatus = '二维码已过期，请重新获取';
            notifyListeners();
            return;

          case QRPollStatus.scanned:
          // 已扫码，等待用户确认
            _qrLoginStatus = '已扫码，请在手机上确认';
            notifyListeners();
            break;

          case QRPollStatus.notScanned:
          // 未扫码，继续等待
            break;
        }
      } catch (e) {
        print('轮询异常: $e');
        // 如果异常是过期，停止轮询
        // if (e.toString().contains('86038') || e.toString().contains('expired')) {
        //   print('国企！');
        //   timer.cancel();
        //   _isLoadingQr = false;
        //   _qrLoginStatus = '二维码已过期，请重新获取';
        //   notifyListeners();
        // }
      }
    });
  }

  // 获取用户信息
  Future<void> _fetchUserInfo() async {
    final loginInfoApi = LoginInfoApi(_client);
    final navInfo = await loginInfoApi.getNavInfo();
    final mid = navInfo.mid!;
    final userApi = UserApi(_client);
    final userDetail = await userApi.getUserInfo(mid);

    _user = UserInfo(
      name: userDetail.name,
      avatar: userDetail.face,
      uid: mid.toString(),
    );
  }

  // 停止轮询
  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
    _isLoadingQr = false;
    notifyListeners();
  }

  // 登出
  void logout() {
    stopPolling();
    _user = null;
    _qrLoginStatus = '';
    _isLoadingQr = false;
    _currentQrcodeKey = null;
    notifyListeners();
  }

  @override
  void dispose() {
    stopPolling();
    _client.close(); // 释放资源
    super.dispose();
  }
}