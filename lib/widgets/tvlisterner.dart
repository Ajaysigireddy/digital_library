import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FireTVRemoteListener extends StatefulWidget {
  final FocusNode focusNode;
  final VoidCallback onUp;
  final VoidCallback onDown;
  final VoidCallback onLeft;
  final VoidCallback onRight;
  final VoidCallback onSelect;
  final Widget child;

  const FireTVRemoteListener({
    Key? key,
    required this.focusNode,
    required this.onUp,
    required this.onDown,
    required this.onLeft,
    required this.onRight,
    required this.onSelect,
    required this.child,
  }) : super(key: key);

  @override
  _FireTVRemoteListenerState createState() => _FireTVRemoteListenerState();
}

class _FireTVRemoteListenerState extends State<FireTVRemoteListener> {
  late RawKeyboardListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = RawKeyboardListener(
      focusNode: widget.focusNode,
      onKey: _handleKeyPress,
      child: widget.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return _listener;
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          widget.onUp();
          break;
        case LogicalKeyboardKey.arrowDown:
          widget.onDown();
          break;
        case LogicalKeyboardKey.arrowLeft:
          widget.onLeft();
          break;
        case LogicalKeyboardKey.arrowRight:
          widget.onRight();
          break;
        case LogicalKeyboardKey.select:
          widget.onSelect();
          break;
        default:
          break;
      }
    }
  }
}
