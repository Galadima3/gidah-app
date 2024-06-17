import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gidah/src/features/lodge/domain/house_model.dart';
import 'package:gidah/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:gidah/src/features/search/data/search_service.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchTerm;
  const SearchResultScreen({super.key, required this.searchTerm});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late Future<List<HouseModel>> searchResults;
  @override
  void initState() {
    searchResults = getSearchData();
    super.initState();
  }

  Future<List<HouseModel>> getSearchData() {
    return SearchService().searchHouses(widget.searchTerm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: searchResults,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const CustomScreen(
                  input: CircularProgressIndicator.adaptive());
            case ConnectionState.done:
              if (snapshot.hasError) {
                return CustomScreen(input: Text('Error: ${snapshot.error}'));
              } else {
                // Display your result UI here
                //return Text('Result: ${snapshot.data?[0].name}');
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 90.h,
                      width: 325.w,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  snapshot.data![0].displayPicture),
                              radius: 35.r,
                            ),
                            SizedBox(width: 10.w),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Column(
                                children: [
                                  Text(snapshot.data![0].name),
                                  SizedBox(height: 6.5.h),
                                  Text(snapshot.data![0].address),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

            default:
              return const Text('Unknown connection state');
          }
        },
      ),
    );
  }
}

class ResultTile extends StatelessWidget {
  const ResultTile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
