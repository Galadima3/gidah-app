import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomScreen extends ConsumerStatefulWidget {
  final Widget input;
  const CustomScreen({super.key, required this.input});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomScreenState();
}

class _CustomScreenState extends ConsumerState<CustomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.input,
      ),
    );
  }
}
