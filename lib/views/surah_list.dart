import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_quran/cubit/surah_cubit/surah_cubit.dart';
import 'package:new_quran/model/quran_responese.dart';
import 'package:new_quran/views/surah_detail_screen.dart';
import 'package:new_quran/widget/arabic_surah_number.dart';
import 'package:new_quran/widget/custom_appbar.dart';

class SurahListPage extends StatelessWidget {
  const SurahListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context),
      body: BlocProvider(
        create: (context) => SurahCubit()..fetchSurahs(),
        child: BlocBuilder<SurahCubit, List<Surah>>(
          builder: (context, surahs) {
            if (surahs.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                itemCount: surahs.length,
                itemBuilder: (context, index) {
                  final surah = surahs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 3.0, horizontal: 8.0),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          )),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ArabicSurahNumber(i: index),
                          Text(textAlign: TextAlign.end, surah.name),
                        ],
                      ),
                      subtitle: Text(
                          textAlign: TextAlign.end,
                          '${surah.revelationType} - أية: ${surah.ayahsCount}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SurahDetailScreen(
                                    surahNumber: index + 1,
                                    initialAyahNumber: index,
                                  )),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
