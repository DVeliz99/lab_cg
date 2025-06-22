class Service {
  final String? uid;
  final String name;
  final double? price;
  final bool active;

  Service({
    this.uid,
    required this.name,
    required this.price,
    required this.active,
  });

  factory Service.fromJson(Map<String, dynamic> json, {String? id}) {
    return Service(
      uid: id,
      name: json['name'] ?? '',
      price:
          (json['price'] != null)
              ? (json['price'] is int
                  ? (json['price'] as int).toDouble()
                  : json['price'] as double)
              : null,
      active: json['active'] ?? false,
    );
  }
}
