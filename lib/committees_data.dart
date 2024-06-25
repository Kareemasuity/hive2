class Committee {
  final int committeeId;
  final String englishName;
  final String arabicName;
  final String englishDescription;
  final String arabicDescription;

  Committee({
    required this.committeeId,
    required this.englishName,
    required this.arabicName,
    required this.englishDescription,
    required this.arabicDescription,
  });

  factory Committee.fromJson(Map<String, dynamic> json) {
    return Committee(
      committeeId: json['committeeId'],
      englishName: json['englishName'],
      arabicName: json['arabicName'],
      englishDescription: json['englishDescreption'],
      arabicDescription: json['arabicDescreption'],
    );
  }
}
