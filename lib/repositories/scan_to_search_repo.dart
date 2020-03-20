import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:e_commerce_bloc/blocs/scan_to_seaarch_bloc/scan_to_search_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanToSearchRepo{

  List<ImageLabel> labels = List<ImageLabel>();
  String bestText;
  double bestConfidence=0;
  QuerySnapshot qs;

  getImage() async{
    if(qs!=null)
      qs.documents.clear();
    scanToSearchBloc.scannedListIn.add(qs);
    labels.clear();
    bestConfidence=0;
    File imageFile;
    FirebaseVisionImage visionImage;
    ImageLabeler labeler = FirebaseVision.instance.imageLabeler();
    imageFile =  await ImagePicker.pickImage(source: ImageSource.camera);
    if(imageFile==null)
      return [null, qs];
    else{
      visionImage = FirebaseVisionImage.fromFile(imageFile);
      labels = await labeler.processImage(visionImage);
      for (ImageLabel label in labels) {
        final String text = label.text;
        final String entityId = label.entityId;
        final double confidence = label.confidence;
        print(text);
        print(entityId);
        print(confidence);
        print("");
        if(double.parse('$confidence') > bestConfidence)
        {
          bestText = text;
          bestConfidence = double.parse('$confidence');
        }
      }
      scanToSearchBloc.lablesIn.add(labels);
      qs = await getScanData();
      return [bestText, qs];
    }
  }

  scanCode() async{
    String qrCode;
    try {
      qrCode = await BarcodeScanner.scan();
    } catch (e) {
      scanToSearchBloc.qrCodeIn.add(null);
      return null; 
    }
    return qrCode;
  }

  getScanData() async{
    QuerySnapshot qs = await Firestore.instance.collection('products').where('scan', arrayContains: bestText).getDocuments();
    return qs;
  }

  getQRCodeData(String docID) async{
    DocumentSnapshot ds = await Firestore.instance.collection('products').document(docID).get();
    return ds;
  }
}

final scanToSearchRepo = ScanToSearchRepo();