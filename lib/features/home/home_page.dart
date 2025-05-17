import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jigsaw_client/domain/locale/locale_bloc.dart';
import 'package:jigsaw_client/features/home/views/project_calendar_view.dart';
import 'package:jigsaw_client/features/home/views/project_view.dart';
import 'package:jigsaw_client/utils/l10n/arb/app_localizations.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late PageController _pageController;
  int _selectedIndex = 0;
  bool _isExpanded = false;

  ///List of destinations of board
  final List<Widget> _destinations = [ProjectView(), ProjectCalendarView()];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [_buildLanguageSelector()],
        title: Text('Jigsaw'),
        leading: IconButton(
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          icon: Icon(Icons.ac_unit),
        ),
      ),
      body: Row(
        children: [
          _buildNavigationRailBar(),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              controller: _pageController,
              children: _destinations,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRailBar() {
    return NavigationRail(
      extended: _isExpanded,
      labelType: NavigationRailLabelType.none,
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
          _isExpanded = false;
        });
        _pageController.animateToPage(
          index,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },

      destinations: [
        NavigationRailDestination(
          icon: Icon(Icons.document_scanner),
          label: Text('Projects'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.calendar_today),
          label: Text('Project calendar'),
        ),
      ],
      selectedIndex: _selectedIndex,

      trailing: Column(
        children: [IconButton(onPressed: null, icon: Icon(Icons.person))],
      ),
    );
  }

  Widget _buildBody() {
    return Center(child: _destinations[_selectedIndex]);
  }

  Widget _buildLanguageSelector() {
    final currentLocale = context.watch<LocaleBloc>().state.locale;
    final supportedLocales = JigsawLocalizations.supportedLocales;

    return DropdownMenu<Locale>(
      initialSelection: currentLocale,
      onSelected: (Locale? newLocale) {
        if (newLocale != null) {
          context.read<LocaleBloc>().add(ChangeLocale(newLocale));
        }
      },
      dropdownMenuEntries:
          supportedLocales.map((locale) {
            return DropdownMenuEntry<Locale>(
              value: locale,
              label: _getLanguageName(locale.languageCode),
            );
          }).toList(),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ru':
        return 'Русский';
      default:
        return code.toUpperCase();
    }
  }
}
