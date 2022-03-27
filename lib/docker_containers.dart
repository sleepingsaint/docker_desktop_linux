import 'dart:convert';

import 'package:docker_desktop_linux/utils/http_over_unix.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class DockerContainers extends StatefulWidget {
  const DockerContainers({ Key? key }) : super(key: key);

  @override
  State<DockerContainers> createState() => _DockerContainersState();
}

class _DockerContainersState extends State<DockerContainers> {
  final HttpUnixClient _client = HttpUnixClient("/var/run/docker.sock");
  @override
  void initState() {
    super.initState();
    _client.get(Uri.http("localhost", "v1.41/images/json")).then((value) => {
      print(jsonDecode(value.body))
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Docker Containers"),
    );
  }
}