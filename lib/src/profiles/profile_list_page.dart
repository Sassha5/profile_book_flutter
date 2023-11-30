import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'profile.dart';
import 'profile_add_edit_page.dart';

class ProfilesListView extends StatefulWidget {
  static const routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return _ProfilesListViewState();
  }
}

/// Displays a list of SampleItems.
class _ProfilesListViewState extends State<ProfilesListView> {
  _ProfilesListViewState({
    key,
  });

  final List<Profile> items = [Profile(1), Profile(2), Profile(3)];
  int? _selectedIndex;

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
        onPressed: () => setState(() => items.remove(items[_selectedIndex!])),
      ),
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
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];
          return ListTile(
              title: Text('SampleItem ${item.id}'),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              selected: index == _selectedIndex,
              onTap: () {
                setState(() {
                  _selectedIndex = _selectedIndex == index ? null : index;
                });

                // Navigator.restorablePushNamed(
                //   context,
                //   ProfileAddEditPage.routeName,
                // );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        shape: const CircleBorder(),
        tooltip: 'Add',
        onPressed: () {
          setState(() {
            items.add(Profile(items.length + 1));
          });
        },
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }
}
