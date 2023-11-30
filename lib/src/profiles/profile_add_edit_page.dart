import 'package:flutter/material.dart';

/// Displays detailed information about a SampleItem.
class ProfileAddEditPage extends StatefulWidget {
  const ProfileAddEditPage({super.key});

  static const routeName = '/sample_item';

  @override
  State<ProfileAddEditPage> createState() => _ProfileAddEditPageState();
}

class _ProfileAddEditPageState extends State<ProfileAddEditPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
      ),
      body: const Center(
        child: Text('More Information Here'),
      ),
    );
  }
}
