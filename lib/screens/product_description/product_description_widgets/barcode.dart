import 'package:qr_flutter/qr_flutter.dart';

generateBarcode(String docID){
  return QrImage(
    size: 150,
    data: docID,
    version: QrVersions.auto,
  );
}