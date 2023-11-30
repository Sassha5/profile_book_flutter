import 'package:flutter/material.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/profiles/profile_service.dart';

class ProfileController with ChangeNotifier {
  ProfileController(this._profileService);

  final ProfileService _profileService;

  late Iterable<Profile> items;

  Future loadItems() async {
    items = await _profileService.getProfiles();
    notifyListeners();
  }

  Future addOrUpdate(Profile profile) async {
    //if exists
    //await _profileService.update(profile);
    //else
    await _profileService.add(profile);
    await loadItems();
  }

  Future delete(Profile profile) async {
    await _profileService.delete(profile);
    await loadItems();
  }
}
