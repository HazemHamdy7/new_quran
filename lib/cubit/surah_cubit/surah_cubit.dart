import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:new_quran/model/quran_responese.dart';

class SurahCubit extends Cubit<List<Surah>> {
  SurahCubit() : super([]);

  final Dio _dio = Dio();

  Future<void> fetchSurahs() async {
    try {
      final response = await _dio.get('https://api.alquran.cloud/v1/surah');

      if (response.data is Map<String, dynamic> &&
          response.data['data'] != null) {
        final List surahData = response.data['data'];
        final surahs = surahData.map((json) => Surah.fromJson(json)).toList();
        emit(surahs);
      } else {
        throw Exception('Unexpected JSON structure');
      }
    } catch (e) {
      log("Error fetching surahs: $e");
      emit([]); // Emit an empty list on error
    }
  }
}
