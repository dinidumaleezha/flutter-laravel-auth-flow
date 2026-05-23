<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>Boom Music - Verification Code</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background-color: #ffffff;
            margin: 0;
            padding: 40px 20px;
            color: #000000;
        }
        .container {
            max-width: 500px;
            margin: 0 auto;
            background: #ffffff;
            padding: 32px;
            border: 1px solid #e8e8e8;
            border-radius: 12px;
        }
        .logo {
            font-size: 24px;
            font-weight: bold;
            letter-spacing: -0.5px;
            margin-bottom: 30px;
        }
        .title {
            font-size: 22px;
            font-weight: 700;
            line-height: 1.3;
            margin-bottom: 12px;
        }
        .text {
            font-size: 15px;
            color: #555555;
            line-height: 1.6;
            margin-bottom: 30px;
        }
        .otp-container {
            background-color: #f3f3f3;
            padding: 16px;
            border-radius: 8px;
            text-align: center;
            margin-bottom: 30px;
        }
        .otp-code {
            font-size: 32px;
            font-weight: 800;
            letter-spacing: 6px;
            color: #000000;
            font-family: monospace;
        }
        .footer {
            font-size: 12px;
            color: #999999;
            border-top: 1px solid #eeeeee;
            padding-top: 20px;
            line-height: 1.5;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="logo">🎵 Boom Music</div>
    <div class="title">Reset Your Password</div>
    <div class="text">
        We received a request to reset your password. Use the secure 6-digit OTP code below to proceed. This code is valid for <b>15 minutes</b>.
    </div>
    
    <div class="otp-container">
        <div class="otp-code">{{ $otp }}</div>
    </div>
    
    <div class="text" style="margin-bottom: 40px;">
        If you did not request a password reset, please ignore this email or contact support if you have concerns.
    </div>
    
    <div class="footer">
        This is an automated message from Boom Music Dev Environment.<br>
        &copy; {{ date('Y') }} Boom Music. All rights reserved.
    </div>
</div>

</body>
</html>