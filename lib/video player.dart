import 'package:better_quiz_game/chunithm%20data.dart';
import 'package:better_quiz_game/new/classes/ResponsiveLayout.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

enum EndedType {
  NONE,
  LOOPONE,
  LOOPALL,
  AUTONEXT
}

class VideoPlayer extends StatefulWidget {
  VideoPlayer({super.key});

  @override
  State<VideoPlayer> createState() => VideoPlayerState();
}

class VideoPlayerState extends State<VideoPlayer> {
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
  EndedType endedType = EndedType.NONE;

  //  State Icon
  IconData stateIcon = Icons.not_interested;

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
        if (endedType == EndedType.LOOPONE)
        {
          controller.stopVideo().whenComplete(() {
            controller.playVideo();
          });
        }
        else if (endedType == EndedType.LOOPALL || endedType == EndedType.AUTONEXT)
        {
          setVideo();
          setState(() {
            playFlags = "play";
          });
        }
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
    return Responsivelayout(
      builder: (context, responsive) {
        final playerBar = responsive.isMobile ? Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: 20,
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
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 24,
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
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.pause,
                      size: 24,
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
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.stop,
                      size: 24,
                    )
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              spacing: 45,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: chunithmIndex > 0 ? () {
                    setVideo(isNext: false);
                    setState(() {
                      playFlags = "play";
                    });
                  } : null,
                  style: buttonStyle,
                  icon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.skip_previous_rounded,
                      size: 24,
                    )
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (endedType == EndedType.NONE)
                      {
                        endedType = EndedType.LOOPONE;
                        stateIcon = Icons.repeat_one_rounded;
                      }
                      else if (endedType == EndedType.LOOPONE)
                      {
                        endedType = EndedType.LOOPALL;
                        stateIcon = Icons.repeat_rounded;
                      }
                      else if (endedType == EndedType.LOOPALL)
                      {
                        endedType = EndedType.AUTONEXT;
                        stateIcon = Icons.skip_next_rounded;
                      }
                      else
                      {
                        endedType = EndedType.NONE;
                        stateIcon = Icons.not_interested_rounded;
                      }
                    });
                  },
                  style: buttonStyle,
                  icon: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Icon(
                      stateIcon,
                      size: 24,
                    )
                  ),
                ),
                IconButton(
                  onPressed: chunithmIndex < playerChunithm.length - 1 ? () {
                    setVideo();
                    setState(() {
                      playFlags = "play";
                    });
                  } : null,
                  style: buttonStyle,
                  icon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.skip_next_rounded,
                      size: 24,
                    )
                  ),
                )
              ],
            )
          ],
        ) : Row(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: chunithmIndex > 0 ? () {
                setVideo(isNext: false);
                setState(() {
                  playFlags = "play";
                });
              } : null,
              style: buttonStyle,
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.skip_previous_rounded,
                  size: 32,
                )
              ),
            ),
            SizedBox(width: 20,),
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
            ),
            SizedBox(width: 20,),
            IconButton(
              onPressed: chunithmIndex < playerChunithm.length - 1 ? () {
                setVideo();
                setState(() {
                  playFlags = "play";
                });
              } : null,
              style: buttonStyle,
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.skip_next_rounded,
                  size: 32,
                )
              ),
            ),
            SizedBox(width: 20,),
            IconButton(
              onPressed: () {
                setState(() {
                  if (endedType == EndedType.NONE)
                  {
                    endedType = EndedType.LOOPONE;
                    stateIcon = Icons.repeat_one_rounded;
                  }
                  else if (endedType == EndedType.LOOPONE)
                  {
                    endedType = EndedType.LOOPALL;
                    stateIcon = Icons.repeat_rounded;
                  }
                  else if (endedType == EndedType.LOOPALL)
                  {
                    endedType = EndedType.AUTONEXT;
                    stateIcon = Icons.skip_next_rounded;
                  }
                  else
                  {
                    endedType = EndedType.NONE;
                    stateIcon = Icons.not_interested_rounded;
                  }
                });
              },
              style: buttonStyle,
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  stateIcon,
                  size: 32,
                )
              ),
            )
          ],
        );

        return ColoredBox(
          color: Colors.black.withAlpha(180),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: responsive.isMobile ? 400 : 1000,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(controller: controller)
                  )
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: SizedBox(
                    height: responsive.isMobile ? 30 : 50,
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
                            style: TextStyle(
                              fontSize: responsive.isMobile ? 20 : 36,
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
                    height: responsive.isMobile ? 20 : 50,
                    child: Center(
                      child: SelectableText(
                        getCurrentArtist(),
                        style: TextStyle(
                          fontSize: responsive.isMobile ? 14 : 22,
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
                    height: responsive.isMobile ? 30 : 50,
                    child: Center(
                      child: Text(
                        getCurrentCategory(),
                        style: TextStyle(
                          fontSize: responsive.isMobile ? 18 : 26,
                          color: Colors.white,
                          decoration: TextDecoration.none
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  child: SizedBox(
                    height: 50,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 5,
                      children: [
                        for (final sheet in getCurrentLevel())
                          Text(
                            "${sheet.difficulty}: ${sheet.level}",
                            style: TextStyle(
                              fontSize: responsive.isMobile ? 16 : 24,
                              color: Colors.white,
                              decoration: TextDecoration.none
                            )
                          )
                      ]
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                  child: playerBar
                )
              ],
            ),
          ),
        );
      }
    );
  }

  void setVideo({bool isNext = true}) async
  {
    try
    {
      setState(() {
        String id = isNext ? getNextVideo() : getPreviousVideo();

        if (id == "none")
        {
          if (endedType == EndedType.LOOPALL)
          {
            if (isNext)
            {
              chunithmIndex = 0;
              id = getCurrentVideoId();
            }
            else
            {
              chunithmIndex = playerChunithm.length - 1;
              id = getCurrentVideoId();
            }
          }
          else
          {
            print("${isNext ? "다음" : "이전"} 영상이 없습니다.");
            return;
          }
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