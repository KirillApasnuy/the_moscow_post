class News {
  final int id;
  final String rubricName;
  final int rubricId;
  final String title;
  final String description;
  final String mediumImageTitleUrl;
  final DateTime updateDateTime;
  final int viewsCount;
  final String text;
  final String fullUrl;
  final String author;
  final int day;
  final bool viewCountDisplay;
  final String serverHost;
  const News({required this.author,
    required this.id,
    required this.rubricName,
    required this.rubricId,
    required this.title,
    required this.description,
    required this.mediumImageTitleUrl,
    required this.updateDateTime,
    required this.viewsCount,
    required this.text,
    required this.fullUrl,
    required this.day,
    required this.viewCountDisplay,
    required this.serverHost,
  });

  factory News.fromJson(Map<dynamic, dynamic> json, viewCountDisplay, serverHost) {
    return News(
      id: json["id"] ?? 0 as int,
      rubricName: json["rubric_name"]?? "",
      rubricId: json["rubric_id"] ?? 0 as int ,
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      mediumImageTitleUrl: "http://$serverHost${json["medium_image_src"]}" ?? "url null",
      updateDateTime: DateTime.parse(json["create_datetime"]),
      viewsCount: json["views_count"] ?? 0 as int,
      text: json["text"] ?? "",
      fullUrl: json["full_url"] ?? "",
      author: json["author"] ?? "",
      day: json["day"] ?? 0 as int,
      viewCountDisplay: viewCountDisplay,
      serverHost: serverHost,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "rubric_name": rubricName,
        "rubric_id": rubricId,
        "title": title,
        "description": description,
        "medium_image_title_url": mediumImageTitleUrl,
        "update_datetime": updateDateTime.toIso8601String(),
        "views_count": viewsCount,
        "text": text,
        "full_url": fullUrl,
        "author": author,
        "day": day,
        "serverHost": serverHost,
        "viewCountDisplay": viewCountDisplay,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is News &&
        id == other.id &&
        rubricName == other.rubricName &&
        rubricId == other.rubricId &&
        title == other.title &&
        description == other.description &&
        mediumImageTitleUrl == other.mediumImageTitleUrl &&
        updateDateTime == other.updateDateTime &&
        viewsCount == other.viewsCount &&
        text == other.text &&
        author == other.author &&
        day == other.day &&
        viewCountDisplay == other.viewCountDisplay &&
        serverHost == other.serverHost &&
        fullUrl == other.fullUrl;
  }

  @override
  int get hashCode {
    int result = 7;

    result = 3 * result + id.hashCode;
    result = 3 * result + rubricName.hashCode;
    result = 3 * result + rubricId.hashCode;
    result = 3 * result + title.hashCode;
    result = 3 * result + description.hashCode;
    result = 3 * result + mediumImageTitleUrl.hashCode;
    result = 3 * result + updateDateTime.hashCode;
    result = 3 * result + viewsCount.hashCode;
    result = 3 * result + text.hashCode;
    result = 3 * result + fullUrl.hashCode;
    result = 3 * result + author.hashCode;
    result = 3 * result + day.hashCode;
    result = 3 * result + serverHost.hashCode;
    result = 3 * result + viewCountDisplay.hashCode;

    return result;
  }
}
