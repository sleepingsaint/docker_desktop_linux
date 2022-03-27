import 'package:flutter/material.dart';
import 'package:docker_desktop_linux/utils/docker_client.dart';

class DockerContainers extends StatelessWidget {
  DockerContainers({ Key? key }) : super(key: key);
  final DockerClient _client = DockerClient();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _client.getContainers(),
      builder: (BuildContext context, AsyncSnapshot<List<DockerContainer>> snapshot) {
        if(snapshot.hasError){
          return const Text("Error occurred");
        }

        if(snapshot.hasData){
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, idx) => DockerContainerWidget(snapshot.data![idx]),
          );
        }

        return const Text("Loading");
      },     
    );
  }
}

class DockerContainerWidget extends StatelessWidget {
  const DockerContainerWidget(this._container, { Key? key }) : super(key: key);
  final DockerContainer _container;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(_container.id ?? "Container Id not available"),  
    );
  }
}