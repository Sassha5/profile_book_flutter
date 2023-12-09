import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/profiles/profile_service.dart';

@singleton
class ProfileController with ChangeNotifier {
  ProfileController(this._profileService);

  final ProfileService _profileService;

  Iterable<Profile> items = List.empty();

  Future loadItems() async {
    items = await _profileService.getUserProfiles();
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
