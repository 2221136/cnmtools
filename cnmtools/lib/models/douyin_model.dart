class DouyinMusic {
  final String title;
  final String author;
  final String avatar;
  final String? url;

  DouyinMusic({
    required this.title,
    required this.author,
    required this.avatar,
    this.url,
  });

  factory DouyinMusic.fromJson(Map<String, dynamic> json) {
    return DouyinMusic(
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      avatar: json['avatar'] ?? '',
      url: json['url'],
    );
  }
}

class DouyinData {
  final String author;
  final String uid;
  final String avatar;
  final int like;
  final int comment;
  final int collect;
  final int share;
  final int time;
  final String publishTime;
  final String title;
  final String cover;
  final List<String> images;
  final List<String> tags;
  final String url;
  final DouyinMusic music;

  DouyinData({
    required this.author,
    required this.uid,
    required this.avatar,
    required this.like,
    required this.comment,
    required this.collect,
    required this.share,
    required this.time,
    required this.publishTime,
    required this.title,
    required this.cover,
    required this.images,
    required this.tags,
    required this.url,
    required this.music,
  });

  factory DouyinData.fromJson(Map<String, dynamic> json) {
    return DouyinData(
      author: json['author'] ?? '',
      uid: json['uid'] ?? '',
      avatar: json['avatar'] ?? '',
      like: json['like'] ?? 0,
      comment: json['comment'] ?? 0,
      collect: json['collect'] ?? 0,
      share: json['share'] ?? 0,
      time: json['time'] ?? 0,
      publishTime: json['publish_time'] ?? '',
      title: json['title'] ?? '',
      cover: json['cover'] ?? '',
      images: (json['images'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      url: json['url'] ?? '',
      music: DouyinMusic.fromJson(json['music'] ?? {}),
    );
  }
}

class DouyinResult {
  final int code;
  final String msg;
  final DouyinData? data;

  DouyinResult({
    required this.code,
    required this.msg,
    this.data,
  });

  factory DouyinResult.fromJson(Map<String, dynamic> json) {
    return DouyinResult(
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: json['data'] != null 
          ? DouyinData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}
