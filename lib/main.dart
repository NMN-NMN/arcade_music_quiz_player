import 'package:better_quiz_game/chunithm%20data.dart';
import 'package:better_quiz_game/Mainpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  //  Load Flags
  bool hasDoneLoadFonts = false;
  bool hasDoneLoadChunithmInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<dynamic> loadData() async {
    return await Future.wait([
      loadFonts(),
      loadChunithmInit()
    ]);
  }

  Future<void> loadFonts() async {
    if (!hasDoneLoadFonts)
    {
      await GoogleFonts.pendingFonts([
        GoogleFonts.nanumGothic(),
        GoogleFonts.mPlus1p()
      ]);

      hasDoneLoadFonts = true;
    }
  }

  Future<void> loadChunithmInit() async {
    if (!hasDoneLoadChunithmInit)
    {
      await init_Chunithm();

      hasDoneLoadChunithmInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: FutureBuilder(
          future: loadData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
            {
              return Center(
                child: Text(
                  "Loading...",
                  style: TextStyle(
                    fontSize: 20
                  )
                ),
              );
            }
            return Mainpage();
          }
        )
      ),
    );
  }
}