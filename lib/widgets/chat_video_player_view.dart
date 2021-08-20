import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:eechart/common/packages.dart';
import 'package:video_player/video_player.dart';

class ChatVideoPlayerView extends StatefulWidget {
  final String? path;
  final String? url;

  const ChatVideoPlayerView({Key? key, this.path, this.url}) : super(key: key);

  @override
  _ChatVideoPlayerViewState createState() => _ChatVideoPlayerViewState();
}

class _ChatVideoPlayerViewState extends State<ChatVideoPlayerView> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    if (null != _path && _path!.isNotEmpty) {
      var file = File(_path!);
      if (file.existsSync()) {
        videoPlayerController = VideoPlayerController.file(file);
      }
    }
    if (null == videoPlayerController) {
      if (null != _url && _url!.isNotEmpty) {
        videoPlayerController = VideoPlayerController.network(_url!);
      }
    }

    if (null != videoPlayerController) {
      await videoPlayerController!.initialize();

      chewieController = ChewieController(
        videoPlayerController: videoPlayerController!,
        autoPlay: true,
        looping: false,
      );

      setState(() {});
    }
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (null != chewieController)
            Chewie(
              controller: chewieController!,
            ),
          SafeArea(
            child: Container(
              child: assetImage(
                'ic_back',
                width: 12.w,
                height: 21.h,
                color: Colors.white,
              )
                  .intoContainer(
                    height: 56.h,
                    padding: EdgeInsets.symmetric(horizontal: 22.w),
                  )
                  .intoGesture(onTap: () => Navigator.pop(context)),
            ),
          )
        ],
      ),
    );
  }

  String? get _path => widget.path;

  String? get _url => widget.url;
}
