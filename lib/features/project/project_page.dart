import 'package:flutter/material.dart';
import 'package:tab_container/tab_container.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  List<Tab> projectViewTabs = [Tab(child: Text("data"))];
  List<Widget> projectViewPages = [Placeholder()];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: projectViewTabs.length);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    return Scaffold(
      appBar: AppBar(
        title: Text("Project ${args!["project_id"]}"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                projectViewTabs.add(Tab(child: Text("tab")));
                projectViewPages.add(Placeholder());
              });
            },
            icon: Icon(Icons.add),
          ),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: TabContainer(
        controller: _tabController,
        tabs: projectViewTabs,
        children: projectViewPages,

        transitionBuilder: (child, animation) {
          animation = CurvedAnimation(curve: Curves.easeIn, parent: animation);
          return SlideTransition(
            position: Tween(
              begin: const Offset(0.2, 0.0),
              end: const Offset(0.0, 0.0),
            ).animate(animation),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        tabEdge: TabEdge.top,
        tabMaxLength: 100,
      ),
    );
  }
}
