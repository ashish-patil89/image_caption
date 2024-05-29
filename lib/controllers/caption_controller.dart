import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';

class CaptionController extends GetxController {
  RxString botResponse = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  Future<void> getCaptions(List<String> data) async {
    try {
      isLoading.value = true;
      botResponse.value = '';

      String req =
          'Generate few creative captions for a image which has list of image labels as follows${data.join('+')} no need to use label names in the caption';

      final gemini = Gemini.instance;

      final response = await gemini.text(req);

      final output = response?.output ?? '';

      botResponse.value = output;
      print(output);
      isLoading.value = false;
    } catch (error) {
      print(error.toString());
    }
  }
}
