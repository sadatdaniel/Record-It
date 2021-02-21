import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:share/share.dart';
import 'package:pdf/widgets.dart' as pdfLib;

class SharePage extends StatefulWidget {
  final String bloodGroup;
  final String fullName;
  final String dob;
  final String nid;
  final String email;
  final String docName;
  final List medications;
  final List symptoms;
  final String hospitalName;
  final String title;
  final String until;
  final String addiNote;
  final String reportExportDate;

  SharePage({
    Key key,
    @required this.fullName,
    @required this.nid,
    @required this.dob,
    @required this.bloodGroup,
    @required this.email,
    @required this.docName,
    @required this.medications,
    @required this.symptoms,
    @required this.hospitalName,
    @required this.title,
    @required this.until,
    @required this.addiNote,
    @required this.reportExportDate,
  }) : super(key: key);
  @override
  _SharePageState createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Row(
            children: [
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () async {
                    print("Button 2 Pressed");
                    await showDialog(
                        context: context,
                        builder: (_) {
                          // return showImage('images/logoapp.png');
                          return showQR();
                        });
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_rounded,
                          size: 100,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Get QR Code",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    height: 200,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Color(0xffe6e6e6),
                      border: Border.all(
                        color: Color(0xffe6e6e6),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                flex: 3,
                child: GestureDetector(
                  onTap: () async {
                    print("Button 2 pressed");
                    generatePDF(context);
                  },
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.picture_as_pdf_rounded,
                          size: 100,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Export To PDF",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    height: 200,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 3,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      color: Color(0xffe6e6e6),
                      border: Border.all(
                        color: Color(0xffe6e6e6),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showImage(String imagePath) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: ExactAssetImage(imagePath), fit: BoxFit.scaleDown)),
      ),
    );
  }

  showQR() {
    return Dialog(
      child: QrImage(
        data:
            "Patient Name: ${widget.fullName}, National ID: ${widget.nid}, Medication List: ${widget.medications}, Valid Until: ${widget.until}",
        version: QrVersions.auto,
      ),
    );
  }

  sharePDF(BuildContext context, String path) {
    List<String> pdfPath = List<String>();
    String filepath = path.toString().substring(7, path.toString().length - 1);

    pdfPath.add(filepath);
    print(pdfPath);
    Share.shareFiles(pdfPath);
  }

  _listToText(List items, context, ttf) {
    List<pdfLib.Widget> list = new List<pdfLib.Widget>();
    for (var i = 0; i < items.length; i++) {
      list.add(
        new pdfLib.Text(
          items[i],
          textScaleFactor: 2,
          style: pdfLib.Theme.of(context).defaultTextStyle.copyWith(
              fontSize: 6, fontWeight: pdfLib.FontWeight.normal, font: ttf),
        ),
      );
    }
    return new pdfLib.Column(
        crossAxisAlignment: pdfLib.CrossAxisAlignment.start, children: list);
  }

  _listToTextRight(List items, context, ttf) {
    List<pdfLib.Widget> list = new List<pdfLib.Widget>();
    for (var i = 0; i < items.length; i++) {
      list.add(
        new pdfLib.Text(
          items[i],
          textScaleFactor: 2,
          style: pdfLib.Theme.of(context).defaultTextStyle.copyWith(
              fontSize: 6, fontWeight: pdfLib.FontWeight.normal, font: ttf),
        ),
      );
    }
    return new pdfLib.Column(
        crossAxisAlignment: pdfLib.CrossAxisAlignment.end, children: list);
  }

  generatePDF(context) async {
    String bloodGroup = 'A+';
    String fullName = 'Osman Jeh';
    String dob = '2020.06.15';
    String nid = '110510055';
    String email = 'osman.jeh@gmail.com';
    String docName = 'Atiya Jannat';
    List medications = ['Paracetamol', 'Caugh syrup'];
    List symptoms = ['Fever', 'caugh', 'hapani'];
    String hospitalName = 'Hargeisa Hospital';
    String title = 'Mild Fever with Hapani';
    String until = '2021.05.17';
    String addiNote = "Osman Jah is very cute";
    String reportExportDate = '2021.02.22';

    final logoImage = pdfLib.MemoryImage(
      (await rootBundle.load('images/logoapp.png')).buffer.asUint8List(),
    );

    final pdfLib.Document pdf = pdfLib.Document();
    final font = await rootBundle.load("assets/fonts/Spartan-Medium.ttf");
    final ttf = pdfLib.Font.ttf(font);
    const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);

    // pdf.addPage(
    //   pdfLib.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pdfLib.Context context) {
    //       return pdfLib.Center(
    //         child: pdfLib.Text(
    //           'Hello World',
    //           style: pdfLib.TextStyle(font: ttf),
    //         ),
    //       ); // Center
    //     },
    //   ),
    // ); //

    pdf.addPage(
      pdfLib.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pdfLib.Context context) {
          return pdfLib.Partitions(children: [
            pdfLib.Partition(
              child: pdfLib.Column(
                crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                children: <pdfLib.Widget>[
                  pdfLib.Container(
                    padding: const pdfLib.EdgeInsets.only(left: 0, bottom: 0),
                    child: pdfLib.Column(
                      crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                      children: <pdfLib.Widget>[
                        pdfLib.Row(
                          children: [
                            pdfLib.Container(
                              height: 50.0,
                              width: 50.0,
                              child: pdfLib.Image(logoImage),
                            ),
                            pdfLib.SizedBox(
                              width: 10,
                            ),
                            pdfLib.Column(
                              // mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                              crossAxisAlignment:
                                  pdfLib.CrossAxisAlignment.start,
                              children: [
                                pdfLib.Text(
                                  'Daryeel',
                                  textScaleFactor: 2,
                                  style: pdfLib.Theme.of(context)
                                      .defaultTextStyle
                                      .copyWith(
                                          fontWeight: pdfLib.FontWeight.bold,
                                          font: ttf),
                                ),
                                pdfLib.Text(
                                  'better technology better health',
                                  textScaleFactor: 2,
                                  style: pdfLib.Theme.of(context)
                                      .defaultTextStyle
                                      .copyWith(
                                          fontSize: 6,
                                          fontWeight: pdfLib.FontWeight.normal,
                                          font: ttf),
                                ),
                              ],
                            )
                          ],
                        ),
                        pdfLib.Padding(
                          padding: const pdfLib.EdgeInsets.only(top: 30),
                          child: pdfLib.Row(
                            children: [
                              pdfLib.Column(
                                crossAxisAlignment:
                                    pdfLib.CrossAxisAlignment.start,
                                children: [
                                  pdfLib.Text(
                                    'Report Name: ${widget.title}',
                                    textScaleFactor: 1.2,
                                    style: pdfLib.Theme.of(context)
                                        .defaultTextStyle
                                        .copyWith(
                                          font: ttf,
                                          fontWeight: pdfLib.FontWeight.bold,
                                        ),
                                  ),
                                  pdfLib.Text(
                                    'Valid Until: ${widget.until}',
                                    textScaleFactor: 1.2,
                                    style: pdfLib.Theme.of(context)
                                        .defaultTextStyle
                                        .copyWith(
                                          font: ttf,
                                          fontSize: 10,
                                          fontWeight: pdfLib.FontWeight.normal,
                                        ),
                                  ),
                                  pdfLib.SizedBox(height: 20),
                                  pdfLib.Text(
                                    'Prescribed by: ${widget.docName}',
                                    textScaleFactor: 1.2,
                                    style: pdfLib.Theme.of(context)
                                        .defaultTextStyle
                                        .copyWith(
                                          font: ttf,
                                          fontSize: 10,
                                          fontWeight: pdfLib.FontWeight.bold,
                                        ),
                                  ),
                                  pdfLib.Text(
                                    'From : ${widget.hospitalName}',
                                    textScaleFactor: 1.2,
                                    style: pdfLib.Theme.of(context)
                                        .defaultTextStyle
                                        .copyWith(
                                          font: ttf,
                                          fontSize: 10,
                                          fontWeight: pdfLib.FontWeight.normal,
                                        ),
                                  ),
                                ],
                              ),
                              // pdfLib.Padding(
                              //   padding: const pdfLib.EdgeInsets.only(top: 30),
                              // ),
                              pdfLib.Expanded(
                                child: pdfLib.Column(
                                  crossAxisAlignment:
                                      pdfLib.CrossAxisAlignment.end,
                                  children: <pdfLib.Widget>[
                                    pdfLib.Padding(
                                      padding: const pdfLib.EdgeInsets.fromLTRB(
                                          0, 20, 0, 0),
                                      child: pdfLib.Text(
                                        'Report Export Date:',
                                        textScaleFactor: 1.2,
                                        style: pdfLib.Theme.of(context)
                                            .defaultTextStyle
                                            .copyWith(
                                              font: ttf,
                                              fontSize: 10,
                                              fontWeight:
                                                  pdfLib.FontWeight.bold,
                                            ),
                                      ),
                                    ),
                                    pdfLib.Text(
                                      '${widget.reportExportDate}',
                                      textScaleFactor: 1.2,
                                      style: pdfLib.Theme.of(context)
                                          .defaultTextStyle
                                          .copyWith(
                                            font: ttf,
                                            fontSize: 10,
                                            fontWeight:
                                                pdfLib.FontWeight.normal,
                                          ),
                                    ),
                                    pdfLib.SizedBox(
                                      height: 10,
                                    ),
                                    pdfLib.Text(
                                      'Patient Name: ${widget.fullName}',
                                      textScaleFactor: 1.2,
                                      style: pdfLib.Theme.of(context)
                                          .defaultTextStyle
                                          .copyWith(
                                            font: ttf,
                                            fontSize: 10,
                                            fontWeight: pdfLib.FontWeight.bold,
                                          ),
                                    ),
                                    pdfLib.Text(
                                      'Date of Birth: ${widget.dob}',
                                      textScaleFactor: 1.2,
                                      style: pdfLib.Theme.of(context)
                                          .defaultTextStyle
                                          .copyWith(
                                            font: ttf,
                                            fontSize: 10,
                                            fontWeight:
                                                pdfLib.FontWeight.normal,
                                          ),
                                    ),
                                    pdfLib.Text(
                                      'NID: ${widget.nid}',
                                      textScaleFactor: 1.2,
                                      style: pdfLib.Theme.of(context)
                                          .defaultTextStyle
                                          .copyWith(
                                            font: ttf,
                                            fontSize: 10,
                                            fontWeight:
                                                pdfLib.FontWeight.normal,
                                          ),
                                    ),
                                    pdfLib.Text(
                                      'Blood Group: ${widget.bloodGroup}',
                                      textScaleFactor: 1.2,
                                      style: pdfLib.Theme.of(context)
                                          .defaultTextStyle
                                          .copyWith(
                                            font: ttf,
                                            fontSize: 10,
                                            fontWeight:
                                                pdfLib.FontWeight.normal,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        pdfLib.SizedBox(
                          height: 20,
                        ),
                        pdfLib.Row(
                          crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                          mainAxisAlignment: pdfLib.MainAxisAlignment.start,
                          children: <pdfLib.Widget>[
                            pdfLib.Column(children: [
                              pdfLib.Text(
                                'Medications',
                                textScaleFactor: 1.2,
                                style: pdfLib.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                      font: ttf,
                                      fontWeight: pdfLib.FontWeight.bold,
                                    ),
                              ),
                              pdfLib.Padding(
                                padding: const pdfLib.EdgeInsets.only(top: 5),
                                child: _listToText(
                                    widget.medications, context, ttf),
                              ),
                            ]),
                            pdfLib.SizedBox(width: 325),
                            pdfLib.Column(
                                // mainAxisAlignment: pdfLib.MainAxisAlignment.end,
                                crossAxisAlignment:
                                    pdfLib.CrossAxisAlignment.end,
                                children: [
                                  pdfLib.Text(
                                    'Symptoms',
                                    textScaleFactor: 1.2,
                                    style: pdfLib.Theme.of(context)
                                        .defaultTextStyle
                                        .copyWith(
                                          font: ttf,
                                          fontWeight: pdfLib.FontWeight.bold,
                                        ),
                                  ),
                                  pdfLib.Padding(
                                    padding:
                                        const pdfLib.EdgeInsets.only(top: 5),
                                    child: _listToTextRight(
                                        widget.symptoms, context, ttf),
                                  ),
                                ]),

                            // pdfLib.Column(
                            //   crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                            //   children: <pdfLib.Widget>[
                            //     pdfLib.Text('568 Port Washington Road'),
                            //     pdfLib.Text('Nordegg, AB T0M 2H0'),
                            //     pdfLib.Text('Canada, ON'),
                            //   ],
                            // ),

                            pdfLib.Padding(padding: pdfLib.EdgeInsets.zero)
                          ],
                        ),
                        pdfLib.Padding(
                          padding:
                              const pdfLib.EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: pdfLib.Column(
                            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                            children: <pdfLib.Widget>[
                              pdfLib.Text(
                                'Additional Note',
                                textScaleFactor: 1.2,
                                style: pdfLib.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(
                                      font: ttf,
                                      fontWeight: pdfLib.FontWeight.bold,
                                    ),
                              ),
                              pdfLib.Container(
                                // width: double.infinity,
                                decoration: const pdfLib.BoxDecoration(
                                  color: lightGreen,
                                  borderRadius: pdfLib.BorderRadius.all(
                                      pdfLib.Radius.circular(6)),
                                ),
                                margin: const pdfLib.EdgeInsets.only(
                                    bottom: 10, top: 5),
                                padding: const pdfLib.EdgeInsets.fromLTRB(
                                    3, 7, 10, 4),
                                child: pdfLib.Text(
                                  '${widget.addiNote}',
                                  style: pdfLib.Theme.of(context)
                                      .defaultTextStyle
                                      .copyWith(
                                        fontSize: 10,
                                        font: ttf,
                                        fontWeight: pdfLib.FontWeight.bold,
                                      ),
                                ),
                              ),

                              // pdfLib.Column(
                              //   crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
                              //   children: <pdfLib.Widget>[
                              //     pdfLib.Text('568 Port Washington Road'),
                              //     pdfLib.Text('Nordegg, AB T0M 2H0'),
                              //     pdfLib.Text('Canada, ON'),
                              //   ],
                              // ),
                              pdfLib.Row(
                                  mainAxisAlignment:
                                      pdfLib.MainAxisAlignment.end,
                                  children: [
                                    pdfLib.Padding(
                                      padding: const pdfLib.EdgeInsets.fromLTRB(
                                          0, 50, 0, 0),
                                      child: pdfLib.BarcodeWidget(
                                        data:
                                            "Patient Name: ${widget.fullName}, National ID: ${widget.nid}, Medication List: ${widget.medications}, Valid Until: ${widget.until}",
                                        width: 100,
                                        height: 100,
                                        barcode: pdfLib.Barcode.qrCode(),
                                      ),
                                    )
                                    // pdfLib.Padding(
                                    //     padding: pdfLib.EdgeInsets.zero)
                                  ])
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ]);
        },
      ),
    ); //

    final String dir = (await getApplicationDocumentsDirectory()).path;
    // print(dir);
    final String path = '$dir/test_pdf.pdf';
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());
    print(await file.exists());
    sharePDF(context, file.toString());
  }
}
