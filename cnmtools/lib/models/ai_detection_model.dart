class AiDetectionResult {
  final int code;
  final String msg;
  final AiDetectionData? data;

  AiDetectionResult({
    required this.code,
    required this.msg,
    this.data,
  });

  factory AiDetectionResult.fromJson(Map<String, dynamic> json) {
    return AiDetectionResult(
      code: json['code'] ?? 0,
      msg: json['msg'] ?? '',
      data: json['data'] != null ? AiDetectionData.fromJson(json['data']) : null,
    );
  }
}

class AiDetectionData {
  final bool flagged;
  final AiCategories categories;
  final AiCategoryScores categoryScores;

  AiDetectionData({
    required this.flagged,
    required this.categories,
    required this.categoryScores,
  });

  factory AiDetectionData.fromJson(Map<String, dynamic> json) {
    return AiDetectionData(
      flagged: json['flagged'] ?? false,
      categories: AiCategories.fromJson(json['categories'] ?? {}),
      categoryScores: AiCategoryScores.fromJson(json['category_scores'] ?? {}),
    );
  }
}

class AiCategories {
  final bool aigc;

  AiCategories({required this.aigc});

  factory AiCategories.fromJson(Map<String, dynamic> json) {
    return AiCategories(
      aigc: json['aigc'] ?? false,
    );
  }
}

class AiCategoryScores {
  final double aigc;

  AiCategoryScores({required this.aigc});

  factory AiCategoryScores.fromJson(Map<String, dynamic> json) {
    final aigcValue = json['aigc'];
    return AiCategoryScores(
      aigc: aigcValue is num ? aigcValue.toDouble() : 0.0,
    );
  }
}
