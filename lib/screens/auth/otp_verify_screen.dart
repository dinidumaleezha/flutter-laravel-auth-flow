import 'package:boommusic/screens/auth/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class OtpVerifyScreen extends StatelessWidget {
  final String email;
  final TextEditingController otpController = TextEditingController();

  OtpVerifyScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                "Verify Code",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 8),

              RichText(
                text: TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.grey[600], height: 1.4),
                  children: [
                    TextSpan(text: "We sent a 6-digit verification code to\n"),
                    TextSpan(
                      text: email,
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // OTP Input Field Label
              Text(
                "Enter 6-Digit OTP",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100], // Soft background container
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 8.0
                  ),
                  decoration: InputDecoration(
                    hintText: "000000",
                    hintStyle: TextStyle(color: Colors.grey[400], letterSpacing: 8.0),
                    border: InputBorder.none,
                    counterText: "",
                    contentPadding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

              // Error Message Display
              if (authProvider.errorMessage != null) ...[
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        authProvider.errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 40),

              // Uber-Style Full Width Verify Button
              authProvider.isLoading
                  ? Center(child: CircularProgressIndicator(color: Colors.black))
                  : SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () async {
                    bool success = await authProvider.verifyOtp(email, otpController.text.trim());
                    if (success) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ResetPasswordScreen(email: email, otp: otpController.text.trim())
                          )
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Pure Uber Black
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Verify Code",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}