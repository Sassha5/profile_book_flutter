import 'package:flutter/material.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/profiles/profile_controller.dart';

import '../settings/settings_view.dart';
import 'profile_add_edit_page.dart';

class ProfilesListView extends StatefulWidget {
  static const routeName = '/';

  const ProfilesListView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProfilesListViewState();
  }
}

/// Displays a list of SampleItems.
class _ProfilesListViewState extends State<ProfilesListView> {

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
        onPressed: () {
          Navigator.restorablePushNamed(context, SettingsView.routeName);
        },
      ),
    ];

    var profileActions = [
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            controller.delete(controller.items.elementAt(_selectedIndex!));
            setState(() {
              _selectedIndex = null;
            });
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
              restorationId: 'sampleItemListView',
              itemCount: controller.items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = controller.items.elementAt(index);
                return ListTile(
                    title: Text('${item.name} ${item.id}'),
                    subtitle: Text(item.creationDate.toString()),
                    leading: const CircleAvatar(
                      // Display the Flutter Logo image asset.
                      foregroundImage:
                          AssetImage('assets/images/flutter_logo.png'),
                    ),
                    selected: index == _selectedIndex,
                    onTap: () {
                      setState(() {
                        _selectedIndex = _selectedIndex == index ? null : index;
                      });
                    });
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        shape: const CircleBorder(),
        tooltip: 'Add',
        onPressed: () {
          Navigator.restorablePushNamed(
            context,
            ProfileAddEditPage.routeName,
          );
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
