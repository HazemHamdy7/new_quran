import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_quran/cubit/surah_cubit/bookmark_cubit.dart';
import 'package:new_quran/model/bookmark.dart';
import 'package:new_quran/views/surah_detail_screen.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bookmarks"),
      ),
      body: BlocBuilder<BookmarkCubit, List<Bookmark>>(
        builder: (context, bookmarks) {
          if (bookmarks.isEmpty) {
            return const Center(child: Text("No bookmarks yet."));
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
                    "${bookmark.surahName} - Ayah ${bookmark.ayahNumber}",
                  ),
                  subtitle: Text(
                    bookmark.ayahText,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  onTap: () {
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
                        const SnackBar(content: Text('Bookmark removed!')),
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
