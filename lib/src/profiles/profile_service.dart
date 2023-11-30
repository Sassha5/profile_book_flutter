import 'package:profile_book_flutter/src/profiles/profile.dart';

class ProfileService {
  final List<Profile> items = [Profile(1), Profile(2), Profile(3)];

  Future<List<Profile>> getProfiles() async {
    return items;
  }

  Future add(Profile profile) async {
    items.add(profile);
  }

  Future update(Profile profile) async {
    
  }

  Future delete(Profile profile) async {
    items.remove(profile);
  }
}
