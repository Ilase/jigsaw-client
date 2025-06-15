import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/projects_provider.dart';
import 'package:markdown_editor_plus/markdown_editor_plus.dart';

class CreateProjectPage extends ConsumerStatefulWidget {
  const CreateProjectPage({super.key});

  @override
  ConsumerState createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends ConsumerState<CreateProjectPage> {
  final markdownController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('Create Project'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref
                  .read(projectsProvider.notifier)
                  .createProject(
                    titleController.text,
                    descriptionController.text,
                    markdownController.text,
                  );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 1200),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Project name'),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: descriptionController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text('Short description'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        Text('README', style: textTheme.titleLarge),
                        Text(
                          'Click on \'Markdown text for edit mode\'',
                          style: textTheme.titleSmall,
                        ),

                        Divider(),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: MarkdownAutoPreview(
                                controller: markdownController,
                                toolbarBackground:
                                    Theme.of(context).canvasColor,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Markdown Auto Preview',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
