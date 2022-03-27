import 'dart:convert';
import 'package:http/http.dart';
import 'http_over_unix.dart';

// docker version
// contains all the details about the
// system the docker engine is running on
class SystemComponent {
  final String? name;
  final String? version;
  final Map<String, String>? details;
  SystemComponent(this.name, this.version, this.details);

  SystemComponent.fromJSON(Map<String, dynamic> data)
      : name = data['name'],
        version = data['version'],
        details = data['details'];
}

class DockerVersion {
  final String? platform;
  final String? version;
  final String? apiVersion;
  final String? minApiVersion;
  final String? goVersion;
  final String? os;
  final String? arch;
  final String? kernelVersion;
  final bool? experimental;
  final String? buildTime;
  final List<SystemComponent>? components;
  final String? gitCommit;

  DockerVersion({
    this.platform,
    this.version,
    this.apiVersion,
    this.minApiVersion,
    this.goVersion,
    this.os,
    this.arch,
    this.kernelVersion,
    this.experimental,
    this.buildTime,
    this.components,
    this.gitCommit,
  });

  factory DockerVersion.fromJSON(Map<String, dynamic> data) {
    List<SystemComponent> _components = data['Components']
        .map<SystemComponent>(
            (_component) => SystemComponent.fromJSON(_component))
        .toList();
    DockerVersion _version = DockerVersion(
      platform: data['Platform']['Name'],
      version: data['Version'],
      apiVersion: data['ApiVersion'],
      minApiVersion: data['MinAPIVersion'],
      goVersion: data['GoVersion'],
      os: data['Os'],
      arch: data['Arch'],
      kernelVersion: data['KernelVersion'],
      experimental: data['Experimental'],
      buildTime: data['BuildTime'],
      components: _components,
      gitCommit: data['GitCommit'],
    );
    return _version;
  }
}

// docker containers
class ContainerPort {
  final int? privatePort;
  final int? publicPort;
  final String? type;
  ContainerPort({this.privatePort, this.publicPort, this.type});

  ContainerPort.fromJSON(Map<String, dynamic> data)
      : privatePort = data['PrivatePort'],
        publicPort = data['PublicPort'],
        type = data['Type'];
}

class ContainerNetwork {
  final String? networkID;
  final String? endpointID;
  final String? gateway;
  final String? ipAddress;
  final String? ipPrefixLen;
  final String? ipv6Gateway;
  final String? globalIPv6Address;
  final String? globalIPv6PrefixLen;
  final String? macAddress;
  final String? networkType;

  ContainerNetwork({
    this.networkType,
    this.networkID,
    this.endpointID,
    this.gateway,
    this.ipAddress,
    this.ipPrefixLen,
    this.ipv6Gateway,
    this.globalIPv6Address,
    this.globalIPv6PrefixLen,
    this.macAddress,
  });

  ContainerNetwork.fromJSON(this.networkType, Map<String, dynamic> data)
      : networkID = data['NetworkID'],
        endpointID = data['EndpointID'],
        gateway = data['Gateway'],
        ipAddress = data['IPAddress'],
        ipPrefixLen = data['IPPrefixLen'],
        ipv6Gateway = data['IPv6Gateway'],
        globalIPv6Address = data['GlobalIPv6Address'],
        globalIPv6PrefixLen = data['GlobalIPv6PrefixLen'],
        macAddress = data["MacAddress"];
}

class ContainerMount {
  final String? name;
  final String? source;
  final String? destination;
  final String? driver;
  final String? mode;
  final bool? rw;
  final String? propagation;

  ContainerMount(
      {this.name,
      this.source,
      this.destination,
      this.driver,
      this.mode,
      this.rw,
      this.propagation});

  ContainerMount.fromJSON(Map<String, dynamic> data)
      : name = data['Name'],
        source = data['Source'],
        destination = data['Destination'],
        driver = data['Driver'],
        mode = data['Mode'],
        rw = data['RW'],
        propagation = data['Propagation'];
}

class DockerContainer {
  final String? id;
  final List<String>? names;
  final String? imageName;
  final String? imageId;
  final String? command;
  final String? state;
  final String? status;
  final List<ContainerPort>? ports;
  final Map<String, String>? labels;
  final int? sizeRw;
  final int? sizeRootFs;
  final int? created;
  final String? hostConfigNetworkMode;
  final List<ContainerMount>? mounts;
  final List<ContainerNetwork>? networks;

  DockerContainer({
    this.id,
    this.names,
    this.imageName,
    this.imageId,
    this.command,
    this.state,
    this.status,
    this.ports,
    this.labels,
    this.sizeRw,
    this.sizeRootFs,
    this.created,
    this.hostConfigNetworkMode,
    this.mounts,
    this.networks,
  });

