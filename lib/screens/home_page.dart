import 'package:docker_desktop_linux/screens/docker_images.dart';
import 'package:docker_desktop_linux/screens/docker_networks.dart';
import 'package:docker_desktop_linux/screens/docker_volumes.dart';
import 'package:flutter/material.dart';
import 'package:docker_desktop_linux/screens/docker_containers.dart';
import 'package:side_navigation/side_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final List<Widget> _views = [
    DockerImages(),
    DockerVolumes(),
    DockerNetworks()
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideNavigationBar(
            selectedIndex: selectedIndex,
            items: const [
              SideNavigationBarItem(icon: Icons.add_box, label: 'Images'),
              SideNavigationBarItem(icon: Icons.storage, label: 'Volumes'),
              SideNavigationBarItem(
                  icon: Icons.network_check, label: 'Networks'),
            ],
            onTap: (idx) {
              setState(() {
                selectedIndex = idx;
              });
            },
          ),
          Expanded(child: _views.elementAt(selectedIndex)),
        ],
      ),
    );
  }
}
