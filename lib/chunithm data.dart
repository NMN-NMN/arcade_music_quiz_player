import 'dart:convert';

import 'package:better_quiz_game/chunithm%20class.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Map<String, Chunithm> chunithm = Map();
List<Chunithm> filteredChunithm = List.empty(growable: true);
List<String> chunithm_title = List.empty(growable: true);
List<String> chunithm_artist = List.empty(growable: true);
List<Chunithm> playerChunithm = List.empty(growable: true);

int chunithmIndex = -1;

//  Checkbox
late final Map<String, bool> checkedCategories = {
  for (final category in categories) category: true
};

late final Map<String, bool> checkedLevels = {
  for (final level in levels) level: true
};

//  RangeSlider
RangeValues rangeValues = const RangeValues(1, 16);

//  Categories
final categories = [
    "POPS & ANIME",
    "niconico",
    "東方Project",
    "VARIETY",
    "イロドリミドリ",
    "ゲキマイ",
    "ORIGINAL"
];

//  Level
final levels = [
    "basic",
    "advanced",
    "expert",
    "master",
    "ultima"
];

//  Dropdown Selected
List<String> selectedArtists = ["전체"];
String selectedTitle = "";

Future<void> init_Chunithm() async
{
  try
  {
    chunithm_artist.add("전체");

    final String chunithm_video_json = await rootBundle.loadString("assets/db/chunithm video.json");
    final String chunithm_sheets_json = await rootBundle.loadString("assets/db/chunithm sheets.json");

    final List<Map<String, dynamic>> chunithm_video_list = List<Map<String, dynamic>>.from(jsonDecode(chunithm_video_json));
    final Map<String, String> chunithm_video_map = {
      for (final item in chunithm_video_list)
        item["title"] as String: (item["hasVideo"] as bool) == true ? (item["youtubeIds"] as List)[0] : ""
    };

    chunithm_title = chunithm_video_map.keys.toList();

    final Map<String, dynamic> chunithm_data_list = Map<String, dynamic>.from(jsonDecode(chunithm_sheets_json));

    for (final item in chunithm_data_list["songs"])
    {
      final title = item["title"] as String; 

      if (item["sheets"][0]["type"] != "we")
      {
        chunithm[title] = Chunithm(
          title: title,
          artist: item["artist"],
          category: item["category"],
          sheets: [
            for (final sheet in item["sheets"])
              ChunithmSheet(
                difficulty: sheet["difficulty"],
                level: sheet["level"],
                levelValue: sheet["levelValue"]
              )
          ],
          youtubeId: chunithm_video_map[title] as String
        );

        if (!chunithm_artist.contains(item["artist"]))
        {
          chunithm_artist.add(item["artist"]);
        }
      }
    }

    print("Chunithm JSON 로드 성공!");
  }
  catch (e)
  {
    print("JSON 로드 중 에러 발생: $e");
  }
}

Future<void> filteringChunithm() async
{
  filteredChunithm.clear();
  playerChunithm.clear();
  chunithmIndex = -1;

  for (final data in chunithm.values)
  {
    if (checkedCategories[data.category] == true && (selectedArtists.contains("전체") || selectedArtists.contains(data.artist)))
    {
      for (final sheet in data.sheets)
      {
        if (checkedLevels[sheet.difficulty] == true && rangeValues.start <= sheet.levelValue && rangeValues.end >= sheet.levelValue)
        {
          filteredChunithm.add(data);
          break;
        }
      }
    }
  }

  playerChunithm = List.from(filteredChunithm);
  playerChunithm.shuffle();

  print("영상 개수: ${filteredChunithm.length}");
}

Chunithm getCurrentChunithm()
{
  return playerChunithm[chunithmIndex];
}

String getCurrentTitle()
{
  return getCurrentChunithm().title;
}

String getCurrentArtist()
{
  return getCurrentChunithm().artist;
}

String getCurrentCategory()
{
  return getCurrentChunithm().category;
}

List<ChunithmSheet> getCurrentLevel()
{
  return getCurrentChunithm().sheets;
}

String getCurrentVideoId()
{
  return getCurrentChunithm().youtubeId;
}

String getNextVideo()
{
  if (chunithmIndex == playerChunithm.length - 1)
  {
    return "none";
  }
  
  chunithmIndex += 1;

  return playerChunithm[chunithmIndex].youtubeId;
}

String getPreviousVideo()
{
  if (chunithmIndex == 0)
  {
    return "none";
  }
  
  chunithmIndex -= 1;

  return playerChunithm[chunithmIndex].youtubeId;
}