  factory DockerContainer.fromJSON(Map<String, dynamic> data) {
    List<ContainerPort> _ports = data['Ports']
        .map<ContainerPort>((_port) => ContainerPort.fromJSON(_port))
        .toList();
    List<ContainerMount> _mounts = data['Mounts']
        .map<ContainerMount>((_mount) => ContainerMount.fromJSON(_mount))
        .toList();
    List<ContainerNetwork> _networks = data['NetworkSettings']['Networks']
        .map<ContainerNetwork>(
            (key, value) => ContainerNetwork.fromJSON(key, value))
        .toList();
    DockerContainer _container = DockerContainer(
      id: data['Id'],
      names: data['Names'],
      imageName: data['Image'],
      imageId: data['ImageID'],
      command: data['Command'],
      created: data['Created'],
      state: data['State'],
      status: data['Status'],
      ports: _ports,
      labels: data['Labels'],
      sizeRw: data['SizeRw'],
      sizeRootFs: data['SizeRootFs'],
      hostConfigNetworkMode: data['HostConfig']['NetworkMode'],
      mounts: _mounts,
      networks: _networks,
    );
    return _container;
  }
}

// docker images
class DockerImage {
  final String? id;
  final String? parentId;
  final List<dynamic>? repoTags;
  final List<dynamic>? repoDigests;
  final int? created;
  final int? size;
  final int? virtualSize;
  final int? sharedSize;
  final int? containers;
  final Map<String, dynamic>? labels;

  DockerImage({
    this.id,
    this.parentId,
    this.repoTags,
    this.repoDigests,
    this.created,
    this.size,
    this.virtualSize,
    this.sharedSize,
    this.containers,
    this.labels,
  });

  DockerImage.fromJSON(Map<String, dynamic> data)
      : id = data['Id'],
        parentId = data['ParentId'],
        repoTags = data['RepoTags'],
        repoDigests = data['RepoDigests'],
        created = data['Created'],
        size = data['Size'],
        virtualSize = data['VirtualSize'],
        sharedSize = data['SharedSize'],
        labels = data['Labels'],
        containers = data['Containers'];
}

// docker volumes
class DockerVolume {
  final String? name;
  final String? driver;
  final String? mountPoint;
  final Map<String, dynamic>? labels;
  final String? scope;
  final Map<String, dynamic>? options;
  final String? createdAt;

  DockerVolume(
      {this.name,
      this.driver,
      this.mountPoint,
      this.labels,
      this.scope,
      this.options,
      this.createdAt});

  DockerVolume.fromJSON(Map<String, dynamic> data)
      : name = data['Name'],
        driver = data['Driver'],
        mountPoint = data['Mountpoint'],
        labels = data['Labels'],
        scope = data['Scope'],
        options = data['Options'],
        createdAt = data['CreatedAt'];
}

// docker network
class DockerNetwork {
  final String? name, id, created, scope, driver;
  final bool? enableIPv6, internal, attachable, ingress;
  final Map<String, dynamic>? ipam, options;
  DockerNetwork({
    this.name,
    this.id,
    this.created,
    this.scope,
    this.driver,
    this.enableIPv6,
    this.internal,
    this.attachable,
    this.ingress,
    this.ipam,
    this.options,
  });

  DockerNetwork.fromJSON(Map<String, dynamic> data):
    name = data['Name'],
    id = data['Id'],
    created = data['Created'],
    scope = data['Scope'],
    driver = data['Driver'],
    enableIPv6 = data['EnableIPv6'],
    internal = data['Internal'],
    attachable = data['Attachable'],
    ingress = data['Ingress'],
    ipam = data['IPAM'],
    options = data['Options'];
}

class DockerClient {
  final HttpUnixClient _client = HttpUnixClient("/var/run/docker.sock");

  Future<DockerVersion> getVersion() async {
    Response _resp = await _client.get(Uri.http('localhost', '/version'));
    return DockerVersion.fromJSON(jsonDecode(_resp.body));
  }

  Future<List<DockerContainer>> getContainers() async {
    Response _resp = await _client
        .get(Uri.http('localhost', '/containers/json', {'all': 'true'}));
    return jsonDecode(_resp.body)
        .map<DockerContainer>(
            (_container) => DockerContainer.fromJSON(_container))
        .toList();
  }

  Future<List<DockerImage>> getImages() async {
    Response _resp = await _client.get(Uri.http('localhost', '/images/json'));
    return jsonDecode(_resp.body)
        .map<DockerImage>((_image) => DockerImage.fromJSON(_image))
        .toList();
  }

  Future<List<DockerVolume>> getVolumes() async {
    Response _resp = await _client.get(Uri.http('localhost', '/volumes'));
    return jsonDecode(_resp.body)["Volumes"]
        .map<DockerVolume>((_volume) => DockerVolume.fromJSON(_volume))
        .toList();
  }

  Future<List<DockerNetwork>> getNetworks() async {
    Response _resp = await _client.get(Uri.http('localhost', '/networks'));
    return jsonDecode(_resp.body)
        .map<DockerNetwork>((_network) => DockerNetwork.fromJSON(_network))
        .toList();
  }
}
