import 'dart:io';
import 'dart:async';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? image;
  var resultController = TextEditingController();
  var detectedObjectController = TextEditingController();

  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();

    setState(() {});
  }

  final ImagePicker _picker = ImagePicker();
  var percentage = 0.0;
  var stage = 0;

  Future pickImage() async
  {
    print("i entred pick");
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    final image_temp = File(image.path);

    setState(() {
      this.image = image_temp;
    });
    loadDetectorModel();
    classifyImage(detectedObjectController, 1);
  }

  loadDetectorModel() async
  {
    String? res = await Tflite.loadModel(
        model: "assets/object_detector.tflite",
        labels: "assets/classes.txt",
        numThreads: 1,
        // defaults to 1
        isAsset: true,
        // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );
    print("$res  res");
  }

  loadClassifier() async
  {
    String? res = await Tflite.loadModel(
        model: "assets/DefectDetectionModel.tflite",
        labels: "assets/labels.txt",
        numThreads: 1,
        // defaults to 1
        isAsset: true,
        // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            false // defaults to false, set to true to use GPU delegate
        );

    print("$res  res");
  }

  classifyImage(controller, stage) async {
    resultController.text = "";
    var recognitions = await Tflite.runModelOnImage(
        path: image!.path,
        // required
        imageMean: 0.0,
        // defaults to 117.0
        imageStd: 255.0,
        // defaults to 1.0
        numResults: 2,
        // defaults to 5
        threshold: 0.2,
        // defaults to 0.1
        asynch: true // defaults to true
        );

    controller.text = recognitions![0]['label'];
    percentage = recognitions[0]['confidence'];
    controller.text = controller.text.substring(2);
    print(controller.text);
    print(percentage);
    print(recognitions);
    this.stage = stage + 1;
    setState(() {});
  }

  releaseResource() async {
    await Tflite.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: const Text(
          "Defect Detection",
        ),
      )),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               const Text("Check your image"),
              const SizedBox(
                height: 20,
              ),
              Container(
                height: 70,
                width: 219,
                decoration: BoxDecoration(
                  color: Color(0xffd9d9d9),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: MaterialButton(
                    onPressed: () => pickImage().then((value) => print("done")),
                    child: SvgPicture.asset("assets/icons/upload_icon.svg")),
              ),
              const SizedBox(
                height: 30,
              ),
              image != null
                  ? Image.file(
                      image!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : const FlutterLogo(
                      size: 100,
                    ),
              Container(
                  height: 50,
                  child: Text(
                    detectedObjectController.text,
                    style: TextStyle(
                        color: detectedObjectController.text == "lemon"
                            ? Colors.amberAccent
                            : Colors.black,
                        fontSize: 30),
                  )),
              Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)),
                  child: MaterialButton(
                    onPressed: () {
                      if (detectedObjectController.text == "screw") {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Not Developed yet'),
                                content: Text(
                                    'model for detecting screws is not available\n\nyou can check lemons only'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            });
                      } else {
                        loadClassifier();
                        classifyImage(resultController, 1);
                      }
                    },
                    child: Text(
                      "check",
                      style: TextStyle(color: Colors.white),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                resultController.text,
                style: TextStyle(
                    color: resultController.text == "Defected"
                        ? Colors.red
                        : Colors.green,
                    fontSize: 30),
              ),
              stage != 0
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(child: Text("Confidence level :")),
                        Text(percentage.toString()),
                      ],
                    )
                  : Row()
            ],
          ),
        ),
      ),
    );
  }
}
