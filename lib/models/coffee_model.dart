class Coffee {
  final int id;
  String title;
  String description;
  String imageUrl;

  Coffee({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  factory Coffee.fromJson(Map<String, dynamic> json) {
    return Coffee(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['image'],
    );
  }
}
