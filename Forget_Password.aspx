<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Forget_Password.aspx.cs" Inherits="Forget_Password" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="utf-8" />
    <title>Email OTP Verification</title>

    <style>
        body {
            margin: 0;
            padding: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            background: linear-gradient(180deg, rgba(0,0,0,0.85), rgba(0,0,0,0.95)), url('Pictures/Background.jpg') no-repeat center center fixed;
            background-size: cover;
            color: #fff;
        }

        .container {
            width: 420px;
            background: linear-gradient(180deg, rgba(255,255,255,0.02), rgba(0,0,0,0.35));
            padding: 36px;
            border-radius: 14px;
            border: 2px solid rgba(255,215,0,0.15);
            box-shadow: 0 10px 40px rgba(255,215,0,0.18);
            box-sizing: border-box;
            position: relative;
        }

            .container::before {
                content: "";
                position: absolute;
                inset: 8px;
                border-radius: 12px;
                pointer-events: none;
                box-shadow: 0 0 0 2px rgba(255,215,0,0.03) inset;
            }

        /* TOP HEADER */
        .app-title {
            text-align: center;
            margin-bottom: 6px;
            font-size: 22px;
            font-weight: 700;
            color: #ffd700;
        }

        .app-subtitle {
            text-align: center;
            margin-bottom: 20px;
            font-size: 14px;
            color: #cfcfcf;
            margin-top: -4px;
        }

        h2 {
            margin: 0;
            text-align: center;
            color: #ffd700;
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .msg {
            min-height: 22px;
            text-align: center;
            margin-bottom: 14px;
            color: #ffd700;
            font-weight: 600;
            font-size: 14px;
            display: block;
        }

        label {
            display: block;
            margin-bottom: 6px;
            margin-top: 16px;
            font-weight: 600;
            color: #e4e4e4;
        }

        .textbox {
            width: 100%;
            padding: 12px;
            background: #0f0f10;
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 8px;
            color: #fff;
            font-size: 15px;
            margin-bottom: 16px;
            transition: 0.25s ease;
        }

            .textbox:focus {
                outline: none;
                border-color: #ffd700;
                box-shadow: 0 6px 18px rgba(255,215,0,0.15);
                transform: translateY(-1px);
            }

        .btn {
            width: 100%;
            padding: 14px;
            background: linear-gradient(90deg, #ffd700, #ffe873);
            border: none;
            border-radius: 8px;
            font-weight: 700;
            font-size: 15px;
            color: #000;
            cursor: pointer;
            margin-bottom: 20px;
            transition: 0.2s ease;
        }

            .btn:hover {
                background: #ffe873;
                transform: translateY(-3px);
                box-shadow: 0 18px 40px rgba(255,215,0,0.12);
            }

        hr {
            border: none;
            height: 1px;
            background: rgba(255,255,255,0.05);
            margin: 26px 0;
        }

        .back-link {
            text-align: center;
            margin-top: -10px;
            margin-bottom: 15px;
        }

            .back-link a {
                color: #ffd700;
                font-weight: 600;
                text-decoration: none;
            }

                .back-link a:hover {
                    color: #fff;
                    text-shadow: 0 0 8px rgba(255,215,0,0.5);
                }

        /* FOOTNOTE */
        .note {
            margin-top: 12px;
            font-size: 13px;
            color: #ccc;
            text-align: center;
        }

        @media (max-width: 450px) {
            .container {
                width: 90%;
                padding: 24px;
            }
        }
    </style>
</head>

<body>

    <form id="form1" runat="server">
        <div class="container">

            <!-- APP TITLE (TOP) -->
            <div class="app-title">Classroom Gazette</div>
            <div class="app-subtitle">Secure password reset</div>

            <asp:Label ID="lblMsg" runat="server" CssClass="msg"></asp:Label>

            <label>Email Address</label>
            <asp:TextBox ID="txtEmail" runat="server" CssClass="textbox" placeholder="you@example.com" />

            <asp:Button ID="btnSendOtp" runat="server" Text="Send OTP" CssClass="btn" OnClick="btnSendOtp_Click" />

            <hr />

            <label>Enter OTP</label>
            <asp:TextBox ID="txtOtp" runat="server" CssClass="textbox" placeholder="6-digit code" OnTextChanged="txtOtp_TextChanged" />

            <asp:Button ID="btnVerify" runat="server" Text="Verify OTP" CssClass="btn" OnClick="btnVerify_Click" />

            <div class="back-link">
                <a href="Login.aspx">← Back to Login</a>
            </div>

            <!-- FOOTNOTE MESSAGE -->
            <div class="note">
                Do not share your OTP. This code expires in 10 minutes.
            </div>

        </div>
    </form>

</body>
</html>
