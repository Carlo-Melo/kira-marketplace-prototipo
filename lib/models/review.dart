class Review {
  const Review({
    required this.id,
    required this.professionalId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final String professionalId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime createdAt;
}
