import 'package:eechart/common/packages.dart';
import 'package:eechart/common/widgets.dart';

class SwitcherButton extends StatelessWidget {
  const SwitcherButton({
    Key? key,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return assetImage(
      value ? 'ic_switch_open' : 'ic_switch_close',
      // width: 50.w,
      height: 30.h,
      fit: BoxFit.fill
    ).intoGesture(onTap: () => onChanged!(value));
  }
}
