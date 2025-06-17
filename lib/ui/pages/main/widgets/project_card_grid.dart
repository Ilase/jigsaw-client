import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/core/router/build_route.dart';
import 'package:jigsaw_client/domain/entities/objects/project/project.dart';
import 'package:jigsaw_client/ui/pages/project/project_page.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/project_data_notifier.dart';

class ProjectCardGrid extends ConsumerStatefulWidget {
  final Project project;
  const ProjectCardGrid({super.key, required this.project});
  @override
  ConsumerState createState() => _ProjectCardState();
}

class _ProjectCardState extends ConsumerState<ProjectCardGrid>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: InkWell(
        onLongPress: () {
          ref
              .read(projectDataStateNotifierProvider.notifier)
              .fetchData(widget.project.id);

          Navigator.of(context).push(
            createRoute(
              ProjectPage(),
              RouteSettings(
                name: '/project/${widget.project.id}',
                arguments: widget.project,
              ),
            ),
          );
        },
        onTap: () {
          ref
              .read(projectDataStateNotifierProvider.notifier)
              .fetchData(widget.project.id);

          Navigator.of(context).push(
            createRoute(
              ProjectPage(),
              RouteSettings(
                name: '/project/${widget.project.id}',
                arguments: widget.project,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimatedSize(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.project.title,
                            style: textTheme.titleLarge,
                          ),
                          Text(
                            widget.project.description,
                            style: textTheme.titleSmall,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text('Owner: '),
                              Chip(label: Text(widget.project.owner)),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              ref
                                  .read(
                                    projectDataStateNotifierProvider.notifier,
                                  )
                                  .fetchData(widget.project.id);
                              Navigator.of(context).push(
                                createRoute(
                                  ProjectPage(),
                                  RouteSettings(
                                    name: '/project/${widget.project.id}',
                                    arguments: widget.project,
                                  ),
                                ),
                              );
                            },
                            icon: Icon(Icons.arrow_forward),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(),
                    Text('Collaborators: '),
                    Wrap(
                      children:
                          widget.project.collaborators.map((e) {
                            return Chip(label: Text(e));
                          }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
