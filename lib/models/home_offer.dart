// Offer banner model for top-of-home
// Parses assets/data/home/offers.json

class HomeOffer {
  final String id;
  final String text;
  final String? url;
  final String? start; // ISO date string (e.g., 2025-09-01)
  final String? end;   // ISO date string
  final bool active;

  const HomeOffer({
    required this.id,
    required this.text,
    this.url,
    this.start,
    this.end,
    this.active = true,
  });

  factory HomeOffer.fromJson(Map<String, dynamic> json) {
    return HomeOffer(
      id: json['id'] as String,
      text: json['text'] as String,
      url: json['url'] as String?,
      start: json['start'] as String?,
      end: json['end'] as String?,
      active: (json['active'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        if (url != null) 'url': url,
        if (start != null) 'start': start,
        if (end != null) 'end': end,
        'active': active,
      };
}
