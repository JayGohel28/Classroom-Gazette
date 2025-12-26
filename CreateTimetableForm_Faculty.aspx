<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="CreateTimetableForm_Faculty.aspx.cs"
    Inherits="CreateTimetableForm_Faculty"
    ClientIDMode="Static"
    UnobtrusiveValidationMode="None"
    EnableEventValidation="true" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Faculty Timetable - Classroom Gazette</title>
    <meta charset="utf-8" />
    <style>
        :root {
            --primary: #a770ef;
            --primary-light: #3c0f76;
            --accent: #66d1ff;
            --bg: #1a0533;
            --card-bg: #220744;
            --border: rgba(255, 255, 255, 0.08);
            --text: #f5e9ff;
            --muted: #cab6e6;
            --danger: #ff6b81;
        }

        * { box-sizing: border-box; }

        body {
            margin: 0;
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
            background: radial-gradient(circle at top, #3f0071, #0e0038);
            color: var(--text);
        }

        .page-wrapper {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px 15px;
        }

        .form-card {
            width: 100%;
            max-width: 980px;
            background: var(--card-bg);
            border-radius: 20px;
            box-shadow: 0 18px 45px rgba(0, 0, 0, 0.75);
            padding: 28px 32px 30px;
            border: 1px solid var(--border);
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }

        .form-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 20px;
        }

        .form-title {
            font-size: 24px;
            font-weight: 700;
            margin: 0;
            color: var(--accent);
        }

        .form-subtitle {
            margin: 2px 0 0;
            font-size: 13px;
            color: var(--muted);
        }

        .badge {
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            background: linear-gradient(135deg, var(--accent), var(--accent));
            color: #ffffff;
            box-shadow: 0 0 14px rgba(164, 112, 239, 0.45);
        }

        .divider {
            height: 1px;
            background: var(--border);
            margin: 12px 0 18px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 14px 18px;
        }

        .field-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .col-3 { grid-column: span 3; }
        .col-4 { grid-column: span 4; }
        .col-6 { grid-column: span 6; }
        .col-8 { grid-column: span 8; }
        .col-12 { grid-column: span 12; }

        @media (max-width: 900px) {
            .col-3,
            .col-4,
            .col-6,
            .col-8 {
                grid-column: span 12;
            }

            .form-card {
                padding: 22px 18px 24px;
            }

            .form-title {
                font-size: 20px;
            }
        }

        label {
            font-size: 13px;
            font-weight: 600;
            color: var(--text);
        }

        .required {
            color: var(--danger);
            margin-left: 3px;
        }

        .hint {
            font-size: 11px;
            color: var(--muted);
        }

        .input-control,
        .dropdown-control {
            width: 100%;
            padding: 8px 10px;
            border-radius: 8px;
            border: 1px solid var(--border);
            font-size: 13px;
            outline: none;
            background: #2a0a55;
            color: var(--text);
            transition: border-color 0.15s ease, box-shadow 0.15s ease, background 0.15s ease;
        }

        .input-control::placeholder {
            color: rgba(202, 182, 230, 0.8);
        }

        .input-control:focus,
        .dropdown-control:focus {
            border-color: var(--accent);
            background: #1a0533;
            box-shadow: 0 0 0 3px rgba(102, 209, 255, 0.25);
        }

        .input-row {
            display: flex;
            gap: 10px;
        }

        .input-row .input-control { flex: 1; }

        .btn-row {
            display: flex;
            justify-content: flex-end;
            align-items: center;
            gap: 12px;
            margin-top: 14px;
        }

        .btn-primary {
            border: none;
            border-radius: 999px;
            padding: 9px 22px;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            cursor: pointer;
            background: linear-gradient(135deg, var(--accent), var(--primary));
            color: #ffffff;
            box-shadow: 0 0 20px rgba(102, 209, 255, 0.45);
            transition: transform 0.12s ease, box-shadow 0.12s ease, opacity 0.12s ease;
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 0 26px rgba(164, 112, 239, 0.6);
            opacity: 0.97;
        }

        .btn-primary:active {
            transform: translateY(0);
            box-shadow: 0 0 18px rgba(0, 0, 0, 0.7);
        }

        .btn-secondary {
            border-radius: 999px;
            padding: 8px 16px;
            font-size: 12px;
            font-weight: 500;
            border: 1px solid var(--border);
            background: #2a0a55;
            color: var(--muted);
            cursor: pointer;
        }

        .btn-secondary:hover {
            background: #3c0f76;
        }

        .footer-note {
            margin-top: 6px;
            font-size: 11px;
            color: var(--muted);
            text-align: right;
        }

        .pill-row {
            margin-top: 4px;
            display: flex;
            gap: 6px;
            flex-wrap: wrap;
        }

        .pill {
            font-size: 10px;
            padding: 3px 8px;
            border-radius: 999px;
            background: #2a0a55;
            border: 1px dashed var(--border);
            color: var(--muted);
        }

        .val-error {
            color: var(--danger);
            font-size: 11px;
        }

        .val-summary {
            margin-top: 8px;
            padding: 6px 10px;
            border-radius: 6px;
            background: rgba(255, 107, 129, 0.08);
            border: 1px solid rgba(255, 107, 129, 0.4);
            color: var(--danger);
            font-size: 11px;
        }

        .grid-wrapper { margin-top: 24px; }

        .grid-heading {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 6px;
            color: var(--accent);
        }

        .grid-message {
            font-size: 12px;
            margin-bottom: 8px;
        }

        .timegrid {
            width: 100%;
            border-collapse: collapse;
            margin-top: 6px;
            font-size: 12px;
        }

        .timegrid th,
        .timegrid td {
            padding: 6px 8px;
            border: 1px solid rgba(255,255,255,0.08);
        }

        .timegrid th {
            background: #2a0a55;
            color: #f5e9ff;
            font-weight: 600;
        }

        .timegrid tr:nth-child(even) {
            background: rgba(0,0,0,0.15);
        }

        .timegrid tr:nth-child(odd) {
            background: rgba(255,255,255,0.01);
        }

        .timegrid tr:hover {
            background: rgba(102,209,255,0.08);
        }

        .timegrid a {
            color: var(--accent);
            text-decoration: none;
            font-weight: 600;
            font-size: 11px;
        }

        .timegrid a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="page-wrapper">
        <div class="form-card">
            <div class="form-header">
                <div>
                    <h1 class="form-title">Create Student Timetable</h1>
                    <p class="form-subtitle">
                        Select date, stream, course, room and time to schedule a lecture.
                    </p>
                </div>
                <span class="badge">Faculty Panel</span>
            </div>

            <div class="divider"></div>

            <div class="form-grid">

                <!-- Date -->
                <div class="field-group col-3">
                    <label for="txtDate">
                        Date <span class="required">*</span>
                    </label>
                    <asp:TextBox ID="txtDate" runat="server" CssClass="input-control" TextMode="Date"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDate" runat="server"
                        ControlToValidate="txtDate"
                        ErrorMessage="Date is required."
                        CssClass="val-error"
                        Display="Dynamic"
                        ValidationGroup="vgTimeTable">*</asp:RequiredFieldValidator>
                    <span class="hint">Lecture date</span>
                </div>

                <!-- Stream -->
                <div class="field-group col-4">
                    <label for="ddlStream">
                        Stream <span class="required">*</span>
                    </label>
                    <asp:DropDownList ID="ddlStream" runat="server" CssClass="dropdown-control"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlStream_SelectedIndexChanged">
                        <asp:ListItem Text="-- Select Stream --" Value=""></asp:ListItem>
                        <asp:ListItem>Computer &amp; IT Streams</asp:ListItem>
                        <asp:ListItem>Engineering &amp; Technology Streams</asp:ListItem>
                        <asp:ListItem>Management &amp; Commerce Streams</asp:ListItem>
                        <asp:ListItem>Science Streams</asp:ListItem>
                        <asp:ListItem>Arts &amp; Humanities Streams</asp:ListItem>
                        <asp:ListItem>Medical &amp; Health Streams</asp:ListItem>
                        <asp:ListItem>Law &amp; Education</asp:ListItem>
                        <asp:ListItem>Design, Media &amp; Creative Fields</asp:ListItem>
                        <asp:ListItem>Polytechnic &amp; Skill-Based Streams</asp:ListItem>
                        <asp:ListItem>School Level Streams</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvStream" runat="server"
                        ControlToValidate="ddlStream"
                        InitialValue=""
                        ErrorMessage="Stream is required."
                        CssClass="val-error"
                        Display="Dynamic"
                        ValidationGroup="vgTimeTable">*</asp:RequiredFieldValidator>
                    <span class="hint">Faculty’s academic stream</span>
                </div>

                <!-- Course -->
                <div class="field-group col-4">
                    <label for="ddlCourse">
                        Course <span class="required">*</span>
                    </label>
                    <asp:DropDownList ID="ddlCourse" runat="server" CssClass="dropdown-control"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlCourse_SelectedIndexChanged">
                        <asp:ListItem Text="-- Select Course --" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCourse" runat="server"
                        ControlToValidate="ddlCourse"
                        InitialValue=""
                        ErrorMessage="Course is required."
                        CssClass="val-error"
                        Display="Dynamic"
                        ValidationGroup="vgTimeTable">*</asp:RequiredFieldValidator>
                    <span class="hint">Options change based on selected stream</span>
                </div>

                <!-- Subject -->
                <div class="field-group col-6">
                    <label for="txtSubject">
                        Subject Name <span class="required">*</span>
                    </label>
                    <asp:TextBox ID="txtSubject" runat="server" CssClass="input-control"
                        placeholder="e.g., Data Structures, Financial Accounting"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvSubject" runat="server"
                        ControlToValidate="txtSubject"
                        ErrorMessage="Subject is required."
                        CssClass="val-error"
                        Display="Dynamic"
                        ValidationGroup="vgTimeTable">*</asp:RequiredFieldValidator>
                </div>

                <!-- Faculty Name -->
                <div class="field-group col-6">
                    <label for="txtFaculty">
                        Faculty Name <span class="required">*</span>
                    </label>
                    <asp:TextBox ID="txtFaculty" runat="server" CssClass="input-control"
                        placeholder="e.g., Prof. Sharma"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvFaculty" runat="server"
                        ControlToValidate="txtFaculty"
                        ErrorMessage="Faculty name is required."
                        CssClass="val-error"
                        Display="Dynamic"
                        ValidationGroup="vgTimeTable">*</asp:RequiredFieldValidator>
                </div>

                <!-- Building -->
                <div class="field-group col-4">
                    <label for="ddlBuilding">
                        Building Name <span class="required">*</span>
                    </label>
                    <asp:DropDownList ID="ddlBuilding" runat="server" CssClass="dropdown-control"
                        AutoPostBack="true" OnSelectedIndexChanged="ddlBuilding_SelectedIndexChanged">
                        <asp:ListItem Text="-- Select Building --" Value=""></asp:ListItem>
                        <asp:ListItem>MCA Building</asp:ListItem>
                        <asp:ListItem>MBA Building</asp:ListItem>
                        <asp:ListItem>BCA Building</asp:ListItem>
                        <asp:ListItem>B.Tech Building</asp:ListItem>
                        <asp:ListItem>Polytechnic Building</asp:ListItem>
                        <asp:ListItem>Science Block</asp:ListItem>
                        <asp:ListItem>Commerce Block</asp:ListItem>
                        <asp:ListItem>Arts Block</asp:ListItem>
                        <asp:ListItem>Auditorium Block</asp:ListItem>
                        <asp:ListItem>Research &amp; Lab Complex</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvBuilding" runat="server"
                        ControlToValidate="ddlBuilding"
                        InitialValue=""
                        ErrorMessage="Building is required."
                        CssClass="val-error"
                        Display="Dynamic"
                        ValidationGroup="vgTimeTable">*</asp:RequiredFieldValidator>
                    <span class="hint">Select academic building or block</span>
                </div>

                <!-- Classroom / Lab -->
                <div class="field-group col-4">
                    <label for="ddlRoom">
                        Class / Lab Number <span class="required">*</span>
                    </label>
                    <asp:DropDownList ID="ddlRoom" runat="server" CssClass="dropdown-control">
                        <asp:ListItem Text="-- Select Classroom / Lab --" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvRoom" runat="server"
                        ControlToValidate="ddlRoom"
                        InitialValue=""
                        ErrorMessage="Class / Lab is required."
                        CssClass="val-error"
                        Display="Dynamic"
                        ValidationGroup="vgTimeTable">*</asp:RequiredFieldValidator>
                    <span class="hint">Auto-filled from selected building</span>
                </div>

                <!-- Semester / Term -->
                <div class="field-group col-4">
                    <label for="ddlSem">
                        Semester / Term <span class="required">*</span>
                    </label>
                    <asp:DropDownList ID="ddlSem" runat="server" CssClass="dropdown-control">
                        <asp:ListItem Text="-- Select Sem / Term --" Value=""></asp:ListItem>
                        <asp:ListItem>Semester 1</asp:ListItem>
                        <asp:ListItem>Semester 2</asp:ListItem>
                        <asp:ListItem>Semester 3</asp:ListItem>
                        <asp:ListItem>Semester 4</asp:ListItem>
                        <asp:ListItem>Semester 5</asp:ListItem>
                        <asp:ListItem>Semester 6</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvSem" runat="server"
                        ControlToValidate="ddlSem"
                        InitialValue=""
                        ErrorMessage="Semester / Term is required."
                        CssClass="val-error"
                        Display="Dynamic"
                        ValidationGroup="vgTimeTable">*</asp:RequiredFieldValidator>
                    <span class="hint">You can change options as per your college</span>
                </div>

                <!-- Start & End Time -->
                <div class="field-group col-6">
                    <label>
                        Lecture Time <span class="required">*</span>
                    </label>
                    <div class="input-row">
                        <asp:TextBox ID="txtStartTime" runat="server" CssClass="input-control" TextMode="Time"></asp:TextBox>
                        <asp:TextBox ID="txtEndTime" runat="server" CssClass="input-control" TextMode="Time"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvStartTime" runat="server"
                        ControlToValidate="txtStartTime"
                        ErrorMessage="Start time is required."
                        CssClass="val-error"
                        Display="Dynamic"
                        ValidationGroup="vgTimeTable">*</asp:RequiredFieldValidator>
                    <asp:RequiredFieldValidator ID="rfvEndTime" runat="server"
                        ControlToValidate="txtEndTime"
                        ErrorMessage="End time is required."
                        CssClass="val-error"
                        Display="Dynamic"
                        ValidationGroup="vgTimeTable">*</asp:RequiredFieldValidator>
                    <span class="hint">From (Start Time) – To (End Time)</span>
                </div>

                <!-- Extra info -->
                <div class="field-group col-6">
                    <label>Quick Info</label>
                    <div class="pill-row">
                        <span class="pill">⚡ Auto Stream → Course</span>
                        <span class="pill">🏫 Auto Building → Room</span>
                        <span class="pill">📅 Date + Time</span>
                        <span class="pill">👨‍🏫 Faculty-wise Timetable</span>
                    </div>
                </div>

                <!-- Buttons + Summary + Message -->
                <div class="col-12">
                    <asp:ValidationSummary ID="valSummary" runat="server"
                        CssClass="val-summary"
                        ValidationGroup="vgTimeTable"
                        ShowSummary="true"
                        ShowMessageBox="false" />

                    <asp:Label ID="lblMessage" runat="server" CssClass="grid-message"></asp:Label>

                    <div class="btn-row">
                        <asp:Button ID="btnReset" runat="server" Text="Clear Form" CssClass="btn-secondary"
                            CausesValidation="false" OnClick="btnReset_Click" />
                        <asp:Button ID="btnCreate" runat="server" Text="Create Time Table" CssClass="btn-primary"
                            ValidationGroup="vgTimeTable" OnClick="btnCreate_Click" />
                    </div>
                    <div class="footer-note">
                        Fields marked with <span class="required">*</span> are mandatory.
                    </div>
                </div>

            </div>

            <!-- GRIDVIEW SECTION -->
            <div class="grid-wrapper">
                <asp:Label ID="lblGridHeading" runat="server" CssClass="grid-heading"
                    Text="All Timetables"></asp:Label>

                <asp:GridView ID="gvTimetable" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="timegrid"
                    DataKeyNames="Id"
                    OnRowEditing="gvTimetable_RowEditing"
                    OnRowCancelingEdit="gvTimetable_RowCancelingEdit"
                    OnRowUpdating="gvTimetable_RowUpdating"
                    OnRowDeleting="gvTimetable_RowDeleting">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="Id" ReadOnly="True" Visible="False" />

                        <asp:BoundField DataField="LectureDate" HeaderText="Date"
                            DataFormatString="{0:yyyy-MM-dd}" />

                        <asp:BoundField DataField="StreamName" HeaderText="Stream" />
                        <asp:BoundField DataField="CourseName" HeaderText="Course" />
                        <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                        <asp:BoundField DataField="FacultyName" HeaderText="Faculty" />
                        <asp:BoundField DataField="BuildingName" HeaderText="Building" />
                        <asp:BoundField DataField="RoomNo" HeaderText="Room" />
                        <asp:BoundField DataField="SemesterTerm" HeaderText="Sem / Term" />
                        <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
                        <asp:BoundField DataField="EndTime" HeaderText="End Time" />

                        <asp:CommandField ShowEditButton="True" ShowDeleteButton="True"
                            EditText="Edit" DeleteText="Delete" />
                    </Columns>
                </asp:GridView>
            </div>

        </div>
    </div>
</form>
</body>
</html>
