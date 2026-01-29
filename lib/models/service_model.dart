class Service {
  final String? id; 
  final String title;
  final String imagePath;
  final String description;
  final int priceRsd;
  final String duration;
  final bool isDeleted;

  Service({
    this.id, 
    required this.title,
    required this.imagePath,
    required this.description,
    required this.priceRsd,
    required this.duration,
    this.isDeleted = false,
  });

  factory Service.fromMap(Map<String, dynamic> data, String documentId) {
    return Service(
      id: documentId,
      title: data['title'] ?? '',
      imagePath: data['imagePath'] ?? '',
      description: data['description'] ?? '',
      priceRsd: data['priceRsd'] ?? 0,
      duration: data['duration'] ?? '',
      isDeleted: data['isDeleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imagePath': imagePath,
      'description': description,
      'priceRsd': priceRsd,
      'duration': duration,
      'isDeleted': isDeleted,
    };
  }
}