import 'package:eechart/blocs/qr_reader_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/widgets/qrcode_reader_view.dart';
import 'package:flutter/material.dart';

class QrCodeScanPage extends StatefulWidget {
  QrCodeScanPage({Key? key}) : super(key: key);

  @override
  _QrCodeScanPageState createState() => new _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> {
  // GlobalKey<QrcodeReaderViewState> _key = GlobalKey();
  late QrReaderBloc _bloc;

  @override
  void initState() {
    _bloc = QrReaderBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QrcodeReaderView(
        // key: _key,
        onScan: onScan,
        headerWidget: backAppbar(
          context,
          backgroundColor: Colors.black.withOpacity(0.5),
          backBtnColor: Colors.white,
        ),
        helpWidget: Text(''),
      ),
    );
  }

  Future onScan(String data) async {
    // Navigator.pop(context, data);
//    _key.currentState.startScan();
    print('-------------scan result:$data');
    if (data.isEmpty) {
      Fluttertoast.showToast(msg: 'No found content');
    } else {
      var u = await _bloc.getUsersInfo(data);
      Navigator.pop(context, u);
      // Navigator.pop(context, data);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
