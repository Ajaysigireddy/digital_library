// download_helper.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

Future<String> downloadAndSavePDF(String url) async {
  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;

  final dir = await getTemporaryDirectory();
  final file = File('${dir.path}/my_pdf.pdf');

  await file.writeAsBytes(bytes);

  return file.path;
}
