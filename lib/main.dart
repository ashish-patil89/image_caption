import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_image_labeling_app/controllers/caption_controller.dart';
import 'package:google_mlkit_image_labeling_app/controllers/image_label_controller.dart';

Future main() async {
  Get.put(ImageLabelController());
  Get.put(CaptionController());

  await dotenv.load(fileName: ".env");

  final apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Gemini.init(apiKey: apiKey, enableDebugging: true);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImageLabelController controller = Get.find();
  final CaptionController capController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Caption Generator'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Obx(() => controller.image.value == null
                  ? Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black),
                      child: const Center(
                          child: Text(
                        'No Image Found',
                        style: TextStyle(color: Colors.white),
                      )))
                  : Image.file(controller.image.value!)),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        controller.pickImage();
                      },
                      child: const Text('Pick Image')),
                  const Text('->'),
                  ElevatedButton(
                      onPressed: () {
                        controller.labelImage();
                      },
                      child: const Text('Label Image')),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Obx(() => controller.labels.isNotEmpty
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: controller.labels
                            .map((label) => Text(
                                  '# ${label.label} ',
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold),
                                ))
                            .toList(),
                      ),
                    )
                  : Container()),
              const SizedBox(
                height: 16,
              ),
              Obx(() {
                if (capController.isLoading.value) {
                  return const Text(
                    'Generating captions...',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  );
                } else if (capController.botResponse == '') {
                  return Container();
                } else {
                  return Column(
                    children: [
                      Text(
                        capController.botResponse.toString(),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
  }
}
