import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/profiles/profile_service.dart';

@singleton
class ProfileController with ChangeNotifier {
  ProfileController(this._profileService);

  final ProfileService _profileService;

  List<Profile> _items = List.empty();
  Iterable<Profile> get items => _items;

  void reorder(int oldIndex, int newIndex) {
    final Profile item = _items.removeAt(oldIndex);
    _items.insert(newIndex, item); //todo also change order in db
    notifyListeners();
  }

  Future<Iterable<Profile>> loadItems() async {
    _items = await _profileService.getUserProfiles();
    notifyListeners();
    return items;
  }

  Future<int> addOrUpdate(Profile profile) async {
    var result = await _profileService.put(profile);
    await loadItems();
    return result;
  }

  Future<bool> delete(Profile profile) async {
    var result = await _profileService.delete(profile);
    await loadItems();
    return result;
  }

  Future<int> deleteMany(Iterable<Profile> profiles) async {
    var result = await _profileService.deleteMany(profiles);
    await loadItems();
    return result;
  }
}
