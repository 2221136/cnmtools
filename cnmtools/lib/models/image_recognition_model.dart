class ImageRecognitionResult {
  final int code;
  final String msg;
  final String result;

  ImageRecognitionResult({
    required this.code,
    required this.msg,
    required this.result,
  });

  factory ImageRecognitionResult.fromJson(Map<String, dynamic> json) {
    return ImageRecognitionResult(
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      result: json['result'] ?? '',
    );
  }
}
