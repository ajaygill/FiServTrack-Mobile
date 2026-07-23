import 'package:fiservtrack/screens/auth/sign_in_screen.dart';
import 'package:fiservtrack/screens/auth/sign_up_screen.dart';
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../public_key/public_key_provider.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPublicKey();
    });
  }

  Future<void> _fetchPublicKey() async {
    final provider = Provider.of<PublicKeyProvider>(context, listen: false);

    final success = await provider.fetchPublicKey();

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? "Failed to load public key")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: size.height),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: size.height * 0.42,
                  color: AppColors.brand,
                  child: SafeArea(
                    bottom: false,
                    child: Image.asset(
                      'assets/images/App_bg.png',
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomCenter,
                    ),
                  ),
                ),

                Expanded(
                  child: Container(
                    color: AppColors.surface,
                    padding: EdgeInsets.fromLTRB(
                      32,
                      24,
                      32,
                      size.height * 0.08,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to\nFiservTrack",
                          style: TextStyle(
                            fontSize: size.height * 0.040,
                            fontWeight: FontWeight.w900,
                            color: AppColors.brand,
                            height: 1.1,
                            letterSpacing: -0.5,
                          ),
                        ),

                        SizedBox(height: size.height * 0.015),

                        Text(
                          "Take control of your finances",
                          style: TextStyle(
                            fontSize: size.height * 0.02,
                            color: AppColors.slate,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const Spacer(),

                        SizedBox(
                          width: double.infinity,
                          height: size.height * 0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignInScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brand,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: size.height * 0.02),

                        SizedBox(
                          width: double.infinity,
                          height: size.height * 0.07,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const SignUpScreen(),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.brand,
                              side: const BorderSide(
                                color: AppColors.brand,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//
//     return Scaffold(
//       backgroundColor: AppColors.surface,
//       body: SingleChildScrollView(
//         physics: const BouncingScrollPhysics(),
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             minHeight: size.height,
//           ),
//           child: IntrinsicHeight(
//             child: Column(
//               children: [
//                 // Top Image Graphic
//                 Container(
//                   width: double.infinity,
//                   height: size.height * 0.42,
//                   color: AppColors.brand, // Matches the very top of the image
//                   child: SafeArea(
//                     bottom: false, // Only protect the top (notch/status bar)
//                     child: Image.asset(
//                        'assets/images/App_bg.png',
//                       width: double.infinity,
//                       height: double.infinity,
//                       fit: BoxFit.fitWidth, // Forces image to cover the container relative area
//                       alignment: Alignment.bottomCenter,
//                     ),
//                   ),
//                 ),
//
//                 // Bottom Content Section
//                 Expanded(
//                   child: Container(
//                     color: AppColors.surface,
//                     padding: EdgeInsets.fromLTRB(32, 24, 32, size.height * 0.08),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Welcome to\nFiservTrack",
//                           style: TextStyle(
//                             fontSize: size.height * 0.040,
//                             fontWeight: FontWeight.w900,
//                             color: AppColors.brand,
//                             height: 1.1,
//                             letterSpacing: -0.5,
//                           ),
//                         ),
//                         SizedBox(height: size.height * 0.015),
//                         Text(
//                           "Take control of your finances",
//                           style: TextStyle(
//                             fontSize: size.height * 0.02,
//                             color: AppColors.slate,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                         const Spacer(),
//
//                         // Sign In Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: size.height * 0.07,
//                           child: ElevatedButton(
//                             onPressed: () {
//                               // Navigate to Sign In Screen
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => const SignInScreen()),
//                               );
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: AppColors.brand,
//                               foregroundColor: Colors.white,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                             ),
//                             child: Text(
//                               "Sign In",
//                               style: TextStyle(fontSize: size.height * 0.02, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                         SizedBox(height: size.height * 0.02),
//
//                         // Sign Up Button
//                         SizedBox(
//                           width: double.infinity,
//                           height: size.height * 0.07,
//                           child: OutlinedButton(
//                             onPressed: () {
//                               // Navigate to Sign Up Screen
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(builder: (context) => const SignUpScreen()),
//                               );
//                             },
//                             style: OutlinedButton.styleFrom(
//                               foregroundColor: AppColors.brand,
//                               side: const BorderSide(color: AppColors.brand, width: 1.5),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(14),
//                               ),
//                             ),
//                             child: Text(
//                               "Sign Up",
//                               style: TextStyle(fontSize: size.height * 0.02, fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ),
//                         const Spacer(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
