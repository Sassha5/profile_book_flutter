import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/profiles/profile_service.dart';

@singleton
class ProfileController with ChangeNotifier {
  ProfileController(this._profileService);

  final ProfileService _profileService;

  Iterable<Profile> items = List.empty();

  Future<Iterable<Profile>> loadItems() async {
    items = await _profileService.getUserProfiles();
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
