// Content card model for text blocks and CTAs
// Parses assets/data/home/content.json

class HomeContentCard {
  final String id;
  final String? subtitle;
  final String? title;
  final String? buttonText;

  const HomeContentCard({
    required this.id,
    this.subtitle,
    this.title,
    this.buttonText,
  });

  factory HomeContentCard.fromJson(Map<String, dynamic> json) {
    return HomeContentCard(
      id: json['id'] as String,
      subtitle: json['subtitle'] as String?,
      title: json['title'] as String?,
      buttonText: json['buttonText'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (subtitle != null) 'subtitle': subtitle,
        if (title != null) 'title': title,
        if (buttonText != null) 'buttonText': buttonText,
      };
}
