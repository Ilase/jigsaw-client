import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/projects_provider.dart';

class DebugPanel extends ConsumerStatefulWidget {
  const DebugPanel({super.key});

  @override
  ConsumerState<DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends ConsumerState<DebugPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DebugPanel'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          ButtonFoDebug(
            onPressed: () {
              ref.read(projectsProvider.notifier).fetchData();
            },
            name: 'Get Projects',
          ),
        ],
      ),
    );
  }
}

class ButtonFoDebug extends StatelessWidget {
  final VoidCallback onPressed;
  final String name;
  const ButtonFoDebug({super.key, required this.onPressed, required this.name});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(onPressed: onPressed, child: Text(name));
  }
}
