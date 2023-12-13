import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/profiles/profile_controller.dart';
import 'package:profile_book_flutter/src/widgets/profile_avatar.dart';

import '../settings/settings_page.dart';
import 'profile_add_edit_page.dart';

class ProfileListPage extends StatefulWidget {
  static const routeName = '/profiles';

  const ProfileListPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfileListPageState();
  }
}

/// Displays a list of SampleItems.
class _ProfileListPageState extends State<ProfileListPage> {
  @override
  void initState() {
    controller.loadItems();
    super.initState();
  }

  int? _selectedIndex;
  final ProfileController controller = getIt.get<ProfileController>();

  @override
  Widget build(BuildContext context) {
    var defaultActions = [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => context.beamToNamed(SettingsPage.routeName),
      ),
    ];

    var profileActions = [
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            controller.delete(controller.items.elementAt(_selectedIndex!));
            setState(() => _selectedIndex = null);
          }),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        actions: _selectedIndex == null ? defaultActions : profileActions,
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListenableBuilder(
          listenable: controller,
          builder: (context, widget) {
            return ListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              restorationId: 'ProfileListView',
              itemCount: controller.items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = controller.items.elementAt(index);
                return ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                        DateFormat('dd.MM.yyyy').format(item.creationDate)),
                    leading: ProfileAvatar(item.image),
                    selected: index == _selectedIndex,
                    onTap: () {
                      setState(() => _selectedIndex =
                          _selectedIndex == index ? null : index);
                    });
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        shape: const CircleBorder(),
        tooltip: 'Add',
        onPressed: () {
          context.beamToNamed(ProfileAddEditPage.routeName);
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
