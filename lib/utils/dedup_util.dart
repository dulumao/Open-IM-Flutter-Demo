class Dedup {
  DateTime? last;

  void run({required Function() fuc, int diff = 0}) {
    DateTime now = DateTime.now();
    if (null == last || now.difference(last ?? now).inMilliseconds > diff) {
      last = now;
      fuc();
    }
  }
}
