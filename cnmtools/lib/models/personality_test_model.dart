class PersonalityQuestion {
  final String id;
  final String dimension;
  final String text;
  final List<QuestionOption> options;
  final bool isSpecial;
  final String? specialKind;

  PersonalityQuestion({
    required this.id,
    required this.dimension,
    required this.text,
    required this.options,
    this.isSpecial = false,
    this.specialKind,
  });
}

class QuestionOption {
  final String label;
  final int value;

  QuestionOption({
    required this.label,
    required this.value,
  });
}

class PersonalityType {
  final String code;
  final String cn;
  final String intro;
  final String desc;
  final String? imagePath;

  PersonalityType({
    required this.code,
    required this.cn,
    required this.intro,
    required this.desc,
    this.imagePath,
  });
}

class DimensionMeta {
  final String name;
  final String model;

  DimensionMeta({
    required this.name,
    required this.model,
  });
}

class TestResult {
  final PersonalityType type;
  final Map<String, int> dimensionScores;
  final int matchPercentage;

  TestResult({
    required this.type,
    required this.dimensionScores,
    required this.matchPercentage,
  });
}
