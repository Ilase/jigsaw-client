import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdministrationButton extends ConsumerWidget {
  const AdministrationButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.security),
      label: Text('Administration'),
    );
  }
}
