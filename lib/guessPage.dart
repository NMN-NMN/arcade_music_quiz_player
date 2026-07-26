import 'package:better_quiz_game/chunithm%20data.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class GuessPage extends StatefulWidget {
  const GuessPage({super.key});

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

  //  State Icon
  IconData stateIcon = Icons.not_interested;

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
      color: Colors.blueGrey.shade600,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 1200,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(controller: controller)
              )
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: SizedBox(
                height: 50,
                child: Center(
                  child: SelectableText(
                    getCurrentTitle(),
                    style: const TextStyle(
                      fontSize: 30,
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
                height: 50,
                child: Center(
                  child: Text(
                    getCurrentCategory(),
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      decoration: TextDecoration.none
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
              child: Row(
                spacing: 10,
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void setVideo() async
  {
    try
    {
      setState(() {
        String id = getNextVideo();

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