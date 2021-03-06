import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';

class  QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  _QRScannerState createState() => _QRScannerState();
  }

  class _QRScannerState extends State<QRScanner> {

  Barcode? barcode;
  QRViewController? qrViewController;
  final qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
  qrViewController?.dispose();
  super.dispose();
  }

  @override
  void reassemble() async {
  super.reassemble();
  if (Platform.isAndroid) {
  await qrViewController?.pauseCamera();
  }
  qrViewController?.resumeCamera();
  }

  Widget buildResult() {
  return Container(
  padding: const EdgeInsets.all(12.0),
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(8.0),
  color: Colors.white24,
  ),
  child: Text(
  'Scan a code!',
  ),
  );
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  body: Stack(
  alignment: Alignment.center,
  children: [
  QRView(
  key: qrKey,
  onQRViewCreated: (QRViewController controller) {
  setState(() => qrViewController = controller);
  qrViewController?.scannedDataStream.listen((barcode) {
  setState(() {
  this.barcode = barcode;
  qrViewController?.dispose();
  Navigator.pop(context, barcode.code);
  });
  });
  },
  overlay: QrScannerOverlayShape(
  borderColor: Colors.blueGrey,
  borderRadius: 10,
  borderLength: 20,
  borderWidth: 10,
  cutOutSize: MediaQuery.of(context).size.width * 0.7,
  ),
  ),
  Positioned(bottom: 30, child: buildResult()),
  ],
  ),
  );
  }
  }
