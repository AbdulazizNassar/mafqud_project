import 'package:flutter/material.dart';
import 'package:mafqud_project/shared/NavMenu.dart';
import 'package:mafqud_project/shared/loading.dart';

class notifications extends StatefulWidget {
  const notifications({super.key});

  @override
  State<notifications> createState() => _notificationsState();
}

class _notificationsState extends State<notifications> {
  @override
  bool isLoading = false;
  Widget build(BuildContext context) => isLoading
      ? Loading()
      : Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue.shade900,
            title: const Text("Notifications"),
          ),
          drawer: const NavMenu(),
        );
}
