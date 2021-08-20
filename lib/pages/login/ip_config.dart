import 'package:eechart/common/packages.dart';
import 'package:eechart/utils/sp_util.dart';

class IpConfigPage extends StatefulWidget {
  const IpConfigPage({Key? key}) : super(key: key);

  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<IpConfigPage> {
  TextEditingController _apiCtrl = TextEditingController();
  TextEditingController _wsCtrl = TextEditingController();
  static const IP_API = 'https://open-im.rentsoft.cn';
  static const IP_WS = 'wss://open-im.rentsoft.cn/wss';
  bool apiError = false;
  bool wsError = false;

  @override
  void initState() {
    _apiCtrl.text = SpUtil.getString("IP_API");
    if (_apiCtrl.text.isEmpty) _apiCtrl.text = IP_API;

    _wsCtrl.text = SpUtil.getString("IP_WS");
    if (_wsCtrl.text.isEmpty) _wsCtrl.text = IP_WS;

    super.initState();
  }

  @override
  void dispose() {
    _apiCtrl.dispose();
    _wsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 150),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: TextField(
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'IP_API',
                  errorText: apiError ? 'format error' : null,
                ),
                controller: _apiCtrl,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 20),
              child: TextField(
                keyboardType: TextInputType.url,
                decoration: InputDecoration(
                  labelText: 'IP_WS',
                  errorText: wsError ? 'format error' : null,
                ),
                controller: _wsCtrl,
              ),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Ink(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: InkWell(
                    onTap: () {
                      _apiCtrl.text = IP_API;
                      _wsCtrl.text = IP_WS;
                    },
                    child: Container(
                      height: 40,
                      width: 120,
                      alignment: Alignment.center,
                      child: Text(
                        'Rest',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Ink(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: InkWell(
                    onTap: () {
                      var ip = _apiCtrl.text;
                      var ws = _wsCtrl.text;
                      if (!ip.startsWith('http://') &&
                          !ip.startsWith('https://')) {
                        setState(() {
                          apiError = true;
                        });
                      } else if (!ws.startsWith('wss://')) {
                        setState(() {
                          wsError = true;
                        });
                      } else {}
                    },
                    child: Container(
                      height: 40,
                      width: 120,
                      alignment: Alignment.center,
                      child: Text(
                        'Confirm',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
