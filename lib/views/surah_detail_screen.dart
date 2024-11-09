import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_quran/cubit/surah_cubit/bookmark_cubit.dart';
import 'package:new_quran/cubit/surah_cubit/surah_detail_cubit.dart';
import 'package:new_quran/helper/to_arabic.dart';
import 'package:new_quran/model/bookmark.dart';
import 'package:new_quran/model/quran_responese.dart';
import 'package:new_quran/model/surah_detail.dart';
import 'package:new_quran/views/bookmark_screen.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  late ItemScrollController _itemScrollController;
  bool view = true;
  String surahName = "";

  @override
  void initState() {
    super.initState();
    _itemScrollController = ItemScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialAyahNumber != null) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _scrollToAyah(widget.initialAyahNumber!);
        });
      }
    });
  }

  void _scrollToAyah(int ayahNumber) {
    _itemScrollController.scrollTo(
      index: ayahNumber - 1,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: Tooltip(
          message: 'Toggle View',
          child: IconButton(
            icon: const Icon(Icons.chrome_reader_mode),
            onPressed: () {
              setState(() {
                view = !view;
              });
            },
          ),
        ),
        title: Text(
          surahName.isNotEmpty ? surahName : "...جاري التحميل",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const BookmarkScreen()),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (context) =>
            SurahDetailCubit()..fetchSurahDetail(widget.surahNumber),
        child: BlocBuilder<SurahDetailCubit, SurahDetail?>(
          builder: (context, surahDetail) {
            if (surahDetail == null) {
              return const Center(child: CircularProgressIndicator());
            }

            if (surahName.isEmpty) {
              // Using Future.microtask to avoid setState issues during build
              Future.microtask(() {
                setState(() {
                  surahName = surahDetail.name;
                });
              });
            }

            return view
                ? _buildListView(surahDetail)
                : _buildFullView(surahDetail);
          },
        ),
      ),
    );
  }

  Widget _buildListView(SurahDetail surahDetail) {
    return ScrollablePositionedList.builder(
      itemScrollController: _itemScrollController,
      itemCount: surahDetail.ayahs.length + 1,
      itemBuilder: (context, index) {
        if (index == 0 && widget.surahNumber != -1 && widget.surahNumber != 9) {
          return const RetunBasmala();
        }

        final ayahIndex = widget.surahNumber != -1 && widget.surahNumber != 9
            ? index - 1
            : index;
        final ayah = surahDetail.ayahs[ayahIndex];

        return ListTile(
          title: Text(
            ayah.text,
            textAlign: TextAlign.right,
            style: GoogleFonts.amiri(fontSize: 20),
          ),
          leading: Text(
            style: const TextStyle(fontFamily: 'me_quran', fontSize: 16),
            "\uFD3E${(ayahIndex + 1).toString().toArabicNumbers}\uFD3F",
          ),
          onTap: () => _onLongPress(context, surahDetail, ayah),
        );
      },
    );
  }

  Widget _buildFullView(SurahDetail surahDetail) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: surahDetail.ayahs.map((ayah) {
            return RichText(
              textDirection: TextDirection.rtl,
              text: TextSpan(
                style: GoogleFonts.amiri(fontSize: 22, color: Colors.black),
                children: [
                  TextSpan(text: ayah.text),
                  TextSpan(
                    text:
                        '\uFD3F${ayah.numberInSurah.toString().toArabicNumbers}\uFD3E', // Ayah number without space
                    style:
                        const TextStyle(fontFamily: 'me_quran', fontSize: 16),
                  ),
                  // Ayah text
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _onLongPress(
      BuildContext context, SurahDetail surahDetail, AyahDetail ayah) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                trailing: const Icon(Icons.bookmark),
                title: const Text(
                  textAlign: TextAlign.end,
                  'أضافة آشاره مرجعية',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onTap: () {
                  final bookmark = Bookmark(
                    surahNumber: surahDetail.number,
                    ayahNumber: ayah.numberInSurah,
                    surahName: surahDetail.name,
                    ayahText: ayah.text,
                  );

                  context.read<BookmarkCubit>().addBookmark(bookmark);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        backgroundColor: Colors.indigoAccent,
                        content: Text(
                          'تمت اضافة الآية المرجعية للمفضلة',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        )),
                  );
                  Navigator.pop(context); // Close the modal sheet
                },
              ),
              ListTile(
                trailing: const Icon(Icons.menu_book_sharp),
                title: const Text(
                  textAlign: TextAlign.end,
                  'تفسير',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onTap: () {
                  // Add bookmark
                },
              ),
              ListTile(
                trailing: const Icon(Icons.music_note),
                title: const Text(
                  textAlign: TextAlign.end,
                  'استماع',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onTap: () {},
              ),
              // Add more options here if needed
            ],
          ),
        );
      },
    );
  }
}

class RetunBasmala extends StatelessWidget {
  const RetunBasmala({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'بسم الله الرحمن الرحيم',
        style: GoogleFonts.amiriQuran(fontSize: 30),
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
