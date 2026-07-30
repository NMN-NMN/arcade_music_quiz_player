import 'package:better_quiz_game/chunithm%20data.dart';
import 'package:better_quiz_game/new/classes/ResponsiveLayout.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class NewArtist extends StatefulWidget {
  const NewArtist({super.key});

  @override
  State<NewArtist> createState() => _NewArtistState();
}

class _NewArtistState extends State<NewArtist> {
  @override
  Widget build(BuildContext context) {
    return Responsivelayout(
      builder: (context, responsive) {
        final artistWidget =
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: responsive.width(1000, min: 500, max: 1100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 255, 249, 192)
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
                  showSelectedItems: true,
                  searchDelay: Duration(),
                  searchFieldProps: TextFieldProps(
                    containerBuilder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 255, 249, 192)
                        ),
                        child: child,
                      );
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                      border: InputBorder.none,
                      hintText: "아티스트 검색",
                      hintStyle: TextStyle(
                        color: const Color.fromARGB(110, 121, 82, 32)
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
                      height: responsive.isMobile ? 280 : 500,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 255, 249, 192)
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
          );

        return Column(
          spacing: 10,
          children: [
            Text(
              "아티스트 검색",
              style: TextStyle(
                fontSize: responsive.isMobile ? 20 : 30
              ),
            ),
            artistWidget
          ],
        );
      },
    );
  }
}