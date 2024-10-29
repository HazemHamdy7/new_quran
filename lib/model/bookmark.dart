class Bookmark {
  final int surahNumber;
  final int ayahNumber;
  final String surahName;
  final String ayahText;

  Bookmark({
    required this.surahNumber,
    required this.ayahNumber,
    required this.surahName,
    required this.ayahText,
  });

  Map<String, dynamic> toJson() => {
        'surahNumber': surahNumber,
        'ayahNumber': ayahNumber,
        'surahName': surahName,
        'ayahText': ayahText,
      };

  factory Bookmark.fromJson(Map<String, dynamic> json) => Bookmark(
        surahNumber: json['surahNumber'],
        ayahNumber: json['ayahNumber'],
        surahName: json['surahName'],
        ayahText: json['ayahText'],
      );
}
