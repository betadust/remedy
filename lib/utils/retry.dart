// utils/retry.dart

/// 对可能因网络抖动而失败的请求自动重试。
///
/// [fn] 要执行的操作；[attempts] 最大尝试次数（默认 3）；
/// [delay] 两次尝试之间的等待（默认 1 秒）。
Future<T> retry<T>(
  Future<T> Function() fn, {
  int attempts = 3,
  Duration delay = const Duration(seconds: 1),
}) async {
  for (var i = 0; i < attempts; i++) {
    try {
      return await fn();
    } catch (e) {
      if (i == attempts - 1) rethrow;
      await Future.delayed(delay);
    }
  }
  throw StateError('unreachable');
}
