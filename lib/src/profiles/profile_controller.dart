import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/profiles/profile_service.dart';

@singleton
class ProfileController with ChangeNotifier {
  ProfileController(this._profileService);

  final ProfileService _profileService;

  List<Profile> _items = List.empty();
  List<Profile> get items => _items;

  SelectionState _selectionState = SelectionState.noSelection;
  SelectionState get selectionState => _selectionState;

  ///Should be used when [selectionState] is [SelectionState.oneItem].
  ///Will be null if no selection and only the first selected item when there are multiple.
  Profile? get selectedItem => _items.any((element) => element.isSelected)
      ? _items.firstWhere((element) => element.isSelected)
      : null;

  void clearSelection() {
    for (var element in items) {
      element.isSelected = false;
    }

    _selectionState = SelectionState.noSelection;
    notifyListeners();
  }

  bool toggleSelection(int index) {
    switch (selectionState) {
      case SelectionState.noSelection:
        _selectionState = SelectionState.oneItem;
        break;
      case SelectionState.oneItem:
        if (_items.indexOf(selectedItem!) == index) {
          _selectionState = SelectionState.noSelection;
        } else {
          selectedItem!.isSelected = false;
        }
        break;
      default:
    }

    _items[index].isSelected = !_items[index].isSelected;
    notifyListeners();

    return _items[index].isSelected;
  }

  void startMultiselection() => _selectionState = SelectionState.multipleItems;

  void reorder(int oldIndex, int newIndex) {
    final Profile item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item); //todo also change order in db
    notifyListeners();
  }

  Future<List<Profile>> loadItems({bool notify = true}) async {
    _items = await _profileService.getUserProfiles();
    clearSelection();

    if (notify) {
      notifyListeners();
    }
    return items;
  }

  Future<int> addOrUpdate(Profile profile) async {
    var result = await _profileService.put(profile);
    await loadItems();
    return result;
  }

  Future<bool> delete(Profile profile) async {
    var result = await _profileService.delete(profile);
    _selectionState = SelectionState.noSelection;
    await loadItems();
    return result;
  }

  Future<int> deleteMany(Iterable<Profile> profiles) async {
    var result = await _profileService.deleteMany(profiles);
    await loadItems(notify: false);
    clearSelection();
    _selectionState = SelectionState.noSelection;
    notifyListeners();
    return result;
  }
}

enum SelectionState { noSelection, oneItem, multipleItems }
