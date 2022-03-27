import 'package:flutter/material.dart';
import 'package:docker_desktop_linux/utils/docker_client.dart';

class DockerSystemInfo extends StatelessWidget {
  DockerSystemInfo({Key? key}) : super(key: key);
  final DockerClient _client = DockerClient();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _client.getVersion(),
      builder: (BuildContext context, AsyncSnapshot<DockerVersion> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return const Text("Error Occured");
        }

        if (snapshot.hasData) {
          return DockerSystemInfoWidget(snapshot.data!);
        }

        return const Text("Loading");
      },
    );
  }
}

class DockerSystemInfoWidget extends StatelessWidget {
  const DockerSystemInfoWidget(this._dockerVersion, { Key? key}) : super(key: key);
  final DockerVersion _dockerVersion;
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Text("Platform"),
        Text(_dockerVersion.platform ?? "Platform not available"),
        Text("OS"),
        Text(_dockerVersion.os ?? "OS not available"),
        Text("version"),
        Text(_dockerVersion.version ?? "Version not available"),
        Text("API Version"),
        Text(_dockerVersion.apiVersion ?? "API Version not available"),
        Text("Min API Version"),
        Text(_dockerVersion.minApiVersion ?? "Min API Version not available"),
        Text("Architecture"),
        Text(_dockerVersion.arch ?? "Architecture not available"),
        Text("Kernel Version"),
        Text(_dockerVersion.kernelVersion ?? "Kernel Version not available"),
        Text("Experimental"),
        Text(_dockerVersion.experimental != null ? _dockerVersion.experimental! ? "True" : "False" : "False"),
        Text("Git Commit"),
        Text(_dockerVersion.gitCommit ?? "Git Commit not available"),
        Text("Build Time"),
        Text(_dockerVersion.buildTime ?? "Build Time not available"),
        Text("Go Version"),
        Text(_dockerVersion.goVersion ?? "Go Version not available")
      ],
    );
  }
}
