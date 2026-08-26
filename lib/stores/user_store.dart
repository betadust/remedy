// stores/user_store.dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../api/auth_api.dart';
import '../models/user_info.dart';

class UserStore extends ChangeNotifier {
  final AuthApi _authApi = AuthApi();

  UserInfo? _user;              // 用户信息
  String? _qrUrl;               // 二维码 URL
  bool _isGenerating = false;   // 是否正在生成二维码
  String _qrLoginStatus = '';   // 登录状态文字
  Timer? _pollTimer;            // 轮询定时器
  String? _currentQrcodeKey;    // 当前二维码 key

  bool get isLoggedIn => _user != null;
  UserInfo? get user => _user;
  String? get qrUrl => _qrUrl;
  bool get isGenerating => _isGenerating;
  String get qrLoginStatus => _qrLoginStatus;

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
    notifyListeners();
  }

  @override
  void dispose() {
    _stopPolling();
    _authApi.close();
    super.dispose();
  }
}
