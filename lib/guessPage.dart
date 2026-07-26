import 'package:better_quiz_game/chunithm%20data.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class GuessPage extends StatefulWidget {
  const GuessPage({super.key, required this.guessCount});

  final guessCount;

  @override
  State<GuessPage> createState() => _GuessPageState();
}

class _GuessPageState extends State<GuessPage> {
  late YoutubePlayerController controller;

  //  Button Style
  final buttonStyle = IconButton.styleFrom(
    backgroundColor: Colors.white,
    shadowColor: Colors.blueGrey.shade600,
    overlayColor: Colors.blueGrey.shade600,
    disabledBackgroundColor: Colors.white24,
    disabledForegroundColor: Colors.white24,
    foregroundColor: Colors.black,
    elevation: 5,
    shape:RoundedRectangleBorder(
      borderRadius: BorderRadiusGeometry.circular(10)
    )
  );

  //  Flags
  String playFlags = "play";
  bool showAnswer = false;
  bool showResult = false;

  //  State Icon
  IconData stateIcon = Icons.not_interested;

  //  Score
  int score = 0;
  int playedCount = 1;

  //  url
  String url = "https://wikiwiki.jp/chunithmwiki/";

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController.fromVideoId(
      videoId: getNextVideo(),
      params: YoutubePlayerParams(
        enableCaption: false,
        interfaceLanguage: "ko"
      ),
      autoPlay: true
    );

    controller.listen((event) {
      if (event.playerState == PlayerState.ended)
      {
        controller.stopVideo().whenComplete(() {
          controller.playVideo();
        });
      }
    });
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black.withAlpha(180),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: showAnswer ? 800 : 0.1,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(controller: controller)
              )
            ),
            if (!showResult) Column(
              children: [
                if (showAnswer) Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "당신의 정답: ${selectedTitle}",
                        style: const TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          decoration: TextDecoration.none
                        )
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () async {
                                final uri = Uri.parse(url + getCurrentTitle());
                            
                                await launchUrl(
                                  uri,
                                  mode: LaunchMode.platformDefault
                                );
                              },
                              child: Text(
                                getCurrentTitle(),
                                style: const TextStyle(
                                  fontSize: 36,
                                  color: Colors.white,
                                  decoration: TextDecoration.none
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: SizedBox(
                        height: 45,
                        child: Center(
                          child: SelectableText(
                            getCurrentArtist(),
                            scrollPhysics: NeverScrollableScrollPhysics(),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              decoration: TextDecoration.none
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Text(
                            getCurrentCategory(),
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              decoration: TextDecoration.none
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: SizedBox(
                        height: 25,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final sheet in getCurrentLevel())
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  "${sheet.difficulty}: ${sheet.level}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    decoration: TextDecoration.none
                                  )
                                ),
                              )
                          ],
                        )
                      ),
                    ),
                  ],
                ) else Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Guess the song!",
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      decoration: TextDecoration.none
                    )
                  ),
                ),
                if (!showAnswer) SizedBox(
                  width: 500,
                  child: Material(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10)
                    ),
                    child: DropdownSearch<String>(
                      selectedItem: selectedTitle,
                      items: (filter, loadProps) {
                        return chunithm_title
                          .where(
                            (item) => item
                              .toLowerCase()
                              .contains(filter.toLowerCase())
                          ).toList();
                      },
                      onSelected: (value) {
                        selectedTitle = value!;
                      },
                      popupProps: PopupProps.menu(
                        showSearchBox: true,
                        searchDelay: Duration(),
                        searchFieldProps: TextFieldProps(
                          containerBuilder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 8,
                                    blurStyle: BlurStyle.outer
                                  )
                                ],
                                borderRadius: BorderRadius.circular(10)
                              ),
                              child: child,
                            );
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                            border: InputBorder.none,
                            hintText: "제목 검색",
                            hintStyle: TextStyle(
                              color: Colors.grey.withAlpha(150)
                            )
                          )
                        ),
                        menuProps: MenuProps(
                          color: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          margin: const EdgeInsets.only(top: 10)
                        ),
                        cacheItems: true,
                        containerBuilder: (context, child) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 8,
                                  blurStyle: BlurStyle.outer
                                )
                              ],
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: child,
                          );
                        },
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10)
                          )
                        )
                      ),
                    ),
                  ),
                ),
                if (!showAnswer) Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: Row(
                    spacing: 10,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: playFlags != "play" ? () {
                          controller.playVideo();
                          setState(() {
                            playFlags = "play";
                          });
                        } : null,
                        style: buttonStyle,
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.play_arrow_rounded,
                            size: 32,
                          )
                        ),
                      ),
                      IconButton(
                        onPressed: playFlags != "pause" ? () {
                          controller.pauseVideo();
                          setState(() {
                            playFlags = "pause";
                          });
                        } : null,
                        style: buttonStyle,
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.pause,
                            size: 32,
                          )
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          controller.stopVideo();
                          setState(() {
                            playFlags = "pause";
                          });
                        },
                        style: buttonStyle,
                        icon: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.stop,
                            size: 32,
                          )
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "현재 점수: $score",
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      decoration: TextDecoration.none
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "진행도: $playedCount / ${widget.guessCount}",
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      decoration: TextDecoration.none
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: !showAnswer ? IconButton(
                    onPressed: () {
                      setState(() {
                        score += selectedTitle == getCurrentTitle() ? 1 : 0;
                        playFlags = "play";
                        showAnswer = true;
                      });
                    },
                    style: buttonStyle,
                    icon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "정답 확인",
                          style: TextStyle(
                            fontSize: 30
                          ),
                        ),
                      )
                    ),
                  ) : IconButton(
                    onPressed: chunithmIndex < playerChunithm.length - 1 ? () {
                      setVideo();
                      setState(() {
                        if (playedCount + 1 > widget.guessCount)
                        {
                          showResult = true;
                          controller.stopVideo();
                        }
                        else
                        {
                          playedCount += 1;
                        }

                        showAnswer = false;
                      });
                    } : null,
                    style: buttonStyle,
                    icon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "다음으로",
                          style: TextStyle(
                            fontSize: 30
                          ),
                        ),
                      )
                    ),
                  ),
                )
              ],
            ),
            if (showResult) Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "당신의 점수는 $score입니다.",
                  style: const TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    decoration: TextDecoration.none
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Text(
                    "으으 질투나 으질",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.none
                    ),
                  ),
                ),
                Row(
                  spacing: 40,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        filteringChunithm();
                        setVideo();
                        controller.playVideo();
                        setState(() {
                          playedCount = 1;
                          score = 0;
                          showResult = false;
                          showAnswer = false;
                        });
                      },
                      style: buttonStyle,
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "주꼬다시",
                            style: TextStyle(
                              fontSize: 30
                            ),
                          ),
                        )
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: buttonStyle,
                      icon: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "돌아가기",
                            style: TextStyle(
                              fontSize: 30
                            ),
                          ),
                        )
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        )
      ),
    );
  }

  void setVideo() async
  {
    try
    {
      setState(() {
        String id = getNextVideo();

        print(chunithmIndex);

        if (id == "none")
        {
          print("영상이 없습니다.");
          return;
        }
        
        controller.loadVideoById(videoId: id);
      });
    }
    catch (e)
    {
      print("영상 재생 실패: $e");
    }
  }
}