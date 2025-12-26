<%@ Page Language="C#" AutoEventWireup="true" CodeFile="New_Password.aspx.cs" Inherits="New_Password" UnobtrusiveValidationMode="None" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <title>Classroom Gazette - Secure password reset</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <style>
        /* --- Black & Yellow Theme --- */
        * {
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
            margin: 0;
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
            /* Final correct background with your image */
            background: linear-gradient(180deg, rgba(0,0,0,0.85), rgba(0,0,0,0.95)), url('Pictures/Background.jpg') no-repeat center center fixed;
            background-size: cover;
        }
        .wrap {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 32px;
        }

        .card {
            width: 100%;
            max-width: 460px;
            background: #0d0d0d;
            border-radius: 14px;
            padding: 28px;
            box-shadow: 0 0 25px rgba(255, 222, 89, 0.25);
            border: 1px solid rgba(255, 225, 0, 0.2);
        }

        .brand h1 {
            font-size: 20px;
            margin: 0;
            color: #ffda2a;
            letter-spacing: 1px;
        }

        .brand p {
            margin: 6px 0 0;
            font-size: 13px;
            color: #d0d0d0;
        }

        label {
            display: block;
            font-size: 13px;
            color: #ffda2a;
            margin-bottom: 6px;
        }

        input[type="email"], input[type="password"] {
            width: 100%;
            padding: 12px 14px;
            border-radius: 10px;
            border: 1px solid #333;
            background: #1a1a1a;
            color: #ffe066;
            outline: none;
        }

        input:focus {
            border-color: #ffda2a;
            box-shadow: 0 0 10px rgba(255, 215, 50, 0.4);
        }

        .btn {
            width: 100%;
            padding: 12px 16px;
            font-size: 15px;
            border-radius: 10px;
            border: none;
            cursor: pointer;
            background: linear-gradient(90deg,#ffcc00,#ffb700);
            color: #000;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(255, 215, 0, 0.3);
            transition: 0.2s;
        }

            .btn:hover {
                background: linear-gradient(90deg,#ffe066,#ffd24d);
                transform: scale(1.02);
            }

        button[id^="toggle"] {
            color: #ffda2a;
        }

        .back-link {
            font-size: 13px;
            color: #ffda2a;
            text-decoration: none;
        }

        .validation-summary {
            background: #332b00;
            color: #ffeb99;
            padding: 10px 12px;
            border-radius: 8px;
            border: 1px solid #ffda2a;
            margin-bottom: 12px;
            font-size: 13px;
        }

        .hint {
            margin-top: 16px;
            padding: 12px 14px;
            background: #2a2400;
            border-radius: 8px;
            border: 1px solid #ffda2a;
            color: #ffe899;
            font-size: 13px;
        }

        .card span {
            color: #e6e6e6;
        }
    </style>

    <script>
        function toggleShow(id, toggleBtnId) {
            var inp = document.getElementById(id);
            var btn = document.getElementById(toggleBtnId);
            if (!inp) return;
            if (inp.type === "password") {
                inp.type = "text";
                btn.innerText = "Hide";
            } else {
                inp.type = "password";
                btn.innerText = "Show";
            }
        }

        function watchForm() {
            var email = document.getElementById('txtEmail');
            var pwd = document.getElementById('txtPassword');
            var cpwd = document.getElementById('txtConfirmPassword');
            var btn = document.getElementById('btnChange');

            function update() {
                btn.disabled = !(email.value.trim() && pwd.value && cpwd.value && (pwd.value === cpwd.value));
            }

            if (email) email.addEventListener('input', update);
            if (pwd) pwd.addEventListener('input', update);
            if (cpwd) cpwd.addEventListener('input', update);
            update();
        }

        window.addEventListener('load', watchForm);
    </script>
</head>

<body>
    <div class="wrap">
        <div class="card" role="main" aria-labelledby="pageTitle">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 14px;">
                <div class="brand">
                    <h1 id="pageTitle">Classroom Gazette</h1>
                    <p>Secure password reset</p>
                </div>

                <div>
                    <a class="back-link" href="Login.aspx">&larr; Back To Login!</a>
                </div>
            </div>

            <form id="form1" runat="server" novalidate>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server"
                    CssClass="validation-summary"
                    HeaderText="Please correct the following:"
                    EnableClientScript="true"
                    ShowMessageBox="false"
                    ShowSummary="true" />

                <div style="margin-bottom: 14px;">
                    <label for="txtEmail">Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" ClientIDMode="Static"
                        TextMode="Email" placeholder="your.email@example.com"></asp:TextBox>

                    <asp:RequiredFieldValidator ID="reqEmail" runat="server"
                        ControlToValidate="txtEmail" ErrorMessage="Email is required."
                        Display="Dynamic"></asp:RequiredFieldValidator>
                </div>

                <div style="margin-bottom: 14px;">
                    <label for="txtPassword">Password</label>
                    <div style="position: relative;">
                        <asp:TextBox ID="txtPassword" runat="server" ClientIDMode="Static"
                            TextMode="Password" placeholder="New password (min 8 chars)"></asp:TextBox>

                        <button type="button" id="togglePwd"
                            onclick="toggleShow('txtPassword','togglePwd')"
                            style="position: absolute; right: 6px; top: 6px; background: none; border: none; cursor: pointer;">
                            Show
                        </button>
                    </div>

                    <asp:RequiredFieldValidator ID="reqPwd" runat="server"
                        ControlToValidate="txtPassword" ErrorMessage="Password required."
                        Display="Dynamic"></asp:RequiredFieldValidator>

                    <asp:RegularExpressionValidator ID="pwdPattern" runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password must be at least 8 characters."
                        ValidationExpression="^.{8,}$"
                        Display="Dynamic"></asp:RegularExpressionValidator>
                </div>

                <div style="margin-bottom: 14px;">
                    <label for="txtConfirmPassword">Confirm Password</label>
                    <div style="position: relative;">
                        <asp:TextBox ID="txtConfirmPassword" runat="server" ClientIDMode="Static"
                            TextMode="Password" placeholder="Repeat your new password"></asp:TextBox>

                        <button type="button" id="toggleCpwd"
                            onclick="toggleShow('txtConfirmPassword','toggleCpwd')"
                            style="position: absolute; right: 6px; top: 6px; background: none; border: none; cursor: pointer;">
                            Show
                        </button>
                    </div>

                    <asp:RequiredFieldValidator ID="reqCpwd" runat="server"
                        ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Confirm your password."
                        Display="Dynamic"></asp:RequiredFieldValidator>

                    <asp:CompareValidator ID="cmpPwd" runat="server"
                        ControlToCompare="txtPassword"
                        ControlToValidate="txtConfirmPassword"
                        ErrorMessage="Passwords do not match."
                        Display="Dynamic"></asp:CompareValidator>
                </div>

                <asp:Button ID="btnChange" runat="server" CssClass="btn"
                    Text="Change Password" OnClick="btnChange_Click" ClientIDMode="Static" />

                <div class="hint">
                    Do not share your OTP. This code expires in 10 minutes.
                </div>

                <div style="text-align: center; margin-top: 12px; font-size: 13px;">
                    <span>By resetting, you agree to Classroom Gazette terms.</span>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
