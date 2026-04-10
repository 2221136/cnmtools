class WallpaperResult {
  final bool success;
  final WallpaperData? data;

  WallpaperResult({
    required this.success,
    this.data,
  });

  factory WallpaperResult.fromJson(Map<String, dynamic> json) {
    return WallpaperResult(
      success: json['success'] ?? false,
      data: json['data'] != null ? WallpaperData.fromJson(json['data']) : null,
    );
  }
}

class WallpaperData {
  final int id;
  final String imageUrl;
  final int width;
  final int height;
  final String msg;
  final String source;

  WallpaperData({
    required this.id,
    required this.imageUrl,
    required this.width,
    required this.height,
    required this.msg,
    required this.source,
  });

  factory WallpaperData.fromJson(Map<String, dynamic> json) {
    return WallpaperData(
      id: json['id'] ?? 0,
      imageUrl: json['image_url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      msg: json['msg'] ?? '',
      source: json['source'] ?? '',
    );
  }
}
