class NewsItem {
  final String createdAt;
  final String title;
  final String summary;
  final String source;
  final String url;

  NewsItem({
    required this.createdAt,
    required this.title,
    required this.summary,
    required this.source,
    required this.url,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      createdAt: json['created_at'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      source: json['source'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class NewsData {
  final String imageUrl;
  final List<NewsItem> modelsAndReleases;
  final List<NewsItem> toolsAndFrameworks;
  final List<NewsItem> researchAndPapers;
  final List<NewsItem> industryAndBusiness;
  final List<NewsItem> applicationsAndUseCases;
  final List<NewsItem> technicalDiscussions;
  final List<NewsItem> ethicsAndSafety;

  NewsData({
    required this.imageUrl,
    required this.modelsAndReleases,
    required this.toolsAndFrameworks,
    required this.researchAndPapers,
    required this.industryAndBusiness,
    required this.applicationsAndUseCases,
    required this.technicalDiscussions,
    required this.ethicsAndSafety,
  });

  factory NewsData.fromJson(Map<String, dynamic> json) {
    return NewsData(
      imageUrl: json['image_url'] ?? '',
      modelsAndReleases: (json['models_and_releases'] as List?)
              ?.map((item) => NewsItem.fromJson(item))
              .toList() ??
          [],
      toolsAndFrameworks: (json['tools_and_frameworks'] as List?)
              ?.map((item) => NewsItem.fromJson(item))
              .toList() ??
          [],
      researchAndPapers: (json['research_and_papers'] as List?)
              ?.map((item) => NewsItem.fromJson(item))
              .toList() ??
          [],
      industryAndBusiness: (json['industry_and_business'] as List?)
              ?.map((item) => NewsItem.fromJson(item))
              .toList() ??
          [],
      applicationsAndUseCases: (json['applications_and_use_cases'] as List?)
              ?.map((item) => NewsItem.fromJson(item))
              .toList() ??
          [],
      technicalDiscussions: (json['technical_discussions'] as List?)
              ?.map((item) => NewsItem.fromJson(item))
              .toList() ??
          [],
      ethicsAndSafety: (json['ethics_and_safety'] as List?)
              ?.map((item) => NewsItem.fromJson(item))
              .toList() ??
          [],
    );
  }

  List<NewsItem> getAllNews() {
    return [
      ...modelsAndReleases,
      ...toolsAndFrameworks,
      ...researchAndPapers,
      ...industryAndBusiness,
      ...applicationsAndUseCases,
      ...technicalDiscussions,
      ...ethicsAndSafety,
    ];
  }
}
