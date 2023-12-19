import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/bookmark/data/bookmark_state_notifier.dart';
import 'package:gidah/src/features/lodge/presentation/screens/house_detail_screen.dart';

class BookmarkScreen extends ConsumerWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookmark = ref.watch(bookmarksStateNotifierProvider);
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
        centerTitle: true,
      ),
      body: bookmark.isEmpty
          ? Center(
              child: SizedBox(
                height: 200,
                child: Image.network(
                    "https://static-00.iconduck.com/assets.00/zzz-emoji-2048x1609-37dbjn9b.png"),
              ),
            )
          : SizedBox(
              height: height * 0.75,
              child: ListView.builder(
                itemCount: bookmark.length,
                itemBuilder: (context, index) {
                  final house = bookmark[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 8),
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) {
                          return HouseDetailScreen(houseDetails: house);
                        },
                      )),
                      child: Container(
                        height: 90,
                        width: 325,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //house image
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(house.displayPicture),
                                radius: 35,
                              ),

                              //house details
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18.0),
                                child: Column(
                                  children: [
                                    Text(house.name),
                                    const SizedBox(
                                      height: 6.5,
                                    ),
                                    Text(house.address),
                                  ],
                                ),
                              ),

                              //bookmark widget
                              IconButton(
                                  onPressed: () {
                                    ref
                                        .read(bookmarksStateNotifierProvider
                                            .notifier)
                                        .toggleBookmark(house);
                                  },
                                  icon: const Icon(
                                    Icons.bookmark_added,
                                    color: Colors.black,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
