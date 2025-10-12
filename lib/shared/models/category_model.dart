class Category {
  final String slug;
  final String name;
  final String url;

  Category({required this.slug, required this.name, required this.url});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(slug: json['slug'], name: json['name'], url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {'slug': slug, 'name': name, 'url': url};
  }

  @override
  String toString() {
    return 'Category(slug: $slug, name: $name, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Category && other.slug == slug;
  }

  @override
  int get hashCode => slug.hashCode;
}
