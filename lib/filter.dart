import 'package:better_quiz_game/chunithm%20data.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterWidget extends StatefulWidget {
  const FilterWidget({super.key, required this.shadowColorAnimation});

  final Animation<Color?> shadowColorAnimation;

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  //  Fonts
  final subTitleFont = GoogleFonts.nanumGothic(
    fontSize: 32
  );
  final subTitleFont2 = GoogleFonts.nanumGothic(
    fontSize: 26
  );
  final subTitleFont3 = GoogleFonts.nanumGothic(
    fontSize: 20
  );
  final buttonFont = GoogleFonts.nanumGothic(
    color: Colors.black,
    fontSize: 22
  );
  final checkboxFont = GoogleFonts.mPlus1p(
    color: Colors.black,
    fontSize: 22
  );
  final dropdownFont = GoogleFonts.mPlus1p(
    color: Colors.black,
    fontSize: 18
  );

  @override
  void initState() {
    super.initState();
    filteringChunithm();
  }

  Widget getLevel(double value, bool isStart)
  {
    final integer = value.floor();
    final hasPlus = (value - integer) >= 0.5;

    return SizedBox(
      width: 80,
      child: Row(
        mainAxisAlignment: isStart ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Text(
            integer.toString(),
            style: subTitleFont2,
          ),
          SizedBox(
            width: 20,
            child: Text(
              hasPlus ? "+" : "",
              style: subTitleFont2,
              textAlign: TextAlign.left,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: AnimatedBuilder(
        animation: widget.shadowColorAnimation,
        builder: (context, child) {
          return Container(
            width: 800,
            decoration: BoxDecoration(
              color: const Color.fromARGB(220, 255, 255, 255),
              boxShadow: [
                BoxShadow(
                  color: widget.shadowColorAnimation.value!,
                  blurRadius: 15,
                  spreadRadius: 0,
                  blurStyle: BlurStyle.outer
                )
              ],
              borderRadius: BorderRadius.circular(10)
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(
                      "카테고리",
                      style: subTitleFont,
                    ),
                  ),
                  Container(
                    width: 720,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(200, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: widget.shadowColorAnimation.value!.withAlpha(150),
                          blurRadius: 8,
                          blurStyle: BlurStyle.outer
                        )
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                      child: Wrap(
                        spacing: 20,
                        runSpacing: 12,
                        children: categories.map((category) {
                          return Row(
                            mainAxisSize: .min,
                            children: [
                              Checkbox(
                                value: checkedCategories[category],
                                onChanged: (value) {
                                  setState(() {
                                    checkedCategories[category] = value ?? false;
                                  });
                                  
                                  filteringChunithm();
                                },
                                fillColor: WidgetStateProperty.resolveWith((states) {
                                  if (states.contains(WidgetState.selected))
                                  {
                                    return widget.shadowColorAnimation.value!;
                                  }
              
                                  return Colors.white;
                                }),
                                overlayColor: WidgetStateProperty.resolveWith((states) {
                                  return widget.shadowColorAnimation.value!.withAlpha(20);
                                }),
                              ),
                              Text(category, style: checkboxFont)
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "보면상수",
                      style: subTitleFont
                    ),
                  ),
                  Container(
                    width: 720,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(200, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: widget.shadowColorAnimation.value!.withAlpha(150),
                          blurRadius: 8,
                          blurStyle: BlurStyle.outer
                        )
                      ]
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                            child: Wrap(
                              spacing: 20,
                              runSpacing: 12,
                              children: levels.map((level) {
                                return Row(
                                  mainAxisSize: .min,
                                  children: [
                                    Checkbox(
                                      value: checkedLevels[level],
                                      onChanged: (value) {
                                        setState(() {
                                          checkedLevels[level] = value ?? false;
                                        });

                                        filteringChunithm();
                                      },
                                      fillColor: WidgetStateProperty.resolveWith((states) {
                                        if (states.contains(WidgetState.selected))
                                        {
                                          return widget.shadowColorAnimation.value!;
                                        }
                    
                                        return Colors.white;
                                      }),
                                      overlayColor: WidgetStateProperty.resolveWith((states) {
                                        return widget.shadowColorAnimation.value!.withAlpha(20);
                                      }),
                                    ),
                                    Text(level, style: checkboxFont)
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                getLevel(rangeValues.start, true),
                                Text(
                                  " ~ ",
                                  style: subTitleFont2
                                ),
                                getLevel(rangeValues.end, false)
                              ],
                            )
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    rangeValues.start.toString(),
                                    style: subTitleFont3,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                Text(
                                  " ~ ",
                                  style: subTitleFont3
                                ),
                                SizedBox(
                                  width: 50,
                                  child: Text(
                                    rangeValues.end.toString(),
                                    style: subTitleFont3,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ],
                            )
                          ),
                          SizedBox(
                            width: 500,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                showValueIndicator: ShowValueIndicator.never,
                                activeTrackColor: widget.shadowColorAnimation.value!,
                                inactiveTrackColor: widget.shadowColorAnimation.value!.withAlpha(60),
                                overlayColor: widget.shadowColorAnimation.value!.withAlpha(20),
                                thumbColor: widget.shadowColorAnimation.value!
                              ),
                              child: RangeSlider(
                                values: rangeValues,
                                min: 1,
                                max: 16,
                                divisions: 150,
                                onChanged: (value) {
                                  setState(() {
                                    rangeValues = RangeValues(
                                      (value.start * 10).round() / 10,
                                      (value.end * 10).round() / 10
                                    );
                                  });

                                  filteringChunithm();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      "아티스트",
                      style: subTitleFont
                    ),
                  ),
                  Container(
                    width: 500,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(200, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: widget.shadowColorAnimation.value!.withAlpha(150),
                          blurRadius: 8,
                          blurStyle: BlurStyle.outer
                        )
                      ]
                    ),
                    child: DropdownSearch<String>.multiSelection(
                      selectedItems: selectedArtists,
                      items: (filter, loadProps) {
                        return chunithm_artist
                          .where(
                            (item) => item
                              .toLowerCase()
                              .contains(filter.toLowerCase())
                          ).toList();
                      },
                      onSelected: (value) {
                        selectedArtists.clear();
                        selectedArtists = value;

                        filteringChunithm();
                      },
                      popupProps: MultiSelectionPopupProps.menu(
                        showSearchBox: true,
                        searchDelay: Duration(),
                        searchFieldProps: TextFieldProps(
                          containerBuilder: (context, child) {
                            return Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.shadowColorAnimation.value!.withAlpha(150),
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
                            hintText: "아티스트 검색",
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
                                  color: widget.shadowColorAnimation.value!.withAlpha(150),
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
                            borderSide: BorderSide(color: Colors.transparent)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent)
                          )
                        )
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Row(
                    spacing: 30,
                    mainAxisSize: .min,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              "맞출 문제 개수",
                              style: subTitleFont
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Container(
                              width: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.shadowColorAnimation.value!.withAlpha(150),
                                    blurRadius: 8,
                                    blurStyle: BlurStyle.outer
                                  )
                                ]
                              ),
                              child: TextField(
                                controller: textfieldController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]*'),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  hintText: "ex) 10, 20, 30...",
                                  filled: true,
                                  fillColor: Colors.white,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                  )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Text(
                              "필터링된 노래 갯수",
                              style: subTitleFont
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: filteredCount,
                            builder: (context, value, child) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  value.toString(),
                                  style: subTitleFont
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}