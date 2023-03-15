import 'package:chat_gpt/shared/components/constants.dart';
import 'package:chat_gpt/shared/main_cubit/main_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../shared/main_cubit/main_cubit.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    internetConection(context);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color.fromARGB(255, 52, 53, 65),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return BlocConsumer<MainCubit, MainState>(
      bloc: MainCubit.get(context),
      listener: (context, state) {},
      builder: (context, state) {
        MainCubit ref = MainCubit.get(context);
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 68, 70, 84),
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 52, 53, 65),
            title: const Text(
              'ChatGPT',
              style: TextStyle(
                color: Color.fromARGB(255, 209, 213, 211),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Directionality(
                textDirection:
                    ref.isAnswerArabic ? TextDirection.rtl : TextDirection.ltr,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    state is LoadingAskMeAnythingState
                        ? Column(
                            children: const [
                              SizedBox(height: 10),
                              SpinKitThreeBounce(
                                color: Color.fromARGB(255, 209, 213, 211),
                                size: 20,
                              ),
                              SizedBox(height: 10),
                            ],
                          )
                        : Container(),
                    Directionality(
                      textDirection: ref.isTextFormArabic
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: TextField(
                        onChanged: (value) {
                          ref.isTextFormArabicF(value);
                        },
                        style: const TextStyle(
                          color: Color.fromARGB(255, 209, 213, 211),
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        controller: controller,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Ask me any thing',
                          hintStyle: TextStyle(
                            color: Color.fromARGB(255, 209, 213, 211),
                          ),
                        ),
                        cursorColor: Colors.grey.shade300,
                      ),
                    ),
                    (ref.scodexAnswer['bot'] == null ||
                            ref.scodexAnswer['bot'].isEmpty)
                        ? Container()
                        : SelectableText(
                            ref.scodexAnswer['bot'],
                            textAlign: ref.isAnswerArabic
                                ? TextAlign.end
                                : TextAlign.start,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 209, 213, 211),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),
          bottomSheet: GestureDetector(
            onTap: () async {
              if (controller.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'The Field Is Empty Please Fill The Filled First!',
                        style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      backgroundColor: const Color.fromARGB(255, 52, 53, 65),
                    );
                  },
                );
              } else {
                internetConection(context);
                if (isNetworkConnection) {
                  await ref.scodexAI(prompt: controller.text, context: context);
                  if (ref.scodexAnswer['bot'].isNotEmpty &&
                      ref.scodexAnswer['bot'] != null) {
                    ref.isAnswerArabicF(ref.scodexAnswer['bot']);
                  }
                }
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 68, 70, 84),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    offset: Offset(0, -1),
                    blurRadius: 4,
                  )
                ],
              ),
              child: Container(
                width: double.infinity,
                height: 50.0,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: const Color.fromARGB(255, 52, 53, 65),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'ASK',
                    style: TextStyle(
                      color: Color.fromARGB(255, 209, 213, 211),
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
