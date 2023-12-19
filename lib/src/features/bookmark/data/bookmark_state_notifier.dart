import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/lodge/domain/house_model.dart';

class BookmarkStateNotifier extends StateNotifier<List<HouseModel>> {
  BookmarkStateNotifier() : super([]);

  void addBookmark(HouseModel house) {
    state = [...state, house];
  }

  void removeBookmark(HouseModel house) {
    state = state.where((element) => element != house).toList();
  }

  void clearBookmarks() {
    state = [];
  }

  void toggleBookmark(HouseModel house) {
    if (state.contains(house)) {
      state = state.where((element) => element != house).toList();
    } else {
      state = [...state, house];
    }
  }

  bool isBookmarked(HouseModel house) {
    return state.contains(house);
  }
}

final bookmarksStateNotifierProvider =
    StateNotifierProvider<BookmarkStateNotifier, List<HouseModel>>((ref) {
  return BookmarkStateNotifier();
});
