import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:docker_desktop_linux/utils/docker_client.dart';

class DockerImages extends StatelessWidget {
  DockerImages({Key? key}) : super(key: key);
  final DockerClient _client = DockerClient();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _client.getImages(),
      builder:
          (BuildContext context, AsyncSnapshot<List<DockerImage>> snapshot) {
        if (snapshot.hasError) {
          return const Text("Error occurred");
        }

        if (snapshot.hasData) {
          return DockerImagesTable(snapshot.data!);
        }

        return const Text("Loading");
      },
    );
  }
}

class DockerImagesTable extends StatelessWidget {
  const DockerImagesTable(this._images, {Key? key}) : super(key: key);
  final List<DockerImage> _images;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Table(
          children: [
            const TableRow(children: [
              TableCell(child: Text("Repository")),
              TableCell(child: Text("Tag")),
              TableCell(child: Text("Image ID")),
              TableCell(child: Text("Created")),
              TableCell(child: Text("Size")),
            ]),
            ...(_images
                    .map((_image) => _buildDockerImageWidget(_image))
                    .toList())
                .expand((element) => element)
                .toList()
          ],
        ),
      ],
    );
  }

  List<TableRow> _buildDockerImageWidget(DockerImage _image) {
    return _image.repoTags!
        .map<TableRow>(
          (_tag) => TableRow(
            children: [
              TableCell(child: Text(_tag.split(':')[0])),
              TableCell(child: Text(_tag.split(':')[1])),
              TableCell(child: Text(_image.id!.split(':')[1].substring(0, 12))),
              TableCell(child: Text(_getDateFormat(_image.created!))),
              TableCell(child: Text(_formatBytes(_image.size!, 2)))
            ],
          ),
        )
        .toList();
  }

  String _getDateFormat(int epochSecs) {
    DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(epochSecs * 1000);
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
