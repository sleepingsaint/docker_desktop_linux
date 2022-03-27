import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:docker_desktop_linux/utils/docker_client.dart';

class DockerVolumes extends StatelessWidget {
  DockerVolumes({Key? key}) : super(key: key);
  final DockerClient _client = DockerClient();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _client.getVolumes(),
      builder:
          (BuildContext context, AsyncSnapshot<List<DockerVolume>> snapshot) {
        if (snapshot.hasError) {
          return const Text("Error occurred");
        }

        if (snapshot.hasData) {
          return DockerVolumesTable(snapshot.data!);
        }

        return const Text("Loading");
      },
    );
  }
}

class DockerVolumesTable extends StatelessWidget {
  const DockerVolumesTable(this._volumes, {Key? key}) : super(key: key);
  final List<DockerVolume> _volumes;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Table(
          children: [
            const TableRow(children: [
              TableCell(child: Text("Name")),
              TableCell(child: Text("Driver")),
              TableCell(child: Text("Mountpoint")),
              TableCell(child: Text("Created At")),
            ]),
            ..._volumes.map((_volume) => _buildDockerVolumeWidget(_volume)).toList()
          ],
        ),
      ],
    );
  }

  TableRow _buildDockerVolumeWidget(DockerVolume _volume) {
    return TableRow(
      children: [
        TableCell(child: Text(_volume.name ?? "Volume name not available")),
        TableCell(child: Text(_volume.driver ?? "Driver not available")),
        TableCell(child: Text(_volume.mountPoint ?? "Mountpoint not available")),
        TableCell(child: Text(_getDateFormat(_volume.createdAt!)))
      ]
    );
  }

  String _getDateFormat(String createdAt) {
    DateTime _dateTime = DateTime.parse(createdAt);
    return DateFormat.yMMMd().format(_dateTime);
  }

  String _formatBytes(int bytes, int decimals) {
    int factor = 1000;
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(factor)).floor();
    return ((bytes / pow(factor, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
}

