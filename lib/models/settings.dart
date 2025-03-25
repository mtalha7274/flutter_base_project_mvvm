class DeviceData {
  final String name;
  final String osVersion;
  const DeviceData(this.name, this.osVersion);
}

class DeviceInfo {
  String deviceName;
  String appVersion;
  String buildNumber;
  String osVersion;
  String? country;

  DeviceInfo(this.deviceName, this.appVersion, this.buildNumber, this.osVersion,
      {this.country});
}
