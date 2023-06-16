import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class memo_detail extends StatefulWidget {
  const memo_detail({super.key, required int index});
  static const routeName = '/memo_detail';

  @override
  State<memo_detail> createState() => _memo_detailState();
}

class _memo_detailState extends State<memo_detail> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}