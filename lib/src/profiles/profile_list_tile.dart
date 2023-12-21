import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:profile_book_flutter/src/profiles/profile.dart';
import 'package:profile_book_flutter/src/widgets/profile_avatar.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    super.key,
    required this.item,
    this.isSelected = false,
    this.trailing,
    this.onTap,
    this.onLongPress,
  });

  final Profile item;
  final bool isSelected;
  final Widget? trailing;
  final void Function()? onTap;
  final void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(item.name),
      subtitle: Text(DateFormat('dd.MM.yyyy').format(item.creationDate)),
      leading: ProfileAvatar(item.image),
      selected: isSelected,
      onTap: onTap,
      onLongPress: onLongPress,
      trailing: trailing,
    );
  }
}