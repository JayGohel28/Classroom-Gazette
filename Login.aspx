<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="Login.aspx.cs"
    Inherits="Login"
    UnobtrusiveValidationMode="None"
    ClientIDMode="Static" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Classroom Gazette Login</title>

    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <style>
        :root{
            --gold: #f7d400;
            --purple: #a770ef;
            --neon: #66d1ff;
            --bg-dark: #07050a;
            --panel: linear-gradient(180deg, rgba(255,255,255,0.02), rgba(0,0,0,0.05));
            --text: #eef6ff;
            --muted: #b8cfe0;
            --glass: rgba(255,255,255,0.03);
            --accent-gradient: linear-gradient(90deg, var(--purple) 0%, var(--neon) 60%, var(--gold) 100%);
            --card-border: rgba(167,117,239,0.08);
            --card-width: 420px;
            --card-maxwidth-mobile: 92%;
            --input-height: 48px;
            --radius-lg: 20px;
            --radius-sm: 10px;
        }

        /* Page background */
        html,body {
            height: 100%;
            margin: 0;
            font-family: 'Segoe UI', Arial, sans-serif;
            color: var(--text);
            background: radial-gradient(circle at 10% 10%, rgba(167,117,239,0.06), transparent 10%),
                        radial-gradient(circle at 90% 90%, rgba(102,209,255,0.03), transparent 12%),
                        var(--bg-dark);
            -webkit-font-smoothing:antialiased;
            -moz-osx-font-smoothing:grayscale;
        }

        /* Centering container */
        .page-wrap {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 32px;
            box-sizing: border-box;
            background-image: url('Pictures/Background.jpg');
            background-size: cover;
            background-position: center;
            background-attachment: fixed;
            /* subtle overlay */
            position: relative;
        }
        .page-wrap::after {
            content: "";
            position: absolute;
            inset: 0;
            background: linear-gradient(180deg, rgba(0,0,0,0.35), rgba(0,0,0,0.45));
            pointer-events: none;
        }

        /* The card */
        .login-card {
            position: relative;
            z-index: 2;
            width: var(--card-width);
            max-width: var(--card-maxwidth-mobile);
            background: var(--panel);
            border-radius: var(--radius-lg);
            padding: 36px 30px;
            box-sizing: border-box;
            box-shadow: 0 18px 48px rgba(0,0,0,0.6);
            border: 1px solid var(--card-border);
            overflow: hidden;
        }

        /* gradient highlight edge */
        .login-card::before {
            content: "";
            position: absolute;
            inset: 0;
            pointer-events: none;
            border-radius: inherit;
            padding: 1px;
            background: conic-gradient(from 210deg, rgba(255,255,255,0.02), rgba(0,0,0,0.02));
            -webkit-mask: linear-gradient(#000 0 0) content-box, linear-gradient(#000 0 0);
            mask: linear-gradient(#000 0 0) content-box, linear-gradient(#000 0 0);
        }

        /* thin accent bar at top */
        .accent-bar {
            height: 6px;
            width: 100%;
            border-radius: 8px;
            margin-bottom: 18px;
            background: var(--accent-gradient);
            box-shadow: 0 6px 18px rgba(167,117,239,0.08);
        }

        .login-card h2 {
            color: var(--gold);
            text-align: center;
            margin: 0 0 6px;
            font-size: 28px;
            font-weight: 800;
            letter-spacing: 0.4px;
        }

        .login-card p {
            color: var(--muted);
            text-align: center;
            margin-bottom: 18px;
            font-size: 13px;
            opacity: 0.95;
        }

        .field-group {
            width: 100%;
            margin-bottom: 14px;
            display: flex;
            flex-direction: column;
        }

        .field-group label {
            color: var(--text);
            font-weight: 700;
            margin-bottom: 8px;
            font-size: 13px;
        }

        .login-card input,
        .login-card select {
            width: 100%;
            height: var(--input-height);
            padding: 10px 14px;
            border-radius: var(--radius-sm);
            border: 1px solid rgba(255,255,255,0.06);
            background: rgba(0,0,0,0.45);
            color: var(--text);
            font-size: 15px;
            outline: none;
            box-sizing: border-box;
            transition: 0.15s ease;
            -webkit-appearance: none;
        }

        .login-card input::placeholder {
            color: rgba(238,246,255,0.55);
        }

        .login-card input:focus,
        .login-card select:focus {
            border-color: var(--gold);
            box-shadow: 0 6px 22px rgba(247,212,0,0.06), 0 0 10px rgba(167,117,239,0.04);
            background: rgba(0,0,0,0.65);
        }

        /* Dropdown arrow polish */
        .login-card select {
            appearance: none;
            background-image: linear-gradient(45deg, transparent 50%, rgba(238,246,255,0.12) 50%),
                              linear-gradient(135deg, rgba(238,246,255,0.12) 50%, transparent 50%);
            background-position: calc(100% - 18px) calc(1em + 2px), calc(100% - 13px) calc(1em + 2px);
            background-size: 6px 6px, 6px 6px;
            background-repeat: no-repeat;
            padding-right: 44px;
        }

        .forgot {
            text-align: right;
            font-size: 13px;
            margin-bottom: 6px;
        }

        .forgot a {
            color: var(--gold);
            text-decoration: none;
            font-weight: 700;
        }

        .forgot a:hover {
            text-decoration: underline;
        }

        .aspNet-Button {
            width: 100%;
            height: 50px;
            border-radius: 12px;
            border: none;
            background: linear-gradient(135deg, var(--gold), #ffef9a);
            font-size: 16px;
            font-weight: 800;
            color: #111;
            cursor: pointer;
            margin-top: 6px;
            box-shadow: 0 10px 28px rgba(247,212,0,0.18);
            transition: transform .12s ease, box-shadow .12s ease;
        }

        .aspNet-Button:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 38px rgba(247,212,0,0.25);
        }

        .bottom-link {
            text-align: center;
            color: var(--muted);
            font-size: 14px;
            margin-top: 14px;
        }

        .bottom-link a {
            color: var(--gold);
            font-weight: 700;
            text-decoration: none;
        }

        .back-home {
            margin-top: 16px;
            font-size: 14px;
            text-align: center;
        }

        .back-home a {
            color: var(--neon);
            font-weight: 700;
            text-decoration: none;
        }

        .val-error {
            color: #ff6b6b;
            font-size: 12px;
            margin-top: 6px;
        }

        .val-summary {
            background: rgba(150,0,0,0.6);
            border: 1px solid #ff6b6b;
            color: #fff;
            padding: 10px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 14px;
        }

        /* client validation box (JS) */
        .client-errors {
            display: none;
            background: rgba(255, 100, 100, 0.08);
            border: 1px solid rgba(255, 100, 100, 0.18);
            color: #ffdede;
            padding: 10px;
            border-radius: 8px;
            font-size: 13px;
            margin-bottom: 12px;
        }
        .client-errors ul { margin: 0 0 0 18px; padding: 0; color: #ffdede; }

        /* small screens */
        @media (max-width: 520px) {
            :root { --card-width: 94%; }
            .login-card { padding: 24px; border-radius: 14px; }
            .login-card h2 { font-size: 22px; }
            .aspNet-Button { height: 46px; font-size: 15px; }
        }
    </style>

    <script type="text/javascript">
        function validateForm() {
            // clear previous
            var errors = [];
            var userType = document.getElementById('ddlUserType').value || '';
            var username = (document.getElementById('txtUsername').value || '').trim();
            var password = (document.getElementById('txtPassword').value || '');

            if (!userType) {
                errors.push("Please select a user type.");
            }
            if (!username) {
                errors.push("Username is required.");
            } else if (username.length < 3) {
                errors.push("Username must be at least 3 characters.");
            }
            if (!password) {
                errors.push("Password is required.");
            } else if (password.length < 6) {
                errors.push("Password must be at least 6 characters.");
            }

            var container = document.getElementById('clientErrors');
            var list = document.getElementById('clientErrorsList');

            if (errors.length > 0) {
                // show errors
                container.style.display = 'block';
                // clear old
                list.innerHTML = '';
                for (var i = 0; i < errors.length; i++) {
                    var li = document.createElement('li');
                    li.textContent = errors[i];
                    list.appendChild(li);
                }
                // scroll into view on mobile
                container.scrollIntoView({ behavior: 'smooth', block: 'center' });
                return false; // prevent postback
            } else {
                // hide if previously visible
                container.style.display = 'none';
                list.innerHTML = '';
                return true; // allow postback
            }
        }

        // optional: allow pressing Enter to submit when fields valid
        document.addEventListener('DOMContentLoaded', function () {
            var form = document.getElementById('form1');
            form.addEventListener('keydown', function (e) {
                if (e.key === 'Enter') {
                    // Trigger full validation (returning false will prevent server submit)
                    if (!validateForm()) {
                        e.preventDefault();
                        return false;
                    }
                }
            });
        });
    </script>
</head>

<body>
    <form id="form1" runat="server">

        <div class="page-wrap">
            <div class="login-card">

                <div class="accent-bar" aria-hidden="true"></div>

                <h2>Login</h2>
                <p>Welcome back — sign in to continue to Classroom Gazette</p>

                <!-- Client-side validation summary (JS) -->
                <div id="clientErrors" class="client-errors" role="alert" aria-live="polite">
                    <strong>There are some problems:</strong>
                    <ul id="clientErrorsList"></ul>
                </div>

                <!-- Server-side Validation Summary (keeps working) -->
                <asp:ValidationSummary ID="valSummary" runat="server"
                    CssClass="val-summary"
                    ShowMessageBox="false"
                    ShowSummary="true" />

                <!-- User Type -->
                <div class="field-group">
                    <label for="ddlUserType">Select User Type</label>
                    <asp:DropDownList ID="ddlUserType" runat="server">
                        <asp:ListItem Value="">-- Select User Type --</asp:ListItem>
                        <asp:ListItem>Admin</asp:ListItem>
                        <asp:ListItem>Faculty</asp:ListItem>
                        <asp:ListItem>Student</asp:ListItem>
                    </asp:DropDownList>

                    <asp:RequiredFieldValidator ID="rfvUserType" runat="server"
                        ControlToValidate="ddlUserType"
                        InitialValue=""
                        ErrorMessage="Please select user type"
                        CssClass="val-error" />
                </div>

                <!-- Username -->
                <div class="field-group">
                    <label for="txtUsername">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" placeholder="Enter username"></asp:TextBox>

                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                        ControlToValidate="txtUsername"
                        ErrorMessage="Username is required"
                        CssClass="val-error" />
                </div>

                <!-- Password -->
                <div class="field-group">
                    <label for="txtPassword">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Enter password"></asp:TextBox>

                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword"
                        ErrorMessage="Password is required"
                        CssClass="val-error" />
                </div>

                <div class="forgot">
                    <a href="Forget_Password.aspx">Forgot Password?</a>
                </div>

                <asp:Button ID="btnLogin" runat="server" Text="Login"
                    CssClass="aspNet-Button"
                    OnClick="btnLogin_Click1"
                    OnClientClick="return validateForm();" />

                <div class="bottom-link">
                    Don't have an account? <a href="Registration_Form.aspx">Sign Up</a>
                </div>

                <div class="back-home">
                    <a href="Home_Page.aspx">Back to Home Page</a>
                </div>

            </div>
        </div>

    </form>
</body>
</html>
