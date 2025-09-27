// Product model for home highlights
// Parses assets/data/home/products.json

class HomeProduct {
  final String id;
  final String name;
  final String? subtitle;
  final String? description;
  final String image;
  final double? price;
  final String? currency;
  final String? url;

  const HomeProduct({
    required this.id,
    required this.name,
    this.subtitle,
    this.description,
    required this.image,
    this.price,
    this.currency,
    this.url,
  });

  factory HomeProduct.fromJson(Map<String, dynamic> json) {
    return HomeProduct(
      id: json['id'] as String,
      name: json['name'] as String,
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String?,
      image: json['image'] as String? ?? '',
      price: (json['price'] is num) ? (json['price'] as num).toDouble() : null,
      currency: json['currency'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (subtitle != null) 'subtitle': subtitle,
        if (description != null) 'description': description,
        'image': image,
        if (price != null) 'price': price,
        if (currency != null) 'currency': currency,
        if (url != null) 'url': url,
      };
}
