import 'package:fiservtrack/screens/auth/forgot_password_screen.dart';
import 'package:fiservtrack/screens/auth/sign_up_screen.dart';
import 'package:fiservtrack/screens/splash/splash_screen.dart';
import 'package:fiservtrack/widgets/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscurePassword = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(28.0,
              size.height * 0.02, 28.0,
              bottomPadding + 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/FiservTrack_logo_blue.png',
                      height: size.height * 0.045,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "FiservTrack",
                      style: TextStyle(
                        fontSize: size.height * 0.043,
                        fontWeight: FontWeight.w600,
                        color: AppColors.brand,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.05),

                // Header
                Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: size.height * 0.04,
                    fontWeight: FontWeight.w900,
                    color: AppColors.brand,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: size.height * 0.018,
                    color: AppColors.slate,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: size.height * 0.035),

                // Email Field
                _buildTextFieldLabel("Email", size),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  hint: "yourname@email.com",
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_passwordFocus),
                ),
                const SizedBox(height: 18),

                // Password Field
                _buildTextFieldLabel("Password", size),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  hint: "Enter your password",
                  isPassword: true,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onToggleVisibility: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                      foregroundColor: AppColors.brand,
                    ),
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: size.height * 0.016,
                        color: AppColors.brand,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.01),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.065,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BottomNavBar()),
                            (route) => false,
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
                      style: TextStyle(fontSize: size.height * 0.02, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.035),

                // Divider & Sign Up Link
                Row(
                  children: const [
                    Expanded(child: Divider(color: AppColors.cardBorder, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "or",
                        style: TextStyle(color: AppColors.slate, fontSize: 13),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.cardBorder, thickness: 1)),
                  ],
                ),
                SizedBox(height: size.height * 0.025),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: AppColors.slate, fontSize: size.height * 0.018),
                    ),
                    GestureDetector(
                      // FIX: was empty — now navigates to SignUpScreen
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: AppColors.brand,
                          fontWeight: FontWeight.bold,
                          fontSize: size.height * 0.018,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldLabel(String text, Size size) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size.height * 0.016,
        color: AppColors.charcoal,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    FocusNode? focusNode,
    bool isPassword = false,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    VoidCallback? onToggleVisibility,
    ValueChanged<String>? onSubmitted,
  }) {
    return Focus(
      child: Builder(
        builder: (context) {
          final isFocused = Focus.of(context).hasFocus;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                // FIX: focus-aware border
                color: isFocused
                    ? AppColors.brand
                    : AppColors.cardBorder,
                width: isFocused ? 1.5 : 1.0,
              ),
              boxShadow: isFocused
                  ? [
                BoxShadow(
                  color: AppColors.brand.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
                  : [],
            ),
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureText,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              onSubmitted: onSubmitted,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: hint,
                // FIX: hint text now visually distinct from typed text
                hintStyle: const TextStyle(
                  color: AppColors.slateLight,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
                suffixIcon: isPassword
                    ? IconButton(
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.inkMuted,
                    size: 20,
                  ),
                  onPressed: onToggleVisibility,
                )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}