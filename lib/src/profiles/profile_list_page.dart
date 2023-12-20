import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/profiles/profile_controller.dart';
import 'package:profile_book_flutter/src/widgets/profile_avatar.dart';
import 'package:qr_flutter/qr_flutter.dart';

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

enum SelectionState { noSelection, oneItem, multipleItems }

class _ProfileListPageState extends State<ProfileListPage> {
  @override
  void initState() {
    controller.loadItems().then((value) => initializeSelection());
    super.initState();
  }

  final ProfileController controller = getIt.get<ProfileController>();

  SelectionState selectionState = SelectionState.noSelection;

  int? _selectedIndex;
  List<bool> _selectedItems = List.empty();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profiles'),
        leading: selectionState == SelectionState.multipleItems
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() => selectionState = SelectionState.noSelection);
                  initializeSelection();
                },
              )
            : null,
        actions: _getAppBarActions(selectionState),
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
            if (controller.items.isNotEmpty &&
                controller.items.length > _selectedItems.length) {
              initializeSelection();
            }

            return ReorderableListView.builder(
              // Providing a restorationId allows the ListView to restore the
              // scroll position when a user leaves and returns to the app after it
              // has been killed while running in the background.
              restorationId: 'ProfileListView',
              buildDefaultDragHandles: false,
              itemCount: controller.items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = controller.items.elementAt(index);
                return ListTile(
                  key: Key(item.id.toString()),
                  title: Text(item.name),
                  subtitle:
                      Text(DateFormat('dd.MM.yyyy').format(item.creationDate)),
                  leading: ProfileAvatar(item.image),
                  selected: index == _selectedIndex,
                  onTap: () {
                    switch (selectionState) {
                      case SelectionState.noSelection:
                        selectionState = SelectionState.oneItem;
                        setState(() => _selectedIndex = index);
                        break;
                      case SelectionState.oneItem:
                        if (_selectedIndex == index) {
                          selectionState = SelectionState.noSelection;
                          setState(() => _selectedIndex = null);
                        } else {
                          setState(() => _selectedIndex = index);
                        }
                        break;
                      case SelectionState.multipleItems:
                        _toggleSelection(index);
                        break;
                      default:
                    }
                  },
                  onLongPress: () {
                    if (selectionState != SelectionState.multipleItems) {
                      setState(() {
                        _selectedItems[index] = true;
                        selectionState = SelectionState.multipleItems;
                      });
                    }
                  },
                  trailing: selectionState == SelectionState.multipleItems
                      ? Checkbox(
                          value: _selectedItems[index],
                          onChanged: (bool? x) => _toggleSelection(index),
                        )
                      : ReorderableDragStartListener(
                          index: index,
                          child: const SizedBox(
                              width: 48,
                              child: Icon(Icons.drag_indicator_outlined))),
                );
              },
              onReorder: (int oldIndex, int newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                controller.reorder(oldIndex, newIndex);
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

  void initializeSelection() {
    _selectedItems = List<bool>.generate(controller.items.length, (_) => false);
  }

  void _toggleSelection(int index) {
    if (selectionState == SelectionState.multipleItems) {
      setState(() => _selectedItems[index] = !_selectedItems[index]);
    }
  }

  List<Widget> _getAppBarActions(SelectionState selectionState) {
    var noSelectionActions = [
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => context.beamToNamed(SettingsPage.routeName),
      ),
    ];

    var singleSelectionActions = [
      IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _showQR(
              data: controller.items
                  .elementAt(_selectedIndex!)
                  .toString())),
      IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            context.beamToNamed(ProfileAddEditPage.routeName,
                data: controller.items.elementAt(_selectedIndex!));
          }),
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            controller.delete(controller.items.elementAt(_selectedIndex!));
            setState(() => _selectedIndex = null);
          }),
    ];

    var multipleSelectionActions = [
      IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _showQR(
              data: _getSelectedProfiles()
                  .map((e) => e.toJson())
                  .toList()
                  .toString())),
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            await controller.deleteMany(_getSelectedProfiles());
            setState(() =>
                selectionState = SelectionState.noSelection); //not working
            initializeSelection();
          }),
    ];

    return switch (selectionState) {
      SelectionState.noSelection => noSelectionActions,
      SelectionState.oneItem => singleSelectionActions,
      SelectionState.multipleItems => multipleSelectionActions
    };
  }

  void _showQR({required String data}) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                width: 200,
                height: 200,
                child: QrImageView(data: data)),
          );
        });
  }

  List<Profile> _getSelectedProfiles() {
    var selectedProfiles = List<Profile>.empty(growable: true);

    for (var i = 0; i < _selectedItems.length; i++) {
      if (_selectedItems[i]) {
        selectedProfiles.add(controller.items.elementAt(i));
      }
    }

    return selectedProfiles;
  }
}
