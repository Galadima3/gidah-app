class HouseModel {
  final String name;
  final String location;
  final String address;
  final String rentPrice;
  final String displayPicture;
  final List<String> housePictures;
  final String description;
  final Map<String, Facility> facilities;

  const HouseModel(
      {required this.name,
      required this.location,
      required this.address,
      required this.displayPicture,
      required this.housePictures,
      required this.description,
      required this.facilities,
      required this.rentPrice});

  factory HouseModel.fromJson(Map<String, dynamic> json) => HouseModel(
        name: json.keys.first,
        location: json[json.keys.first]['location'],
        rentPrice: json[json.keys.first]['rentPrice'],
        address: json[json.keys.first]['address'],
        displayPicture: json[json.keys.first]['displayPicture'],
        housePictures:
            List<String>.from(json[json.keys.first]['lodgePictures']),
        description: json[json.keys.first]['description'],
        facilities: Map.from(json[json.keys.first]['facilities'])
            .map((key, value) => MapEntry(key, Facility.fromJson(value))),
      );
}

class Facility {
  final String icon;
  final String action;

  const Facility({
    required this.icon,
    required this.action,
  });

  factory Facility.fromJson(Map<String, dynamic> json) => Facility(
        icon: json['icon'],
        action: json['action'],
      );
}
