import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/bookmark/data/bookmark_state_notifier.dart';
import 'package:gidah/src/features/lodge/domain/house_model.dart';

class HouseCard extends ConsumerWidget {
  final HouseModel house;
  final bool isSelected;

  const HouseCard({
    super.key,
    required this.house,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          height: 250,
          width: 215,
          decoration: ShapeDecoration(
            image: DecorationImage(
              image: NetworkImage(house.displayPicture),
              fit: BoxFit.cover,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Ratings
                Container(
                  width: 53.5,
                  height: 25,
                  decoration: ShapeDecoration(
                    color: isSelected ? const Color(0xFF1AB65C) : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.50),
                    ),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.star,
                          size: 18.5,
                          color: Colors.amber,
                        ),
                        Text(
                          house.rating.toString(),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Bookmark
                IconButton(
                  onPressed: () {
                    // Toggle bookmark status only for the current house
                    ref
                        .read(bookmarksStateNotifierProvider.notifier)
                        .toggleBookmark(house);
                  },
                  icon: ref
                          .read(bookmarksStateNotifierProvider.notifier)
                          .isBookmarked(house)
                      ? const Icon(
                          Icons.bookmark_added,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.bookmark_border,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                ),
              ],
            ),
          ),
        ),
        Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name
            Text(
              house.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        )
      ],
    );
  }
}