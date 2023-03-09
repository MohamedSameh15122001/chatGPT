import 'dart:convert';

import 'package:chat_gpt/shared/main_cubit/main_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());

  static MainCubit get(context) => BlocProvider.of(context);

  var answer = {};
  askMeAnything({question = 'what is the capital of egypt'}) async {
    answer = {};
    emit(LoadingAskMeAnythingState());
    var url = Uri.parse('https://you-chat-gpt.p.rapidapi.com/');

    var headers = {
      'content-type': 'application/json',
      'X-RapidAPI-Key': 'f806056228msh1b0793655feb2bfp13396ajsnb8b056de3ed4',
      'X-RapidAPI-Host': 'you-chat-gpt.p.rapidapi.com',
    };

    var body = jsonEncode({"question": question, "max_response_time": 20});

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      answer = jsonDecode(response.body);

      emit(SuccessAskMeAnythingState());
    } else {
      emit(ErrorAskMeAnythingState());
      print('Failed to post data. Error code: ${response.statusCode}');
    }
  }

  var scodexAnswer = {};
  scodexAI({prompt = 'Explain and analysis fight club'}) async {
    scodexAnswer = {};
    emit(LoadingAskMeAnythingState());
    var url = Uri.parse('https://scodex-api.p.rapidapi.com/');

    var headers = {
      'content-type': 'application/json',
      'Content-Type': 'application/json',
      'X-RapidAPI-Key': 'f806056228msh1b0793655feb2bfp13396ajsnb8b056de3ed4',
      'X-RapidAPI-Host': 'scodex-api.p.rapidapi.com',
    };

    var body = jsonEncode({"prompt": prompt});

    var response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      scodexAnswer = jsonDecode(response.body);
      // print(scodexAnswer);

      emit(SuccessAskMeAnythingState());
    } else {
      emit(ErrorAskMeAnythingState());
      print('Failed to post data. Error code: ${response.statusCode}');
    }
  }

  bool isTextFormArabic = false;
  bool isTextFormArabicF(String text) {
    if (RegExp(r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]')
        .hasMatch(text)) {
      isTextFormArabic = true;
      emit(ChangeDirectionState());
    } else {
      isTextFormArabic = false;
      emit(ChangeDirectionState());
    }
    return RegExp(r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]')
        .hasMatch(text);
  }

  bool isAnswerArabic = false;
  bool isAnswerArabicF(String text) {
    print(isAnswerArabic);
    if (RegExp(r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]')
        .hasMatch(text)) {
      isAnswerArabic = true;
      emit(ChangeDirectionState());
    } else {
      isAnswerArabic = false;
      emit(ChangeDirectionState());
    }
    return RegExp(r'[\u0600-\u06FF\u0750-\u077F\uFB50-\uFDFF\uFE70-\uFEFF]')
        .hasMatch(text);
  }
}
