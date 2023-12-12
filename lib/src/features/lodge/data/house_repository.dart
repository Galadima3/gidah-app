// import 'package:flutter/material.dart';

// class House {
//   final String name;
//   final String address;
//   final String displayPicture;
//   final List<String> lodgePictures;
//   final String description;
//   final Map<String, IconButton> facilities;

//   House({
//     required this.address,
//     required this.lodgePictures,
//     required this.name,
//     required this.displayPicture,
//     required this.description,
//     required this.facilities,
//   });

//   factory House.fromJson(Map<String, dynamic> json) {
//     return House(
//       name: json['name'],
//       address: json['address'],
//       displayPicture: json['displayPicture'],
//       lodgePictures: List<String>.from(json['lodgePictures']),
//       description: json['description'],
//       facilities: Map<String, IconButton>.from(json['facilities']),
//     );
//   }
// }

// class HouseLocation {
//   final Map<String, List<House>> locations;

//   HouseLocation({required this.locations});

//   factory HouseLocation.fromJson(Map<String, dynamic> json) {
//     Map<String, List<House>> locations = {};
//     json.forEach((location, houses) {
//       List<House> houseList = [];
//       for (var houseData in houses) {
//         houseList.add(House.fromJson(houseData));
//       }
//       locations[location] = houseList;
//     });

//     return HouseLocation(locations: locations);
//   }
// }

// class HouseListView extends StatelessWidget {
//   final HouseLocation houseLocation;

//   HouseListView({required this.houseLocation});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('House List'),
//       ),
//       body: ListView.builder(
//         itemCount: houseLocation.locations.length,
//         itemBuilder: (context, index) {
//           String location = houseLocation.locations.keys.elementAt(index);
//           List<House> houses = houseLocation.locations[location]!;

//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   location,
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: ClampingScrollPhysics(),
//                 itemCount: houses.length,
//                 itemBuilder: (context, index) {
//                   House house = houses[index];
//                   return ListTile(
//                     title: Text(house.name),
//                     subtitle: Text('Location: $location'),
//                     leading: CircleAvatar(
//                       backgroundImage: AssetImage(house.displayPicture),
//                     ),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HouseDetailsPage(house: house),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//               Divider(),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class HouseDetailsPage extends StatelessWidget {
//   final House house;

//   HouseDetailsPage({required this.house});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(house.name),
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Image.asset(
//             house.displayPicture,
//             height: 200,
//             width: 200,
//           ),
//           SizedBox(height: 20),
//           Text(
//             'Location: ${house.name}',
//             style: TextStyle(fontSize: 18),
//           ),
//           // Add other details as needed
//         ],
//       ),
//     );
//   }
// }

// void main() {
//   Map<String, dynamic> jsonData = {
//     'New York': [
//       {
//         'name': 'Cozy Apartment',
//         'address': '123 Main St',
//         'displayPicture': 'cozy_apartment.jpg',
//         'lodgePictures': ['image1.jpg', 'image2.jpg'],
//         'description': 'A cozy place to stay.',
//         'facilities': {
//           'WiFi': IconButton(icon: Icon(Icons.wifi), onPressed: () {})
//         }
//       },
//       // Add more houses as needed
//     ],
//     'San Francisco': [
//       {
//         'name': 'City View Condo',
//         'address': '456 Downtown Ave',
//         'displayPicture': 'city_view_condo.jpg',
//         'lodgePictures': ['image3.jpg', 'image4.jpg'],
//         'description': 'Luxurious condo with a view.',
//         'facilities': {
//           'Pool': IconButton(icon: Icon(Icons.pool), onPressed: () {})
//         }
//       },
//       // Add more houses as needed
//     ],
//   };

//   HouseLocation houseLocation = HouseLocation.fromJson(jsonData);

//   runApp(
//     MaterialApp(
//       home: HouseListView(houseLocation: houseLocation),
//     ),
//   );
// }
