class Chunithm
{
  final String title;
  final String artist;
  final String category;
  final List<ChunithmSheet> sheets;
  final String youtubeId;

  Chunithm({
    required this.title,
    required this.artist,
    required this.category,
    required this.sheets,
    required this.youtubeId
  });

  factory Chunithm.fromJson(Map<String, dynamic> dataJson, String youtubeId)
  {
    return Chunithm(
      title: dataJson["title"],
      artist: dataJson["artist"],
      category: dataJson["category"],
      sheets: <ChunithmSheet>[],
      youtubeId: youtubeId
    );
  }
}

class ChunithmSheet
{
  final String difficulty;
  final String level;
  final double levelValue;

  ChunithmSheet({
    required this.difficulty,
    required this.level,
    required this.levelValue
  });
}