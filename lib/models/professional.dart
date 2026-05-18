import 'enums.dart';

class Professional {
  const Professional({
    required this.id,
    required this.name,
    required this.specialty,
    required this.city,
    required this.imageUrl,
    required this.bio,
    required this.category,
  });

  final String id;
  final String name;
  final String specialty;
  final String city;
  final String imageUrl;
  final String bio;
  final ServiceCategory category;
}
