class Pages {
  final int id;
  final String title;
  final String text;
  final String url;
  final DateTime createDatetime;

  Pages({required this.id, required this.title, required this.text, required this.url, required this.createDatetime});

  factory Pages.fromJson(Map<dynamic, dynamic> json){
    return Pages(
      id: json["id"]?? 0 as int,
      title: json["title"] ?? "",
      text: json["text"] ?? "",
      url: json["url"] ?? "",
      createDatetime: DateTime.parse(json["create_datetime"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "text": text,
    "url": url,
    "create_datetime": createDatetime.toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Pages &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          text == other.text &&
          url == other.url &&
          createDatetime == other.createDatetime;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      text.hashCode ^
      url.hashCode ^
      createDatetime.hashCode;
}
