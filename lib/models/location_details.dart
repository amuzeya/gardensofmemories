// Location details and content blocks for bottom sheet rendering
// Parsed from assets/data/home/location_details.prod.json

class LocationDetails {
  final String id; // matches HomeLocation.id
  final String? coverImage; // local asset path
  final List<String> galleryRemote; // remote URLs
  final List<String> galleryLocal; // local asset paths
  final List<String> videosLocal; // local asset paths
  final List<String> videosRemote; // remote URLs
  final List<ContentBlock> content; // ordered content blocks

  const LocationDetails({
    required this.id,
    this.coverImage,
    this.galleryRemote = const [],
    this.galleryLocal = const [],
    this.videosLocal = const [],
    this.videosRemote = const [],
    this.content = const [],
  });

  factory LocationDetails.fromJson(Map<String, dynamic> json) {
    final blocks = (json['content'] as List? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(ContentBlock.fromJson)
        .toList();
    return LocationDetails(
      id: json['id'] as String,
      coverImage: json['coverImage'] as String?,
      galleryRemote: _toStringList(json['galleryRemote']),
      galleryLocal: _toStringList(json['galleryLocal']),
      videosLocal: _toStringList(json['videosLocal']),
      videosRemote: _toStringList(json['videosRemote']),
      content: blocks,
    );
  }

  static List<String> _toStringList(dynamic v) {
    if (v is List) {
      return v.whereType<String>().toList(growable: false);
    }
    return const [];
  }
}

abstract class ContentBlock {
  final String type;
  const ContentBlock(this.type);

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    final t = (json['type'] as String? ?? '').toLowerCase();
    switch (t) {
      case 'text':
        return TextBlock(body: json['body'] as String? ?? '');
      case 'slideshow':
        return SlideshowBlock(
          title: json['title'] as String?,
          source: (json['source'] as String? ?? 'remote').toLowerCase(),
          images: LocationDetails._toStringList(json['images']),
        );
      case 'image':
        return ImageBlock(
          source: (json['source'] as String? ?? 'remote').toLowerCase(),
          src: json['src'] as String? ?? '',
          caption: json['caption'] as String?,
        );
      case 'video':
        return VideoBlock(
          source: (json['source'] as String? ?? 'local').toLowerCase(),
          src: json['src'] as String? ?? '',
          title: json['title'] as String?,
        );
      default:
        return TextBlock(body: '');
    }
  }
}

class TextBlock extends ContentBlock {
  final String body;
  const TextBlock({required this.body}) : super('text');
}

class SlideshowBlock extends ContentBlock {
  final String? title;
  final String source; // 'remote' | 'local'
  final List<String> images;
  const SlideshowBlock({this.title, required this.source, required this.images})
      : super('slideshow');
}

class ImageBlock extends ContentBlock {
  final String source; // 'remote' | 'local'
  final String src;
  final String? caption;
  const ImageBlock({required this.source, required this.src, this.caption})
      : super('image');
}

class VideoBlock extends ContentBlock {
  final String source; // 'remote' | 'local'
  final String src;
  final String? title;
  const VideoBlock({required this.source, required this.src, this.title})
      : super('video');
}