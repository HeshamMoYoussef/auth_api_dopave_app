class ArticlesModel {
  late final String url;
  final String image;
  final String title;
  final bool hasVideo;
  final String description;
  final String date;

  ArticlesModel({
    required this.url,
    required this.image,
    required this.title,
    required this.hasVideo,
    required this.description,
    required this.date,
  });

  factory ArticlesModel.fromJson(Map<String, dynamic> json) => ArticlesModel(
    url: json["url"],
    image: json["image"],
    title: json["title"],
    hasVideo: json["has_video"],
    description: json["description"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "image": image,
    "title": title,
    "has_video": hasVideo,
    "description": description,
    "date": date,
  };
}
