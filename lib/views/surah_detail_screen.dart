import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quran/constants/assets.dart';
import 'package:new_quran/cubit/surah_cubit/bookmark_cubit.dart';
import 'package:new_quran/cubit/surah_cubit/surah_detail_cubit.dart';
import 'package:new_quran/model/bookmark.dart';
import 'package:new_quran/model/surah_detail.dart';
import 'package:new_quran/views/bookmark_screen.dart';
import 'package:new_quran/widget/custom_appbar.dart';

class SurahDetailScreen extends StatefulWidget {
  final int surahNumber;
  final int? initialAyahNumber;

  const SurahDetailScreen({
    super.key,
    required this.surahNumber,
    this.initialAyahNumber,
  });

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialAyahNumber != null) {
        _scrollToAyah(widget.initialAyahNumber!);
      }
    });
  }

  void _scrollToAyah(int ayahNumber) {
    final targetIndex = ayahNumber - 1;
    const ayahHeight = 80.0;
    final targetOffset = targetIndex * ayahHeight;

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.black.withOpacity(0.05),
            image: const DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(
                  'assets/image/zikrbkg.png',
                ))),
        child: BlocProvider(
          create: (context) =>
              SurahDetailCubit()..fetchSurahDetail(widget.surahNumber),
          child: BlocBuilder<SurahDetailCubit, SurahDetail?>(
            builder: (context, surahDetail) {
              if (surahDetail == null) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                controller: _scrollController,
                itemCount: surahDetail.ayahs.length + 1,
                itemBuilder: (context, index) {
                  // Display the Basmala if the surah is not Al-Fatiha or At-Tawba
                  if (index == 0 &&
                      widget.surahNumber != 1 &&
                      widget.surahNumber != 9) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      child: Center(
                          child: Image(
                        image: AssetImage(Assets.imageBasmala),
                      )),
                    );
                  }

                  // Offset ayah index by 1 if the Basmala is shown
                  final ayahIndex =
                      (widget.surahNumber != 1 && widget.surahNumber != 9)
                          ? index - 1
                          : index;
                  final ayah = surahDetail.ayahs[ayahIndex];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    child: GestureDetector(
                        onLongPress: () {
                          showMenu(
                            context: context,
                            position:
                                const RelativeRect.fromLTRB(100, 100, 100, 100),
                            items: [
                              const PopupMenuItem(
                                value: 'bookmark',
                                child: Row(
                                  children: [
                                    Icon(Icons.bookmark),
                                    SizedBox(width: 8),
                                    Text('Bookmark'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                  value: 'share',
                                  child: Row(
                                    children: [
                                      Icon(Icons.share_rounded),
                                      SizedBox(width: 8),
                                      Text('share'),
                                    ],
                                  )),
                              const PopupMenuItem(
                                  value: 'send',
                                  child: Row(
                                    children: [
                                      Icon(Icons.send_rounded),
                                      SizedBox(width: 8),
                                      Text('send'),
                                    ],
                                  )),
                            ],
                          ).then((value) {
                            if (value == 'bookmark') {
                              final bookmark = Bookmark(
                                surahNumber: surahDetail.number,
                                ayahNumber: ayah.numberInSurah,
                                surahName: surahDetail.name,
                                ayahText: ayah.text,
                              );

                              context
                                  .read<BookmarkCubit>()
                                  .addBookmark(bookmark);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Ayah bookmarked!')),
                              );
                            }
                          });
                        },
                        child: Container(
                          child: ListTile(
                            title: Text(
                              ayah.text,
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: GoogleFonts.amiriQuran(fontSize: 20),
                            ),
                            leading: Stack(
                              children: [
                                SvgPicture.asset(
                                  'assets/image/nomor-surah.svg',
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  height: 36,
                                  width: 36,
                                  child: Center(
                                    child: Text(
                                      ayah.numberInSurah.toString(),
                                      style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
