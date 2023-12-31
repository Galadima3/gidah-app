import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gidah/src/features/auth/data/firestore_repository.dart';
import 'package:gidah/src/features/bookmark/data/bookmark_state_notifier.dart';

import 'package:gidah/src/features/lodge/data/house_service.dart';

import 'package:gidah/src/features/lodge/domain/house_model.dart';
import 'package:gidah/src/features/lodge/presentation/screens/house_detail_screen.dart';
import 'package:gidah/src/features/profile/presentation/screens/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeScreen> {
  final searchController = TextEditingController();
  final List<String> choices = [
    'Gandu',
    'Bukan Koto',
    'Akunza',
  ];

  String selectedChoice = 'Gandu';

  void _onChipSelected(String choice) {
    setState(() {
      selectedChoice = choice;
    });
  }

  //final HouseService _houseService = HouseService();

  @override
  Widget build(BuildContext context) {
    final userDetails = ref.watch(userInfoProvider);
    final bookmark = ref.watch(bookmarksStateNotifierProvider);
    return userDetails.when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const ProfileScreen();
                  },
                )),
                child: CircleAvatar(
                  radius: 5,
                  backgroundImage: data?.profileImage == null
                      ? const AssetImage('assets/images/default.png')
                          as ImageProvider<Object>
                      : NetworkImage(data!.profileImage),
                ),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined)),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 9.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    data?.fullName == null
                        ? const Text(
                            'Hello, Unknown',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Text(
                            'Hello, ${data!.fullName}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ],
                ),
              ),
              //Search bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: searchController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(Icons.tune),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 13.5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: choices.map((choice) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(choice),
                          selected: selectedChoice == choice,
                          onSelected: (selected) {
                            _onChipSelected(choice);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(
                height: 300,
                child: Consumer(
                  builder: (context, ref, child) {
                    final houseData = ref.watch(houseProvider);
                    return houseData.when(
                      loading: () => const CircularProgressIndicator.adaptive(),
                      error: (error, stackTrace) =>
                          CustomScreen(input: Text(error.toString())),
                      data: (houses) {
                        List<HouseModel> selectedHouses = houses.where((house) {
                          switch (selectedChoice) {
                            case 'Gandu':
                              return house.location.toLowerCase() == 'gandu';
                            case 'Bukan Koto':
                              return house.location.toLowerCase() ==
                                  'bukan koto';
                            case 'Akunza':
                              return house.location.toLowerCase() == 'akunza';
                            default:
                              return false;
                          }
                        }).toList();

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: selectedHouses.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            HouseModel house = selectedHouses[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        HouseDetailScreen(houseDetails: house),
                                  ));
                                },
                                child: HouseCard(
                                  house: house,
                                  isSelected: house.location.toLowerCase() ==
                                      selectedChoice.toLowerCase(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const CustomScreen(
        input: CircularProgressIndicator.adaptive(),
      ),
      error: (error, stackTrace) => CustomScreen(
        input: Text(error.toString()),
      ),
    );
  }
}

final bookmarkStatusProvider = StateProvider<bool>((ref) => false);

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

class CustomScreen extends ConsumerStatefulWidget {
  final Widget input;
  const CustomScreen({super.key, required this.input});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomScreenState();
}

class _CustomScreenState extends ConsumerState<CustomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.input,
      ),
    );
  }
}
