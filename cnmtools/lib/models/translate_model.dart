class TranslateResult {
  final int code;
  final String message;
  final String data;
  final String id;
  final String quality;
  final String sourceLang;
  final String targetLang;

  TranslateResult({
    required this.code,
    required this.message,
    required this.data,
    required this.id,
    required this.quality,
    required this.sourceLang,
    required this.targetLang,
  });

  factory TranslateResult.fromJson(Map<String, dynamic> json) {
    return TranslateResult(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] ?? '',
      id: json['id'] ?? '',
      quality: json['quality'] ?? '',
      sourceLang: json['source_lang'] ?? '',
      targetLang: json['target_lang'] ?? '',
    );
  }
}
