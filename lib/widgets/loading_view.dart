import 'package:eechart/common/packages.dart';
import 'package:lottie/lottie.dart';

class LoadingView {
  static final LoadingView _singleton = LoadingView._internal();

  factory LoadingView() {
    return _singleton;
  }

  LoadingView._internal();

  static OverlayState? _overlayState;
  static late OverlayEntry _overlayEntry;
  static bool _isVisible = false;

  static void createView(BuildContext context, Color background) async {
    _overlayState = Overlay.of(context);

//    Paint paint = Paint();
//    paint.strokeCap = StrokeCap.square;
//    paint.color = background;

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Container(
        width: MediaQuery.of(context).size.width,
        color: background,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTapDown: (d) => dismiss(),
          child: LoadingAnimation(),
        ),
      ),
    );
    _isVisible = true;
    _overlayState?.insert(_overlayEntry);
  }

  static Future<bool> dismiss() async {
    if (!_isVisible) {
      return _isVisible;
    }
    _isVisible = false;
    _overlayEntry.remove();
    return _isVisible;
  }

  static Future<bool> show(
    BuildContext context, {
    Color backgroundColor = const Color(0x00000000),
  }) async {
    dismiss();
    createView(context, backgroundColor);
    return _isVisible;
  }

  static Future<T> wrap<T>(BuildContext context, Future<T> fc) {
    show(context).then((value) => fc).whenComplete(() => dismiss());
    return fc;
  }
}

class LoadingAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 60.w,
        height: 60.w,
        child: Lottie.asset('assets/anim/loading.json', width: 60.w),
      ),
    );
  }
}
