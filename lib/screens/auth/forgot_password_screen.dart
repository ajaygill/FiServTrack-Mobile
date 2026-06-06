import 'package:fiservtrack/themes/app_color.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _emailSent = false;
  String _enteredEmail = '';

  @override
  void dispose() {
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _enteredEmail = _emailController.text.trim();
    });

    // Simulate network delay for verification
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _emailSent = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16, top: 8),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.cardBorder, width: 1.5),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink, size: 16),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(28.0, 0.0, 28.0, bottomPadding + 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  SizedBox(height: size.height * 0.035),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _emailSent ? _buildSuccessState(size) : _buildFormState(size),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Form Entry State ──
  Widget _buildFormState(Size size) {
    return Column(
      key: const ValueKey('form_state'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Illustration icon
        Center(
          child: Container(
            width: size.height * 0.1,
            height: size.height * 0.1,
            decoration: BoxDecoration(
              color: AppColors.brandPale,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_reset_rounded,
              color: AppColors.brandMid,
              size: size.height * 0.05,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.04),

        // Headers
        Text(
          "Forgot Password",
          style: TextStyle(
            fontSize: size.height * 0.035,
            fontWeight: FontWeight.w900,
            color: AppColors.brand,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter your registered email address. We will send a secure link to reset your account password.",
          style: TextStyle(
            fontSize: size.height * 0.017,
            color: AppColors.slate,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
        SizedBox(height: size.height * 0.04),

        // Email Label & Field
        _buildTextFieldLabel("Email Address", size),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _emailController,
          focusNode: _emailFocus,
          hint: "yourname@email.com",
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your email address";
            }
            final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
            if (!emailRegex.hasMatch(value)) {
              return "Please enter a valid email address";
            }
            return null;
          },
        ),
        SizedBox(height: size.height * 0.04),

        // Action Button
        SizedBox(
          width: double.infinity,
          height: size.height * 0.065,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleResetPassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brand,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    "Send Reset Link",
                    style: TextStyle(fontSize: size.height * 0.02, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }

  // ── Success Confirmation State ──
  Widget _buildSuccessState(Size size) {
    return Column(
      key: const ValueKey('success_state'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Success illustration icon
        Center(
          child: Container(
            width: size.height * 0.1,
            height: size.height * 0.1,
            decoration: BoxDecoration(
              color: AppColors.greenBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_read_rounded,
              color: AppColors.green,
              size: size.height * 0.05,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.04),

        // Headers
        Text(
          "Check Your Email",
          style: TextStyle(
            fontSize: size.height * 0.035,
            fontWeight: FontWeight.w900,
            color: AppColors.brand,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: size.height * 0.017,
              color: AppColors.slate,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: "We have sent a secure password reset link to "),
              TextSpan(
                text: _enteredEmail,
                style: const TextStyle(
                  color: AppColors.ink,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const TextSpan(text: ". Click the link inside that email to set a new password."),
            ],
          ),
        ),
        SizedBox(height: size.height * 0.045),

        // Action Buttons
        SizedBox(
          width: double.infinity,
          height: size.height * 0.065,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
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
              "Return to Sign In",
              style: TextStyle(fontSize: size.height * 0.02, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: TextButton(
            onPressed: () {
              // Resend action with feedback
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Reset link resent successfully"),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppColors.brand,
            ),
            child: const Text(
              "Didn't receive email? Resend Link",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  // ── Form Builders (matching SignIn style) ──
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
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    FormFieldValidator<String>? validator,
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
                color: isFocused ? AppColors.brand : AppColors.cardBorder,
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
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              validator: validator,
              style: const TextStyle(
                color: AppColors.ink,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  color: AppColors.slateLight,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
              ),
            ),
          );
        },
      ),
    );
  }
}