class Service {
  final String id;
  final String title;
  final String imagePath;
  final String description;

  int priceRsd;
  final String duration;
  bool isDeleted;

  Service({
  required this.id,
  required this.title,
  required this.imagePath,
  required this.description,
  required this.priceRsd,
  required this.duration,
  this.isDeleted = false,
  });
}
