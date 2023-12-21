import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:profile_book_flutter/src/di/di_init.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/profiles/profile_controller.dart';
import 'package:profile_book_flutter/src/profiles/profile_list_tile.dart';
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

class _ProfileListPageState extends State<ProfileListPage> {
  @override
  void initState() {
    controller.loadItems();
    super.initState();
  }

  final ProfileController controller = getIt.get<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: controller,
        builder: (context, widget) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profiles'),
              leading: controller.selectionState == SelectionState.multipleItems
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: controller.clearSelection,
                    )
                  : null,
              actions: _getAppBarActions(controller.selectionState),
            ),

            // To work with lists that may contain a large number of items, it’s best
            // to use the ListView.builder constructor.
            //
            // In contrast to the default ListView constructor, which requires
            // building all Widgets up front, the ListView.builder constructor lazily
            // builds Widgets as they’re scrolled into view.
            body: controller.items.isEmpty
                ? emptyState
                : ReorderableListView.builder(
                    // Providing a restorationId allows the ListView to restore the
                    // scroll position when a user leaves and returns to the app after it
                    // has been killed while running in the background.
                    restorationId: 'ProfileListView',
                    buildDefaultDragHandles: false,
                    itemCount: controller.items.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = controller.items.elementAt(index);
                      return ProfileListTile(
                        key: Key(item.id.toString()),
                        item: item,
                        isSelected: item.isSelected,
                        trailing: controller.selectionState ==
                                SelectionState.multipleItems
                            ? Checkbox(
                                value: item.isSelected,
                                onChanged: (bool? x) =>
                                    controller.toggleSelection(index),
                              )
                            : ReorderableDragStartListener(
                                index: index,
                                child: const SizedBox(
                                  width: 48,
                                  child: Icon(Icons.drag_indicator_outlined),
                                ),
                              ),
                        onTap: () => controller.toggleSelection(index),
                        onLongPress: () {
                          controller.startMultiselection();
                          controller.toggleSelection(index);
                        },
                      );
                    },
                    onReorder: (int oldIndex, int newIndex) {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      controller.reorder(oldIndex, newIndex);
                    },
                  ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
              shape: const CircleBorder(),
              tooltip: 'Add',
              onPressed: () =>
                  context.beamToNamed(ProfileAddEditPage.routeName),
              child: const Icon(Icons.add, color: Colors.white, size: 28),
            ),
          );
        });
  }

  Widget get emptyState => const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: Center(child: Text('You have no profiles yet'))),
          Padding(
            padding: EdgeInsets.all(30),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Start by adding your first one'),
                SizedBox(width: 5),
                Icon(Icons.arrow_forward)
              ],
            ),
          )
        ],
      );

  List<Widget> _getAppBarActions(SelectionState selectionState) {
    var noSelectionActions = [
      IconButton(
        icon: const Icon(Icons.qr_code_scanner),
        onPressed: _openScanner,
      ),
      IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => context.beamToNamed(SettingsPage.routeName),
      ),
    ];

    var singleSelectionActions = [
      IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _showQR(data: controller.selectedItem.toString())),
      IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => context.beamToNamed(ProfileAddEditPage.routeName,
              data: controller.selectedItem)),
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => controller.delete(controller.selectedItem!)),
    ];

    var multipleSelectionActions = [
      IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _showQR(
              data: controller.items
                  .where((element) => element.isSelected)
                  .map((e) => e.toJson())
                  .toList()
                  .toString())),
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => controller.deleteMany(
              controller.items.where((element) => element.isSelected))),
    ];

    return switch (selectionState) {
      SelectionState.noSelection => noSelectionActions,
      SelectionState.oneItem => singleSelectionActions,
      SelectionState.multipleItems => multipleSelectionActions
    };
  }

  void _openScanner() => showDialog(
      context: context,
      builder: (context) {
        return MobileScanner(
          controller: MobileScannerController(
            detectionSpeed: DetectionSpeed.noDuplicates,
          ),
          onDetect: (capture) {
            Navigator.of(context).pop();

            showDialog(
                context: context,
                builder: (context) {
                  final profileCells =
                      List<ProfileListTile>.empty(growable: true);

                  for (final barcode in capture.barcodes) {
                    final Profile profile = Profile.fromJson(jsonDecode(
                        barcode.rawValue ??
                            '')); //currently only for single profile
                    profileCells.add(ProfileListTile(item: profile));
                  }

                  return Dialog(
                    child: ListView(
                      shrinkWrap: true,
                      children: profileCells,
                    ),
                  );
                });
          },
        );
      });

  void _showQR({required String data}) => showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              width: 200,
              height: 200,
              child: QrImageView(data: data)),
        );
      });
}
