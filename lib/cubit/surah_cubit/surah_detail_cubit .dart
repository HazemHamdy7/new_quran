import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:new_quran/model/surah_detail.dart';

class SurahDetailCubit extends Cubit<SurahDetail?> {
  SurahDetailCubit() : super(null);

  final Dio _dio = Dio();

  Future<void> fetchSurahDetail(int surahNumber) async {
    try {
      final response =
          await _dio.get('https://api.alquran.cloud/v1/surah/$surahNumber');
      final surahDetail = SurahDetail.fromJson(response.data["data"]);
      emit(surahDetail);
    } catch (e) {
      print("Error: $e");
      emit(null);
    }
  }
}
