// models/special_follow.dart

/// 特别关注 UP 主
class SpecialFollow {
  final int mid;
  final String name;
  final String face;
  final String sign;
  final String officialVerify;

  SpecialFollow({
    required this.mid,
    required this.name,
    required this.face,
    required this.sign,
    required this.officialVerify,
  });

  factory SpecialFollow.fromJson(Map<String, dynamic> json) {
    final verify = json['official_verify'] as Map<String, dynamic>? ?? {};
    return SpecialFollow(
      mid: (json['mid'] as num?)?.toInt() ?? 0,
      name: json['uname'] as String? ?? '',
      face: json['face'] as String? ?? '',
      sign: json['sign'] as String? ?? '',
      officialVerify: verify['desc'] as String? ?? '',
    );
  }
}
