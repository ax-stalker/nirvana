// // final cameras = await availableCameras();
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';

// class cameraPage extends StatefulWidget {
//     final List<CameraDescription>? cameras;

//   const cameraPage({super.key, required this.cameras});

//   @override
//   State<cameraPage> createState() => _cameraPageState();
// }

// class _cameraPageState extends State<cameraPage> {
//     late CameraController _cameraController;

//   @override
//   void initState() {
//     super.initState();
//     // initialize the rear camera
//     initCamera(widget.cameras![0]);
//   }
//   @override
//   void dispose() {
//     // Dispose of the controller when the widget is disposed.
//     _cameraController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//         return Scaffold(
//         body: SafeArea(
//             child: _cameraController.value.isInitialized
//                 ? CameraPreview(_cameraController)
//                 : const Center(child:
//                 CircularProgressIndicator())));
//   }

// Future initCamera(CameraDescription cameraDescription) async {
// // create a CameraController
//   _cameraController = CameraController(
//     cameraDescription, ResolutionPreset.high);
// // Next, initialize the controller. This returns a Future.
//   try {
//     await _cameraController.initialize().then((_) {
//     if (!mounted) return;
//     setState(() {});
//     });
//   } on CameraException catch (e) {
//     debugPrint("camera error $e");
//   }
// }

// Future takePicture() async {
//   if (!_cameraController.value.isInitialized) {return null;}
//   if (_cameraController.value.isTakingPicture) {return null;}
//   try {
//     await _cameraController.setFlashMode(FlashMode.off);
//     XFile picture = await _cameraController.takePicture();
//     Navigator.push(context, MaterialPageRoute(
//                    builder: (context) => PreviewPage(
//                          picture: picture,
//                        )));
//   } on CameraException catch (e) {
//     debugPrint('Error occured while taking picture: $e');
//     return null;
//   }
// }
// }