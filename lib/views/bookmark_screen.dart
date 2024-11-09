import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_quran/cubit/surah_cubit/bookmark_cubit.dart';
import 'package:new_quran/helper/to_arabic.dart';
import 'package:new_quran/model/bookmark.dart';
import 'package:new_quran/views/surah_detail_screen.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("ألاشارات المرجعية"),
      ),
      body: BlocBuilder<BookmarkCubit, List<Bookmark>>(
        builder: (context, bookmarks) {
          if (bookmarks.isEmpty) {
            return const Center(child: Text("لا يوجد اشارات مرجعية"));
          }
          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = bookmarks[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(
                      style: BorderStyle.solid,
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  title: Text(
                    "${bookmark.surahName} - أيــة ${bookmark.ayahNumber.toArabicNumbers}",
                  ),
                  subtitle: Text(
                    bookmark.ayahText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  onTap: () {
                    // Navigate to SurahDetailScreen for the specific ayah
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurahDetailScreen(
                          surahNumber: bookmark.surahNumber,
                          initialAyahNumber: bookmark.ayahNumber,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      context.read<BookmarkCubit>().removeBookmark(bookmark);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.indigoAccent,
                            content: Text(
                              'تم حذف الذكرة',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            )),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
