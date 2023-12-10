import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gidah/src/features/auth/data/auth_repository.dart';
import 'package:gidah/src/features/auth/data/firestore_repository.dart';
import 'package:gidah/src/features/auth/presentation/screens/login_screen.dart';
import 'package:gidah/src/features/profile/presentation/screens/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomeScreen> {
  final searchController = TextEditingController();
  final List<String> choices = ['Gandu', 'Bukan Koto', 'Akunza', 'Paradise'];
  final List<String> houses = [
    "https://images.unsplash.com/photo-1552189864-e05b02af1697?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHN0dWRlbnQlMjBob3VzZXxlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3R1ZGVudCUyMGhvdXNlfGVufDB8fDB8fHww",
    "https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHN0dWRlbnQlMjBob3VzZXxlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1513694203232-719a280e022f?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHN0dWRlbnQlMjBob3VzZXxlbnwwfHwwfHx8MA%3D%3D",
    "https://images.unsplash.com/photo-1535186696008-7cba739a3103?auto=format&fit=crop&q=60&w=500&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8c3R1ZGVudCUyMGhvdXNlfGVufDB8fDB8fHww"
  ];
  String selectedChoice = 'Gandu';

  void _onChipSelected(String choice) {
    setState(() {
      selectedChoice = choice;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userDetails = ref.watch(userInfoProvider);
    return userDetails.when(
      data: (data) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return const ProfileScreen();
                  },
                )),
                child: CircleAvatar(
                    radius: 5,
                    backgroundImage: NetworkImage(
                      data?.profileImage ?? '',
                    )),
              ),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_outlined)),
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.bookmark_outline)),
              IconButton(
                onPressed: () {
                  ref.read(authRepositoryProvider).signOut().then((value) =>
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      )));
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
          body: Column(
            children: [
              //Hello
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 7, horizontal: 9.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    data?.fullName == null
                        ? const Text(
                            'Hello, Unknown',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        : Text(
                            'Hello, ${data!.fullName}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ],
                ),
              ),
              //Search bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: searchController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: const Icon(Icons.tune),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              //choice chips
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 13.5),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: choices.map((choice) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(choice),
                          selected: selectedChoice == choice,
                          onSelected: (selected) {
                            _onChipSelected(choice);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              //List of houses
              SizedBox(
                height: 275,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150,
                        width: 215,
                        decoration: ShapeDecoration(
                          image: DecorationImage(
                            image: NetworkImage(houses[index]),
                            fit: BoxFit.cover,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(41),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //Ratings
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 53.5,
                                    height: 25,
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFF1AB65C),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(26.50),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 18.5,
                                            color: Colors.amber,
                                          ),
                                          Text(
                                            "5.0",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //name
                                  const Text(
                                    "Intercontinental L",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  //Location
                                  const Text(
                                    "Gandu, Lafia",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),

                                  //price & bookmark icon
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "#200,000",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.bookmark_outline,
                                            color: Colors.white,
                                          ))
                                    ],
                                  )

                                  //
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) => CustomScreen(input: Text(error.toString())),
      loading: () => const CustomScreen(
        input: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

class CustomScreen extends ConsumerStatefulWidget {
  final Widget input;
  const CustomScreen({super.key, required this.input});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomScreenState();
}

class _CustomScreenState extends ConsumerState<CustomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.input,
      ),
    );
  }
}
