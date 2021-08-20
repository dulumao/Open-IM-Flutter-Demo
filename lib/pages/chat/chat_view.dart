import 'package:eechart/blocs/bloc_provider.dart';
import 'package:eechart/blocs/chat_bloc.dart';
import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';
import 'package:eechart/widgets/chat_input_view.dart';
import 'package:eechart/widgets/chat_msg_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ChatView extends StatelessWidget {
  final RefreshController refreshController;

  final AutoScrollController autoScrollController;

  // final ItemScrollController itemScrollController;
  // final ItemPositionsListener itemPositionsListener;
  final String? title;
  final Function()? onClickMoreBtn;

  // final ContactInfo info;

  ChatView({
    Key? key,
    required this.refreshController,
    required this.autoScrollController,
    // required this.itemPositionsListener,
    // required this.itemScrollController,
    this.onClickMoreBtn,
    this.title,
    // required this.info,
  }) : super(key: key);

  void _pop({required BuildContext context, ChatBloc? bloc}){
    bloc?.markSingleMessageHasRead();
    Navigator.pop(context, bloc?.getDartText());
  }

  @override
  Widget build(BuildContext context) {
    ChatBloc? _bloc = BlocProvider.of<ChatBloc>(context);
    return WillPopScope(
      onWillPop: () async {
        // _bloc?.markSingleMessageHasRead();
       _pop(context: context,bloc: _bloc);
        return true;
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          _bloc?.closePlusToolbox();
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: StreamBuilder(
          stream: _bloc?.chatMsgListCtrl,
          builder: (_, AsyncSnapshot<List<Message>> hot) => Scaffold(
            appBar: backAppbar(
              context,
              title: title ?? '',
              center: StreamBuilder(
                stream: _bloc?.typingCtrl.stream,
                builder: (_, AsyncSnapshot<bool> typingHot) {
                  var t = title;
                  if (typingHot.hasData && typingHot.data == true) {
                    t = S.of(context).typing;
                  }
                  return Text(
                    t ?? '',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Color(0xFF333333),
                      // fontWeight: FontWeight.w600,
                    ),
                  );
                },
              ),
              onBack: () {
                // _bloc?.markSingleMessageHasRead();
                _pop(context: context, bloc: _bloc);
              },
              right: assetImage('ic_more', width: 28.h)
                  .intoContainer(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      height: double.infinity)
                  .intoGesture(onTap: onClickMoreBtn),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: SmartRefresher(
                    child: ListView.builder(
                      controller: autoScrollController,
                      padding: EdgeInsets.only(left: 22.w, right: 22.w),
                      itemCount: hot.data?.length ?? 0,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return FocusDetector(
                          onVisibilityLost: () {
                            print('Visibility Lost. $index');
                          },
                          onVisibilityGained: () {
                            print('Visibility Gained.$index');
                            var msg = hot.data![index];
                            _bloc?.markC2CMessageAsRead(msg);
                          },
                          child: AutoScrollTag(
                            key: ValueKey(index),
                            controller: autoScrollController,
                            index: index,
                            child: ChatMsgView(
                              key: UniqueKey(),
                              subject: _bloc?.clickCtrl,
                              message: hot.data![index],
                              index: index,
                              onDelete: () {
                                _bloc?.deleteMsg(message: hot.data![index]);
                              },
                              onRevoke: () {
                                _bloc?.revokeMeg(message: hot.data![index]);
                              },
                              onDownload: () {
                                _bloc?.download(message: hot.data![index]);
                              },
                            ).intoContainer(
                              padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                            ),
                          ),
                        );
                        /* return AutoScrollTag(
                          key: ValueKey(index),
                          controller: autoScrollController,
                          index: index,
                          child: ChatMsgView(
                            key: UniqueKey(),
                            subject: _bloc?.clickCtrl,
                            message: hot.data![index],
                            index: index,
                            onDelete: () {
                              _bloc?.deleteMsg(message: hot.data![index]);
                            },
                            onRevoke: () {
                              _bloc?.revokeMeg(message: hot.data![index]);
                            },
                          ).intoContainer(
                            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                          ),
                        );*/
                      },
                    ),
                    controller: refreshController,
                    enablePullDown: true,
                    // enablePullUp: true,
                    onLoading: () {},
                    onRefresh: () {
                      _bloc?.loadHistoryMsgList();
                    },
                    header: buildMsgRefreshHeader(),
                    footer: buildMsgLoadFooter(),
                    onTwoLevel: (bool isOpen) {},
                  ),
                ),
                ChatInputView(bloc: _bloc),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
