
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_quran/model/quran_responese.dart';
import 'quran_state.dart';

class QuranCubit extends Cubit<QuranState> {
  QuranCubit() : super(QuranInitial());

  final Dio _dio = Dio();

  Future<void> fetchQuran() async {
    emit(QuranLoading());
    try {
      final response =
          await _dio.get('https://api.alquran.cloud/v1/quran/ar.asad');

      // final quranResponse =
      final quranResponse = QuranResponse.fromJson(response.data);
      emit(QuranLoaded(quranResponse.data.surahs));
    } catch (e) {
      emit(QuranError("Failed to load Quran: ${e.toString()}"));
    }
  }
}
