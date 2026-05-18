class ServiceItem {
  const ServiceItem({
    required this.id,
    required this.professionalId,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
    this.isActive = true,
  });

  final String id;
  final String professionalId;
  final String name;
  final String description;
  final double price;
  final int durationMinutes;
  final bool isActive;

  ServiceItem copyWith({
    String? id,
    String? professionalId,
    String? name,
    String? description,
    double? price,
    int? durationMinutes,
    bool? isActive,
  }) {
    return ServiceItem(
      id: id ?? this.id,
      professionalId: professionalId ?? this.professionalId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      isActive: isActive ?? this.isActive,
    );
  }
}
