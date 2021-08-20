import 'package:cached_network_image/cached_network_image.dart';
import 'package:eechart/common/packages.dart';

class ChatAvatarView extends StatelessWidget {
  const ChatAvatarView({
    Key? key,
    this.visible = true,
    this.size,
    this.onTap,
    this.url,
    this.onLongPress,
  }) : super(key: key);
  final bool visible;
  final double? size;
  final Function()? onTap;
  final Function()? onLongPress;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: ClipOval(
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: null == url || url!.isEmpty
              ? Container(
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: (size ?? 42.w) - 10.w,
                  ),
                  width: size ?? 42.w,
                  height: size ?? 42.w,
                  color: Colors.grey[400],
                )
              : CachedNetworkImage(
                  imageUrl: url!,
                  width: size ?? 42.w,
                  height: size ?? 42.w,
                ),
        ),
      ),
    );
  }
}
