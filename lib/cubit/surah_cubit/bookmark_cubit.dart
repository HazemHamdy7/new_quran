import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:new_quran/model/bookmark.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkCubit extends Cubit<List<Bookmark>> {
  BookmarkCubit() : super([]);

  void loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getStringList('bookmarks') ?? [];
    emit(savedData.map((data) => Bookmark.fromJson(jsonDecode(data))).toList());
  }

  void addBookmark(Bookmark bookmark) {
    final updatedBookmarks = List<Bookmark>.from(state)..add(bookmark);
    emit(updatedBookmarks);
  }
  // void addBookmark(Bookmark bookmark) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final currentBookmarks = state;
  //   final updatedBookmarks = [...currentBookmarks, bookmark];

  //   prefs.setStringList(
  //     'bookmarks',
  //     updatedBookmarks.map((b) => jsonEncode(b.toJson())).toList(),
  //   );

  //   emit(updatedBookmarks);
  // }

  void removeBookmark(Bookmark bookmark) {
    final updatedBookmarks = List<Bookmark>.from(state)
      ..removeWhere((b) =>
          b.surahNumber == bookmark.surahNumber &&
          b.ayahNumber == bookmark.ayahNumber);
    emit(updatedBookmarks);
  }
  // void removeBookmark(Bookmark bookmark) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final updatedBookmarks = state.where((b) => b != bookmark).toList();

  //   prefs.setStringList(
  //     'bookmarks',
  //     updatedBookmarks.map((b) => jsonEncode(b.toJson())).toList(),
  //   );

  //   emit(updatedBookmarks);
  // }
}
