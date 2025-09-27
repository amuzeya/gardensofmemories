// Carousel item model for the home hero carousel
// Parses assets/data/home/carousel.json

enum HomeCarouselItemType { image, video }

HomeCarouselItemType homeCarouselItemTypeFromString(String? s) {
  switch ((s ?? '').toLowerCase()) {
    case 'image':
      return HomeCarouselItemType.image;
    case 'video':
      return HomeCarouselItemType.video;
    default:
      return HomeCarouselItemType.image;
  }
}

String homeCarouselItemTypeToString(HomeCarouselItemType t) {
  switch (t) {
    case HomeCarouselItemType.image:
      return 'image';
    case HomeCarouselItemType.video:
      return 'video';
  }
}

class HomeCarouselItem {
  final String id;
  final HomeCarouselItemType type;
  final String? imagePath;
  final String? videoPath;
  final String? introText;
  final String title;
  final String? subtitle;
  final String? paragraph;

  const HomeCarouselItem({
    required this.id,
    required this.type,
    this.imagePath,
    this.videoPath,
    this.introText,
    required this.title,
    this.subtitle,
    this.paragraph,
  });

  factory HomeCarouselItem.fromJson(Map<String, dynamic> json) {
    final type = homeCarouselItemTypeFromString(json['type'] as String?);
    return HomeCarouselItem(
      id: json['id'] as String,
      type: type,
      imagePath: json['imagePath'] as String?,
      videoPath: json['videoPath'] as String?,
      introText: json['introText'] as String?,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      paragraph: json['paragraph'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': homeCarouselItemTypeToString(type),
        if (imagePath != null) 'imagePath': imagePath,
        if (videoPath != null) 'videoPath': videoPath,
        if (introText != null) 'introText': introText,
        'title': title,
        if (subtitle != null) 'subtitle': subtitle,
        if (paragraph != null) 'paragraph': paragraph,
      };
}
