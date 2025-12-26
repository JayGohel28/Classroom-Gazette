<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Registration_Form.aspx.cs" Inherits="Registration_Form" EnableEventValidation="true" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <title>Classroom Gazette — Register</title>

    <!-- Themed CSS: neon purple/gold variables + styles -->
    <style>
        :root {
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
        }

        /* Reset & base */
        *, *:before, *:after { box-sizing: border-box; -webkit-font-smoothing: antialiased; -moz-osx-font-smoothing: grayscale; }
        html, body { height: 100%; margin: 0; padding: 0; }
        body {
            font-family: "Segoe UI", Tahoma, Arial, sans-serif;
            font-size: 16px;
            line-height: 1.45;
            color: var(--text);
            background: radial-gradient(1200px 600px at 10% 10%, rgba(167,117,239,0.06), transparent 6%),
                        radial-gradient(1000px 500px at 90% 90%, rgba(102,209,255,0.04), transparent 6%),
                        var(--bg-dark);
            display: flex;
            align-items: flex-start;
            justify-content: center;
            padding: 36px;
        }

        /* Card */
        .card {
            width: 100%;
            max-width: 980px;
            background: var(--panel);
            border-radius: 14px;
            border: 1.5px solid var(--card-border);
            box-shadow: 0 12px 40px rgba(0,0,0,0.65), 0 6px 18px rgba(167,117,239,0.04) inset;
            padding: 28px 28px 36px 28px;
            display: block;
            backdrop-filter: blur(6px) saturate(1.05);
            animation: cgFade 360ms ease both;
        }

        .card h2 {
            margin: 0 0 6px 0;
            font-size: 1.8rem;
            letter-spacing: 0.2px;
            text-align: left;
            background: var(--accent-gradient);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }

        .card .note {
            margin-top: 6px;
            color: var(--muted);
            font-size: 0.95rem;
            opacity: 0.95;
        }

        /* Layout */
        .row { display: flex; gap: 18px; width: 100%; margin-top: 14px; }
        .col { flex: 1; display: flex; flex-direction: column; min-width: 0; }

        label {
            display: block;
            margin-top: 10px;
            margin-bottom: 6px;
            color: var(--gold);
            font-weight: 600;
            font-size: 0.95rem;
        }

        /* Form controls */
        input[type="text"], input[type="email"], input[type="tel"], input[type="password"],
        select, textarea, .aspNet-DropDownList, .fullwidth {
            width: 100%;
            padding: 10px 12px;
            border-radius: 8px;
            border: 1.5px solid rgba(255,255,255,0.06);
            background: var(--glass);
            color: var(--text);
            font-size: 1rem;
            transition: all 0.18s ease-in-out;
            outline: none;
        }

        /* dropdowns — black background + white text with accent */
        .aspNet-DropDownList, select#selCourse {
            background: #000000;
            color: var(--text);
            border: 1.5px solid rgba(167,117,239,0.14);
            padding: 10px 12px;
            -webkit-appearance: none;
            -moz-appearance: none;
            appearance: none;
            border-radius: 8px;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23f7d400' d='M6 9L1 4h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 14px center;
        }

        .aspNet-DropDownList option, select#selCourse option {
            background: #000000;
            color: var(--text);
        }

        input[type="date"], input[type="time"] {
            padding: 10px 12px;
        }

        input:focus, select:focus, textarea:focus {
            border-color: var(--neon);
            box-shadow: 0 8px 28px rgba(102,209,255,0.12);
            background: rgba(255,255,255,0.04);
        }

        /* Small helper text and links */
        .small { font-size: 0.9rem; color: var(--muted); margin-top: 8px; }
        a { color: var(--gold); text-decoration: none; font-weight: 600; }
        a:hover { text-decoration: underline; }

        /* Hidden helpers */
        .hidden { display: none !important; }

        /* Buttons */
        .btn, .aspNet-Button {
            display: inline-block;
            background: var(--accent-gradient);
            color: #111;
            padding: 12px 18px;
            border-radius: 10px;
            border: none;
            font-weight: 700;
            cursor: pointer;
            font-size: 1rem;
            transition: all 0.14s ease;
            box-shadow: 0 10px 30px rgba(0,0,0,0.45);
        }
        .btn:hover, .aspNet-Button:hover { transform: translateY(-2px); box-shadow: 0 14px 36px rgba(0,0,0,0.55); }

        .button-container { width: 100%; margin-top: 18px; display:flex; justify-content: center; }

        /* Back to Login */
        .back-login {
            text-align: center;
            margin-top: 18px;
            font-size: 0.95rem;
        }
        .back-login a {
            color: var(--neon);
            text-decoration: none;
            font-weight: 600;
        }
        .back-login a:hover {
            text-decoration: underline;
        }

        /* Responsive */
        @media (max-width: 980px) {
            .card { padding: 20px; width: 100%; box-shadow: none; }
            .row { flex-direction: column; gap: 10px; }
            .aspNet-DropDownList { background-position: right 12px center; }
            .col { min-width: 0; }
        }

        @media (max-width: 480px) {
            body { padding: 18px; }
            .card { padding: 16px; border-radius: 10px; }
            .card h2 { font-size: 1.4rem; }
            label { font-size: 0.9rem; }
        }

        /* Accessibility & focus visibility */
        :focus { outline: none; }
        input:focus, select:focus { box-shadow: 0 8px 26px rgba(167,117,239,0.08); outline: 3px solid rgba(167,117,239,0.04); }

        /* table/legend (if used later) */
        .form-legend { font-weight: 700; color: var(--gold); margin-bottom: 8px; display:block; }

        /* feedback */
        #litResult { margin-top: 12px; font-weight: 600; color: var(--muted); display:none; }

        /* simple modal popup */
        .cg-modal-backdrop {
            position: fixed;
            inset: 0;
            background: rgba(2,6,23,0.72);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }
        .cg-modal {
            background: var(--panel);
            border: 1px solid var(--card-border);
            padding: 18px;
            border-radius: 10px;
            width: 92%;
            max-width: 420px;
            text-align: center;
            box-shadow: 0 18px 60px rgba(0,0,0,0.8);
        }
        .cg-modal h3 { margin: 0 0 8px 0; background: var(--accent-gradient); -webkit-background-clip: text; color: transparent; }
        .cg-modal p { color: var(--muted); margin: 0 0 14px 0; }
        .cg-modal .okbtn { background: var(--accent-gradient); padding: 10px 16px; border-radius: 8px; cursor:pointer; font-weight:700; color:#111; border:none; }

        @keyframes cgFade {
            from { opacity: 0; transform: translateY(8px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>

    <script type="text/javascript">
        function byId(id) { return document.getElementById(id); }

        async function fetchAndPopulateCourses() {
            var ddlStream = byId('<%= ddlStream.ClientID %>');
            var selCourse = byId('selCourse');
            var hdnCourse = byId('<%= hdnCourse.ClientID %>');

            if (!ddlStream || !selCourse) return;

            // Clear and add placeholder
            selCourse.options.length = 0;
            var placeholder = document.createElement('option');
            placeholder.text = '-- Select Course --';
            placeholder.value = '';
            selCourse.add(placeholder);

            var streamVal = ddlStream.value;
            if (!streamVal) {
                if (hdnCourse) hdnCourse.value = '';
                return;
            }

            try {
                var resp = await fetch('Registration_Form.aspx/GetCourses', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json; charset=utf-8' },
                    body: JSON.stringify({ stream: streamVal })
                });

                var json = await resp.json();
                var list = (json && json.d) ? json.d : [];

                for (var i = 0; i < list.length; i++) {
                    var opt = document.createElement('option');
                    opt.value = list[i];
                    opt.text = list[i];
                    selCourse.add(opt);
                }

                // restore previously selected value if any
                if (hdnCourse && hdnCourse.value) {
                    for (var j = 0; j < selCourse.options.length; j++) {
                        if (selCourse.options[j].value === hdnCourse.value) {
                            selCourse.selectedIndex = j;
                            break;
                        }
                    }
                }
            } catch (err) {
                console.error('GetCourses error', err);
            }
        }

        function syncCourseToHidden() {
            var selCourse = byId('selCourse');
            var hdnCourse = byId('<%= hdnCourse.ClientID %>');
            if (!selCourse || !hdnCourse) return;
            hdnCourse.value = selCourse.value || '';
        }

        function toggleFields() {
            var ddlUserType = byId('<%= ddlUserType.ClientID %>');
            var faculty = byId('facultyFields');
            var student1 = byId('studentFields1');
            var student2 = byId('studentFields2');

            if (!ddlUserType) return;
            var v = ddlUserType.value || '';

            if (faculty) faculty.classList.add('hidden');
            if (student1) student1.classList.add('hidden');
            if (student2) student2.classList.add('hidden');

            if (v === 'Faculty') {
                if (faculty) faculty.classList.remove('hidden');
            } else if (v === 'Student') {
                if (student1) student1.classList.remove('hidden');
                if (student2) student2.classList.remove('hidden');
            }
        }

        // simple client-side validation (restored from previous version)
        function validateForm() {
            var ddlUserType = byId('<%= ddlUserType.ClientID %>');
            var userType = ddlUserType ? ddlUserType.value.trim() : '';
            var fn = byId('<%= txtFirstName.ClientID %>') ? byId('<%= txtFirstName.ClientID %>').value.trim() : '';
            var email = byId('<%= txtEmailAddress.ClientID %>') ? byId('<%= txtEmailAddress.ClientID %>').value.trim() : '';
            var uname = byId('<%= txtUsername.ClientID %>') ? byId('<%= txtUsername.ClientID %>').value.trim() : '';
            var pass = byId('<%= txtPassword.ClientID %>') ? byId('<%= txtPassword.ClientID %>').value : '';
            var conf = byId('<%= txtConfirmPassword.ClientID %>') ? byId('<%= txtConfirmPassword.ClientID %>').value : '';

            if (!userType) { showValidation('Please select a user type.'); return false; }
            if (!fn) { showValidation('Please enter first name.'); return false; }
            if (!email) { showValidation('Please enter email address.'); return false; }
            // basic email regex (not perfect, but simple)
            var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) { showValidation('Please enter a valid email address.'); return false; }
            if (!uname) { showValidation('Please enter a username.'); return false; }
            if (!pass) { showValidation('Please enter a password.'); return false; }
            if (pass.length < 6) { showValidation('Password must be at least 6 characters.'); return false; }
            if (pass !== conf) { showValidation('Passwords do not match.'); return false; }

            if (userType === 'Student') {
                var enroll = byId('<%= txtEnrollmentNumber.ClientID %>') ? byId('<%= txtEnrollmentNumber.ClientID %>').value.trim() : '';
                var stream = byId('<%= ddlStream.ClientID %>') ? byId('<%= ddlStream.ClientID %>').value.trim() : '';
                var course = byId('selCourse') ? byId('selCourse').value.trim() : '';
                if (!enroll) { showValidation('Please enter enrollment number.'); return false; }
                if (!stream) { showValidation('Please select a stream.'); return false; }
                if (!course) { showValidation('Please select a course.'); return false; }
            }

            // All good — sync hidden course before submit
            syncCourseToHidden();
            return true;
        }

        // small inline validation modal (re-uses the same modal markup)
        function showValidation(msg) {
            var mb = byId('cgModalBackdrop');
            var title = byId('cgModalTitle');
            var body = byId('cgModalBody');
            title.innerText = 'Validation';
            body.innerText = msg;
            mb.style.display = 'flex';
        }

        function showSavedPopup(msg) {
            var mb = byId('cgModalBackdrop');
            var title = byId('cgModalTitle');
            var body = byId('cgModalBody');
            title.innerText = 'Saved';
            body.innerText = msg;
            mb.style.display = 'flex';
        }

        function closeModal() {
            var mb = byId('cgModalBackdrop');
            mb.style.display = 'none';
        }

        window.addEventListener('load', function () {
            var ddlStream = byId('<%= ddlStream.ClientID %>');
            var selCourse = byId('selCourse');
            var form = byId('form1');
            var ddlUserType = byId('<%= ddlUserType.ClientID %>');

            if (ddlStream) ddlStream.addEventListener('change', fetchAndPopulateCourses);
            if (selCourse) selCourse.addEventListener('change', syncCourseToHidden);
            if (form) {
                // ensure validation runs before submit
                form.addEventListener('submit', function (ev) {
                    if (!validateForm()) {
                        ev.preventDefault();
                        return false;
                    }
                    // else allow normal submit (server-side will perform saving)
                });
            }

            if (ddlUserType) ddlUserType.addEventListener('change', toggleFields);

            toggleFields();
            if (ddlStream && ddlStream.value) fetchAndPopulateCourses();
        });
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card">
            <h2>Register — Classroom Gazette</h2>
            <p class="note">Select type → fill fields. Course list is fetched from server for each Stream.</p>

            <label>Select User Type</label>
            <asp:DropDownList ID="ddlUserType" runat="server" CssClass="fullwidth aspNet-DropDownList" onchange="toggleFields();">
                <asp:ListItem Text="-- Select User Type --" Value=""></asp:ListItem>
                <asp:ListItem Text="Faculty" Value="Faculty"></asp:ListItem>
                <asp:ListItem Text="Student" Value="Student"></asp:ListItem>
            </asp:DropDownList>

            <div class="row" style="margin-top:12px;">
                <div class="col">
                    <label>First Name</label>
                    <asp:TextBox ID="txtFirstName" runat="server" CssClass="fullwidth" />

                    <label>Last Name</label>
                    <asp:TextBox ID="txtLastName" runat="server" CssClass="fullwidth" />

                    <label>Date of Birth</label>
                    <asp:TextBox ID="txtDateOfBirth" runat="server" TextMode="Date" CssClass="fullwidth" />

                    <label>Email</label>
                    <asp:TextBox ID="txtEmailAddress" runat="server" TextMode="Email" CssClass="fullwidth" />

                    <div id="studentFields1" class="hidden" style="margin-top:10px;">
                        <label>Enrollment Number</label>
                        <asp:TextBox ID="txtEnrollmentNumber" runat="server" CssClass="fullwidth" />

                        <label>Stream</label>
                        <asp:DropDownList ID="ddlStream" runat="server" CssClass="aspNet-DropDownList fullwidth">
                            <asp:ListItem Text="-- Select Stream --" Value=""></asp:ListItem>
                            <asp:ListItem Text="Computer &amp; IT Streams" Value="Computer &amp; IT Streams"></asp:ListItem>
                            <asp:ListItem Text="Engineering &amp; Technology Streams" Value="Engineering &amp; Technology Streams"></asp:ListItem>
                            <asp:ListItem Text="Management &amp; Commerce Streams" Value="Management &amp; Commerce Streams"></asp:ListItem>
                            <asp:ListItem Text="Science Streams" Value="Science Streams"></asp:ListItem>
                            <asp:ListItem Text="Arts &amp; Humanities Streams" Value="Arts &amp; Humanities Streams"></asp:ListItem>
                            <asp:ListItem Text="Medical &amp; Health Streams" Value="Medical &amp; Health Streams"></asp:ListItem>
                            <asp:ListItem Text="Law &amp; Education" Value="Law &amp; Education"></asp:ListItem>
                            <asp:ListItem Text="Design, Media &amp; Creative Fields" Value="Design, Media &amp; Creative Fields"></asp:ListItem>
                            <asp:ListItem Text="Polytechnic &amp; Skill-Based Streams" Value="Polytechnic &amp; Skill-Based Streams"></asp:ListItem>
                            <asp:ListItem Text="School Level Streams" Value="School Level Streams"></asp:ListItem>
                        </asp:DropDownList>

                        <label>Course</label>
                        <!-- client-side select, populated via AJAX -->
                        <select id="selCourse" name="selCourse" class="fullwidth"></select>

                        <!-- hidden field used to send the selected course to server -->
                        <asp:HiddenField ID="hdnCourse" runat="server" />
                    </div>
                </div>

                <div class="col">
                    <label>Mobile Number</label>
                    <asp:TextBox ID="txtMobileNumber" runat="server" TextMode="Phone" CssClass="fullwidth" />

                    <label>Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="fullwidth" />

                    <label>Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" CssClass="fullwidth" />

                    <label>Confirm Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password" CssClass="fullwidth" />

                    <div id="studentFields2" class="hidden" style="margin-top:10px;">
                        <label>Division</label>
                        <asp:TextBox ID="txtDivision" runat="server" CssClass="fullwidth" />

                        <label>Semester</label>
                        <asp:DropDownList ID="ddlSemester" runat="server" CssClass="aspNet-DropDownList fullwidth">
                            <asp:ListItem Text="-- Select Semester --" Value=""></asp:ListItem>
                            <asp:ListItem Text="1" Value="1"></asp:ListItem>
                            <asp:ListItem Text="2" Value="2"></asp:ListItem>
                            <asp:ListItem Text="3" Value="3"></asp:ListItem>
                            <asp:ListItem Text="4" Value="4"></asp:ListItem>
                            <asp:ListItem Text="5" Value="5"></asp:ListItem>
                            <asp:ListItem Text="6" Value="6"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </div>

            <div id="facultyFields" class="hidden" style="margin-top:12px;">
                <label>Department</label>
                <asp:DropDownList ID="ddlDepartment" runat="server" CssClass="aspNet-DropDownList fullwidth">
                    <asp:ListItem Text="-- Select Department --" Value=""></asp:ListItem>
                    <asp:ListItem Text="Humanities" Value="Humanities"></asp:ListItem>
                    <asp:ListItem Text="Sciences" Value="Sciences"></asp:ListItem>
                    <asp:ListItem Text="Social Sciences" Value="Social Sciences"></asp:ListItem>
                    <asp:ListItem Text="Arts" Value="Arts"></asp:ListItem>
                    <asp:ListItem Text="Professional and Technical" Value="Professional and Technical"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <div class="button-container">
                <asp:Button ID="btnRegister" runat="server" CssClass="btn" Text="Register" OnClick="btnRegister_Click" />
            </div>

            <!-- ⭐ Back to Login Link -->
            <div class="back-login">
                <a href="Login.aspx">← Back to Login</a><br /><br />
                <a href="Home_Page.aspx">← Back to Home Page</a>
            </div>

            <asp:Literal ID="litResult" runat="server" />
        </div>
    </form>

    <!-- modal markup used for both validation and success messages -->
    <div id="cgModalBackdrop" class="cg-modal-backdrop" onclick="closeModal()">
        <div class="cg-modal" onclick="event.stopPropagation();">
            <h3 id="cgModalTitle">Notice</h3>
            <p id="cgModalBody">Message</p>
            <button type="button" class="okbtn" onclick="closeModal()">OK</button>
        </div>
    </div>
</body>
</html>
