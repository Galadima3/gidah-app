import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gidah/src/features/auth/data/auth_repository.dart';
import 'package:gidah/src/features/auth/presentation/screens/login_screen.dart';

import 'package:gidah/src/features/profile/data/profile_repository.dart';
import 'package:gidah/src/features/profile/presentation/screens/edit_profile_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late List<Map<String, dynamic>> settings;
  late bool _isDarkThemeEnabled;

  void toggleDarkTheme() {
    setState(() {
      _isDarkThemeEnabled = !_isDarkThemeEnabled;
    });
  }

  void editProfile() {
    // Implement the action for 'Edit Profile'
    log('Editing profile');
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) {
        return const EditProfileScreen();
      },
    ));
  }

  void openPayment() {
    // Implement the action for 'Payment'
    log('Opening payment');
  }

  void showNotifications() {
    // Implement the action for 'Notifications'
    log('Showing notifications');
  }

  void showSecurity() {
    // Implement the action for 'Security'
    log('Showing security');
  }

  void openHelp() {
    // Implement the action for 'Help'
    log('Opening help');
  }

  void logout() async {
    await showLogoutDialog(context);
    log('Logging out');
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sure you want to log out?'),
          content: const Text(
              'This will clear your session and log you out of the app.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () async {
                await _logOutLogic(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _logOutLogic(BuildContext context) async {
    // Clear user data (e.g., shared preferences)
    ref.read(authRepositoryProvider).signOut().then(
        (value) => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            )));
  }

  @override
  void initState() {
    super.initState();
    settings = [
      {
        'title': 'Edit Profile',
        'icon': Icons.person,
        'action': () => editProfile()
      },
      {
        'title': 'Payment',
        'icon': Icons.payment,
        'action': () => openPayment()
      },
      {
        'title': 'Notifications',
        'icon': Icons.notifications,
        'action': () => showNotifications()
      },
      {
        'title': 'Security',
        'icon': Icons.security,
        'action': () => showSecurity()
      },
      {'title': 'Help', 'icon': Icons.help, 'action': () => openHelp()},
      {
        'title': 'Dark Theme',
        'icon': Icons.brightness_2,
        'type': 'switch',
        'action': () => toggleDarkTheme()
      },
      {'title': 'Logout', 'icon': Icons.exit_to_app, 'action': () => logout()},
    ];
    _isDarkThemeEnabled = false; // Initialize the state for the Dark Theme
  }

  @override
  Widget build(BuildContext context) {
    final profileDetail = ref.watch(profileInfoProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile '),
        ),
        body: profileDetail.when(
          data: (data) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.5, horizontal: 8.0),
                child: Column(
                  children: [
                    //Profile Image
                    CircleAvatar(
                      radius: 50.r,
                      backgroundColor: const Color(0xffFDCF09),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image(
                          image: data?.profileImage == null
                              ? const AssetImage('asset/images/default.png')
                                  as ImageProvider<Object>
                              : NetworkImage(data?.profileImage ?? ''),
                          width: 100.w,
                          height: 100.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    //Name
                    Padding(
                      padding: const EdgeInsets.all(6.5),
                      child: Text(
                        data!.fullName,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.sp,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    //email
                    Padding(
                      padding: const EdgeInsets.all(4),
                      child: Text(
                        data.email,
                        style: TextStyle(
                          color: const Color(0xFF242424),
                          fontSize: 14.sp,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.w400,
                          height: 0.10.h,
                          letterSpacing: 0.20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 385.h,
                      width: double.infinity,
                      child: ListView.builder(
                        itemCount: settings.length,
                        itemBuilder: (context, index) {
                          final setting = settings[index];
                          if (setting['type'] == 'switch') {
                            return SwitchListTile(
                              title: Text(setting['title'] as String),
                              value: _isDarkThemeEnabled,
                              onChanged: (bool newValue) {
                                toggleDarkTheme();
                                setting['action']();
                              },
                              secondary: Icon(setting['icon'] as IconData),
                            );
                          } else {
                            return ListTile(
                              title: Text(setting['title'] as String),
                              leading: Icon(setting['icon'] as IconData),
                              onTap: () {
                                setting['action']();
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          error: (error, stackTrace) =>
              CustomScreen(input: Text(error.toString())),
          loading: () => const CustomScreen(
            input: CircularProgressIndicator.adaptive(),
          ),
        ));
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
