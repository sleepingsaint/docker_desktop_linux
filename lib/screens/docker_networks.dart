import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:docker_desktop_linux/utils/docker_client.dart';

class DockerNetworks extends StatelessWidget {
  DockerNetworks({Key? key}) : super(key: key);
  final DockerClient _client = DockerClient();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _client.getNetworks(),
      builder:
          (BuildContext context, AsyncSnapshot<List<DockerNetwork>> snapshot) {
        if (snapshot.hasError) {
          return const Text("Error occurred");
        }

        if (snapshot.hasData) {
          return DockerNetworksTable(snapshot.data!);
        }

        return const Text("Loading");
      },
    );
  }
}

class DockerNetworksTable extends StatelessWidget {
  const DockerNetworksTable(this._networks, {Key? key}) : super(key: key);
  final List<DockerNetwork> _networks;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Table(
          children: [
            const TableRow(children: [
              TableCell(child: Text("Id")),
              TableCell(child: Text("Name")),
              TableCell(child: Text("Driver")),
              TableCell(child: Text("Created At")),
            ]),
            ..._networks.map((_network) => _buildDockerNetworkWidget(_network)).toList()
          ],
        ),
      ],
    );
  }

  TableRow _buildDockerNetworkWidget(DockerNetwork _network) {
    return TableRow(
      children: [
        TableCell(child: Text(_network.id!.substring(0, 12))),
        TableCell(child: Text(_network.name ?? "Volume name not available")),
        TableCell(child: Text(_network.driver ?? "Driver not available")),
        TableCell(child: Text(_getDateFormat(_network.created!)))
      ]
    );
  }

  String _getDateFormat(String createdAt) {
    DateTime _dateTime = DateTime.parse(createdAt);
    return DateFormat.yMMMd().format(_dateTime);
  }
}


