import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gidah/src/features/lodge/domain/house_model.dart';

class HouseDetailScreen extends StatefulWidget {
  const HouseDetailScreen({super.key, required this.houseDetails});
  final HouseModel houseDetails;

  @override
  State<HouseDetailScreen> createState() => _HouseDetailScreenState();
}

class _HouseDetailScreenState extends State<HouseDetailScreen> {
  IconData getIcon(String facilityName) {
    switch (facilityName) {
      case 'WiFi':
        return Icons.wifi;
      case 'Parking Space':
        return Icons.directions_car;
      case 'Pool':
        return Icons.pool;
      case 'Gym':
        return Icons.fitness_center;
      case 'Garden':
        return Icons.yard;
      case 'Scenic View':
        return Icons.visibility;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.houseDetails.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image of the hotel
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  height: 235.h,
                  child: Image.network(
                    widget.houseDetails.displayPicture,
                    fit: BoxFit
                        .cover, // Ensure the image covers the entire container
                  ),
                ),
              ),
            ),
            Text(
              widget.houseDetails.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.5.sp,
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.w700,
              ),
            ),

            // Text details
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_pin,
                  color: Colors.green,
                ),
                Text(
                  widget.houseDetails.address,
                  style: TextStyle(
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text(
                    'Gallery Photos',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19.sp,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 150.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.houseDetails.housePictures.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 70.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12.r)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.network(
                          widget.houseDetails.housePictures[index],
                          fit: BoxFit
                              .cover, // Adjust this fit based on your preference
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  Text(
                    'Facilities',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19.sp,
                      fontFamily: 'Urbanist',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 60.h,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.houseDetails.facilities.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final facilityName =
                      widget.houseDetails.facilities.keys.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(
                          getIcon(facilityName),
                          color: Colors.black,
                        ),
                        SizedBox(width: 12.0.w),
                        Text(facilityName),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Book Now button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("₦${widget.houseDetails.rentPrice}/year"),
                
                SizedBox(
                  width: 10.w,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
