import 'dart:io';
import 'package:tflite/tflite.dart';

class PredictionService {
  late List<dynamic> _output;
  late File _image;

  PredictionService();

  Future loadModel() async {
    try {
      String modelPath =
          'assets/your_model.tflite'; // Replace with your model path
      String labelsPath =
          'assets/your_labels.txt'; // Replace with your labels path if applicable

      await Tflite.loadModel(
        model: modelPath,
        labels: labelsPath,
      );
    } catch (e) {
      print('Failed to load model: $e');
    }
  }

  Future<List<dynamic>> predict(File image) async {
    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 5, // Number of results you want to retrieve
      threshold: 0.2, // Confidence threshold for classification
      imageMean: 127.5, // Mean for normalizing the input image
      imageStd: 127.5, // Standard deviation for normalizing the input image
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      _output = recognitions!;
    } else {
      print('Failed to recognize image.');
      _output = [];
    }

    return _output;



  }



  PredictionService predictionService = PredictionService();

// Load the model when the app starts or in an appropriate place
await predictionService.loadModel();

// Call predict function when needed with the selected image
List<dynamic> predictions = await predictionService.predict(_image);

// Process the predictions as needed

}

