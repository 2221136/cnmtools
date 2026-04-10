class FontDesignData {
  final String nowTime;
  final String size;
  final String imgUrl;

  FontDesignData({
    required this.nowTime,
    required this.size,
    required this.imgUrl,
  });

  factory FontDesignData.fromJson(Map<String, dynamic> json) {
    return FontDesignData(
      nowTime: json['now_time'] ?? '',
      size: json['size'] ?? '',
      imgUrl: json['imgurl'] ?? '',
    );
  }
}

class FontDesignResult {
  final int code;
  final String msg;
  final FontDesignData? data;

  FontDesignResult({
    required this.code,
    required this.msg,
    this.data,
  });

  factory FontDesignResult.fromJson(Map<String, dynamic> json) {
    return FontDesignResult(
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: json['data'] != null 
          ? FontDesignData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
  
  // 便捷访问器
  String get nowTime => data?.nowTime ?? '';
  String get size => data?.size ?? '';
  String get imgUrl => data?.imgUrl ?? '';
}
