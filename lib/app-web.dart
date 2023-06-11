// import 'dart:html' as html;
// import 'package:flutter/material.dart';
//
// class AppPage extends StatefulWidget {
//   @override
//   _AppPageState createState() => _AppPageState();
// }
//
// class _AppPageState extends State<AppPage> {
//   late html.FileUploadInputElement _fileInput;
//   String? _downloadUrl;
//
//   @override
//   void initState() {
//     super.initState();
//     _fileInput = html.FileUploadInputElement();
//     _fileInput.accept = '.apk';
//     _fileInput.onChange.listen((event) {
//       final files = _fileInput.files;
//       if (files != null && files.isNotEmpty) {
//         final file = files[0];
//         setState(() {
//           _downloadUrl = html.Url.createObjectUrl(file);
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     html.Url.revokeObjectUrl(_downloadUrl!); // Clean up the object URL
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('APK Uploader'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 _fileInput.click();
//               },
//               child: const Text('Select APK File'),
//             ),
//             if (_downloadUrl != null)
//               ElevatedButton(
//                 onPressed: () {
//                   html.window.open(_downloadUrl!, '_blank');
//                 },
//                 child: const Text('Download APK'),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
