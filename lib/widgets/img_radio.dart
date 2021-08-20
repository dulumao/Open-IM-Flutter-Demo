import 'package:eechart/common/packages.dart';

class ImageRadio extends StatelessWidget {
  const ImageRadio({
    Key? key,
    this.checked = false,
    /*   this.width,
    this.height,
    this.onTap,*/
  }) : super(key: key);
  final bool checked;

/*  final double? width;
  final double? height;
  final Function(bool isChecked)? onTap;*/

  @override
  Widget build(BuildContext context) {
    return /*GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (onTap != null) {
          onTap!(!checked);
        }
      },
      child: Container(
        width: width ?? 52.w,
        height: height ?? 52.w,
        alignment: Alignment.center,
        child: assetImage(checked ? 'ic_radio_sel' : 'ic_radio_nor'),
      ),
    )*/
        assetImage(
      checked ? 'ic_radio_sel' : 'ic_radio_nor',
      width: 20.h,
      height: 20.h,
    );
  }
}
