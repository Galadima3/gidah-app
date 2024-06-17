import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gidah/src/features/lodge/domain/house_model.dart';

import 'package:gidah/src/features/lodge/presentation/screens/house_detail_screen.dart';
import 'package:gidah/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:gidah/src/features/search/data/search_service.dart';
import 'package:gidah/src/features/search/presentation/search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();
  bool searchStatus = false;
  Future onTileTappe({
    required String searchTerm,
  }) async {
    // print(searchTerm);
    // final searchResult = ref.read(searchProvider(searchTerm));
    // print(searchResult.value?[0].name);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return SearchResultScreen(searchTerm: searchTerm);
      },
    ));
  }

  Future<List<HouseModel>> getSearchData() async {
    Future.delayed(const Duration(milliseconds: 2500));
    return SearchService().searchHouses(searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 40.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30),
            child: Consumer(
              builder: (context, ref, child) {
                //final results = ref.watch(searchProvider);
                return TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: searchController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Search for available houses...',
                      // prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchStatus
                          ? IconButton(
                              onPressed: () {
                                searchController.clear();
                                setState(() {
                                  searchStatus = false;
                                });
                              },
                              icon: const Icon(Icons.cancel))
                          : const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onFieldSubmitted: (value) {
                      setState(() {
                        searchStatus = true;
                      });
                    });
              },
            ),
          ),
          SizedBox(
            height: 300.h,
            width: double.infinity.w,
            child: Visibility(
              visible: searchStatus,
              child: FutureBuilder(
                future: getSearchData(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return const CustomScreen(
                          input: CircularProgressIndicator.adaptive());
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return CustomScreen(
                            input: Text('Error: ${snapshot.error}'));
                      } else {
                        // Display your result UI here
                        //return Text('Result: ${snapshot.data?[0].name}');
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            final house = snapshot.data![index];
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) {
                                      return HouseDetailScreen(
                                          houseDetails: house);
                                    },
                                  )),
                                  child: Container(
                                    height: 90.h,
                                    width: 325.w,
                                    decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                house.displayPicture),
                                            radius: 35.r,
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 18.0),
                                            child: Column(
                                              children: [
                                                Text(house.name),
                                                SizedBox(
                                                  height: 6.5.h,
                                                ),
                                                Text(house.address),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }

                    default:
                      return const Center(
                          child: Text('Unknown connection state'));
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
