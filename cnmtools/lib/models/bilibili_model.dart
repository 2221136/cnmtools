class BilibiliResult {
  final int code;
  final String msg;
  final BilibiliData? data;

  BilibiliResult({
    required this.code,
    required this.msg,
    this.data,
  });

  factory BilibiliResult.fromJson(Map<String, dynamic> json) {
    return BilibiliResult(
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: json['data'] != null ? BilibiliData.fromJson(json['data']) : null,
    );
  }
}

class BilibiliData {
  final String title;
  final String cover;
  final String desc;
  final String pubdate;
  final String url;
  final BilibiliStats stats;
  final BilibiliUser user;

  BilibiliData({
    required this.title,
    required this.cover,
    required this.desc,
    required this.pubdate,
    required this.url,
    required this.stats,
    required this.user,
  });

  factory BilibiliData.fromJson(Map<String, dynamic> json) {
    return BilibiliData(
      title: json['title'] ?? '',
      cover: json['cover'] ?? '',
      desc: json['desc'] ?? '',
      pubdate: json['pubdate'] ?? '',
      url: json['url'] ?? '',
      stats: BilibiliStats.fromJson(json['stats'] ?? {}),
      user: BilibiliUser.fromJson(json['user'] ?? {}),
    );
  }
}

class BilibiliStats {
  final int view;
  final int danmaku;
  final int reply;
  final int favorite;
  final int coin;
  final int share;
  final int like;

  BilibiliStats({
    required this.view,
    required this.danmaku,
    required this.reply,
    required this.favorite,
    required this.coin,
    required this.share,
    required this.like,
  });

  factory BilibiliStats.fromJson(Map<String, dynamic> json) {
    return BilibiliStats(
      view: json['view'] ?? 0,
      danmaku: json['danmaku'] ?? 0,
      reply: json['reply'] ?? 0,
      favorite: json['favorite'] ?? 0,
      coin: json['coin'] ?? 0,
      share: json['share'] ?? 0,
      like: json['like'] ?? 0,
    );
  }
}

class BilibiliUser {
  final String name;
  final String userImg;

  BilibiliUser({
    required this.name,
    required this.userImg,
  });

  factory BilibiliUser.fromJson(Map<String, dynamic> json) {
    return BilibiliUser(
      name: json['name'] ?? '',
      userImg: json['user_img'] ?? '',
    );
  }
}
