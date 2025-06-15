import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/user_provider.dart';

class ProfileButton extends ConsumerWidget {
  const ProfileButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userProvider);
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(Icons.person),
      label: Text(
        userData.isLoading
            ? 'Loading'
            : userData.error != null
            ? 'Error'
            : userData.data!.nickname,
      ),
    );
  }
}
