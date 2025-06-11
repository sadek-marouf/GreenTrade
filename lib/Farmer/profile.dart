

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/login_bloc.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String type = '';
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String governorate = '';
  String city = '';
  String village = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // دالة لقراءة البيانات من SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      type = prefs.getString('accountType') ?? '';
      firstName = prefs.getString('firstName') ?? '';
      lastName = prefs.getString('lastName') ?? '';
      email = prefs.getString('email register') ?? '';
      phone = prefs.getString('phone') ?? '';
      governorate = prefs.getString('Governorate') ?? '';
      city = prefs.getString('City') ?? '';
      village = prefs.getString('Village') ?? '';
    });
  }
  @override
  Widget build(BuildContext context) {

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil('select', (route) => false);
        } else if (state is LogoutFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Logout failed: ${state.error}')),
          );
        }
      },
      child: Container(decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.lightGreen],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
        child: Scaffold(backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight + 10),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
              child: AppBar(
                title: Text("Profile"),
                backgroundColor: Colors.lightGreen[500],
                elevation: 6,
                shadowColor: Colors.greenAccent.shade100,
                actions: [
                  Icon(Icons.shopping_cart, color: Colors.white.withOpacity(0.9)),
                  SizedBox(width: 20),
                  Icon(Icons.notifications, color: Colors.white.withOpacity(0.9)),
                  SizedBox(width: 10),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildProfileContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        const SizedBox(height: 20),
         Text(
          '$firstName $lastName',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
         Text(type, style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 24),
        _buildProfileTile(
          icon: Icons.phone,
          title: 'Phone Number',
          subtitle: phone,
        ),
        _buildProfileTile(
          icon: Icons.email,
          title: 'Email',
          subtitle: email,
        ),
        _buildProfileTile(
          icon: Icons.location_on,
          title: 'Location',
          subtitle: '$governorate, $city, $village',
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightGreen,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          icon: const Icon(Icons.edit , color: Colors.white,),
          label: const Text('Edit Profile' ,style: TextStyle(color: Colors.white),),
          onPressed: () {
            // TODO: Navigate to edit screen
          },
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          icon: const Icon(Icons.logout ,color: Colors.white,),
          label: const Text('Log Out' ,style: TextStyle(color: Colors.white),),
          onPressed: () {
            context.read<LoginBloc>().add(LogoutRequested());
          },
        ),

      ],
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.green[700]),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
//
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         centerTitle: true,
//         backgroundColor: Colors.lightGreen,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage('assets/images/profile.png'),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               'Sadek Marof',
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 4),
//             const Text('Farmer', style: TextStyle(color: Colors.grey)),
//
//             const SizedBox(height: 24),
//
//             InkWell(
//
//               child: _buildProfileTile(
//                 icon: Icons.phone,
//                 title: 'Phone Number',
//                 subtitle: '+963 912 345 678',
//               ),
//             ),
//             _buildProfileTile(
//               icon: Icons.email,
//               title: 'Email',
//               subtitle: 'sadiq@example.com',
//             ),
//             _buildProfileTile(
//               icon: Icons.location_on,
//               title: 'Location',
//               subtitle: 'Latakia, Syria',
//             ),
//
//             const SizedBox(height: 24),
//
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green[700],
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//               icon: const Icon(Icons.edit),
//               label: const Text('Edit Profile'),
//               onPressed: () {
//                 // TODO: Navigate to edit screen
//               },
//             ),
//             const SizedBox(height: 12),
//             TextButton.icon(
//               icon: const Icon(Icons.logout),
//               label: const Text('Log Out'),
//               onPressed: () {
//                 // TODO: Perform logout
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildProfileTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         leading: Icon(icon, color: Colors.green[700]),
//         title: Text(title),
//         subtitle: Text(subtitle),
//       ),
//     );
//   }
// }
