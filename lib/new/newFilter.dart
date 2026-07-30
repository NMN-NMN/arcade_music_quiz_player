import 'package:better_quiz_game/new/classes/ResponsiveLayout.dart';
import 'package:better_quiz_game/new/newArtist.dart';
import 'package:better_quiz_game/new/newCategoryFilter.dart';
import 'package:better_quiz_game/new/newLevel.dart';
import 'package:better_quiz_game/new/newQuiz.dart';
import 'package:flutter/material.dart';

class NewFilter extends StatefulWidget {
  const NewFilter({super.key});

  @override
  State<NewFilter> createState() => _NewFilterState();
}

class _NewFilterState extends State<NewFilter> {
  @override
  Widget build(BuildContext context) {
    return Responsivelayout(
      builder: (context, responsive) {
        return Padding(
          padding: const EdgeInsets.only(top: 15),
          child: ScrollbarTheme(
            data: ScrollbarThemeData(
              thumbColor: WidgetStateProperty.resolveWith((state) {
                return Colors.black;
              })
            ),
            child: SingleChildScrollView(
              child: Column(
                spacing: 10,
                children: [
                  NewCategoryFilter(),
                  NewLevel(),
                  NewArtist(),
                  NewQuiz()
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}