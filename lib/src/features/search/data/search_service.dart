import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/lodge/domain/house_model.dart';

class SearchService {
  Future<List<HouseModel>> _loadHouses() async {
    try {
      final String jsonString =
          await rootBundle.loadString('asset/file/houses.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => HouseModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("Failed to load houses: $e");
    }
  }

  Future<List<HouseModel>> getHouses() async {
    try {
      final List<HouseModel> houses = await _loadHouses();
      //print(houses[0].location);
      return houses;
    } catch (e) {
      throw Exception("Error getting houses: $e");
    }
  }

  Future<List<HouseModel>> searchHouses(String searchQuery) async {
    try {
      final List<HouseModel> houses = await _loadHouses();
      final lowercaseQuery = searchQuery.toLowerCase().split(' ');

      return houses.where((house) {
        final lowercaseName = house.name.toLowerCase();
        for (final word in lowercaseQuery) {
          if (!lowercaseName.contains(word)) {
            return false;
          }
        }
        return true;
      }).toList();
    } catch (e) {
      throw Exception("Error getting houses: $e");
    }
  }
}

final searchServiceProvider = Provider<SearchService>((ref) {
  return SearchService();
});

// final houseProvider = FutureProvider<List<HouseModel>>((ref) async {
//   final houseService = ref.read(houseServiceProvider);
//   return await houseService.getHouses();
// });

final searchProvider =
    FutureProvider.family<List<HouseModel>, String>((ref, searchQuery) async {
  final searchService = ref.read(searchServiceProvider);
  return await searchService.searchHouses(searchQuery);
});
