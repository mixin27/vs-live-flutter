import 'dart:async';

import 'package:flutter/widgets.dart';

/// Brings functionality to execute code after the first layout of a widget has
/// been performed, i.e. after the first frame has been displayed.
///
/// If you want to display a widget that depends on the layout, such as a
/// `Dialog` or `BottomSheet`, you can not use that widget in `initState`.
///
/// Usage:
/// ```dart
/// class HomeScreen extends StatefulWidget {
///   const HomeScreen({Key? key}) : super(key: key);
///
///   @override
///   HomeScreenState createState() => HomeScreenState();
/// }
///
/// class HomeScreenState extends State<HomeScreen>
///       with AfterLayoutMixin<HomeScreen> {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       body: Container(color: Colors.red),
///     );
///   }
///
///   @override
///   void afterFirstLayout(BuildContext context) {
///     /// Calling the same function "after layout" to resolve the issue.
///     showHelloWorld();
///   }
///
///   void showHelloWorld() {
///     showDialog(
///       context: context,
///       builder: (BuildContext context) {
///         return AlertDialog(
///           content: const Text('Hello World'),
///           actions: <Widget>[
///             TextButton(
///               onPressed: () => Navigator.of(context).pop(),
///               child: const Text('DISMISS'),
///             )
///           ],
///         );
///       },
///     );
///   }
/// }
/// ```
///
/// https://github.com/fluttercommunity/flutter_after_layout/blob/master/lib/after_layout.dart
mixin AfterLayoutMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.endOfFrame.then(
      (_) {
        if (mounted) afterFirstLayout(context);
      },
    );
  }

  FutureOr<void> afterFirstLayout(BuildContext context);
}
