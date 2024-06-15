import 'package:flutter/material.dart';

SnackBar customSnackBar(BuildContext context, String errorMessage) => SnackBar(
      content: Center(
        child: Text(errorMessage,
            style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
      padding: const EdgeInsets.all(15),
      duration: const Duration(milliseconds: 1500),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      width: 330,
      behavior: SnackBarBehavior.floating,
    );
