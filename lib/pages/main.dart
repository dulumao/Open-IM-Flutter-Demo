import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/blocs/bottom_bar_bloc.dart';
import 'package:eechart/blocs/im_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/pages/conversation/conversation_list.dart';
import 'package:eechart/pages/mine/mine.dart';
import 'package:eechart/widgets/bottom_bar.dart';
import 'package:eechart/widgets/jpush_state.dart';
import 'package:flutter_fgbg/flutter_fgbg.dart';

import 'contacts/contacts_list.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends JpushState<MainPage> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    IMBloc? imBloc = BlocProvider.of<IMBloc>(context);

    return FGBGNotifier(
      onEvent: (e) {
        print('===================e======12=====$e');
        if (e == FGBGType.foreground) {
          print('===================e======2=====$e');
          // imBloc?.forceReConn();
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        body: IndexedStack(
          index: _index,
          children: [
            ConversationListPage(),
            ContactsListPage(),
            MinePage(),
          ],
        ),
        bottomNavigationBar: BlocProvider(
          bloc: BottomBarBloc(),
          child: BottomBar(
            index: _index,
            onTap: (i) => setState(() => _index = i),
          ),
        ),
      ),
    );
  }
}
