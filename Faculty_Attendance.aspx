<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="Faculty_Attendance.aspx.cs"
    Inherits="Faculty_Attendance"
    ClientIDMode="Static"
    UnobtrusiveValidationMode="None" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Faculty Attendance - Classroom Gazette</title>
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
            padding: 24px 28px 26px;
            border: 1px solid var(--border);
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }

        .form-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 14px;
        }

        .form-title {
            font-size: 22px;
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
            white-space: nowrap;
        }

        .divider {
            height: 1px;
            background: var(--border);
            margin: 8px 0 12px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 12px 16px;
            margin-bottom: 12px;
        }

        .field-group {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .col-3 { grid-column: span 3; }
        .col-4 { grid-column: span 4; }
        .col-6 { grid-column: span 6; }
        .col-12 { grid-column: span 12; }

        @media (max-width: 900px) {
            .col-3,
            .col-4,
            .col-6,
            .col-12 {
                grid-column: span 12;
            }

            .form-card {
                padding: 20px 16px 22px;
            }

            .form-title { font-size: 19px; }
        }

        label {
            font-size: 12px;
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
            padding: 7px 9px;
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

        .section-title {
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--muted);
            margin: 6px 0 4px;
        }

        .btn-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-top: 8px;
            margin-bottom: 8px;
        }

        .btn-group-right {
            display: flex;
            gap: 8px;
        }

        .btn-primary {
            border: none;
            border-radius: 999px;
            padding: 8px 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            cursor: pointer;
            background: linear-gradient(135deg, var(--accent), var(--primary));
            color: #ffffff;
            box-shadow: 0 0 18px rgba(102, 209, 255, 0.45);
            transition: transform 0.12s ease, box-shadow 0.12s ease, opacity 0.12s ease;
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 0 22px rgba(164, 112, 239, 0.6);
            opacity: 0.97;
        }

        .btn-secondary {
            border-radius: 999px;
            padding: 7px 14px;
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
            margin-top: 4px;
            font-size: 11px;
            color: var(--muted);
            text-align: right;
        }

        .val-error {
            color: var(--danger);
            font-size: 11px;
        }

        .val-summary {
            margin-top: 4px;
            margin-bottom: 6px;
            padding: 5px 8px;
            border-radius: 6px;
            background: rgba(255, 107, 129, 0.08);
            border: 1px solid rgba(255, 107, 129, 0.4);
            color: var(--danger);
            font-size: 11px;
        }

        .info-message {
            font-size: 12px;
            margin: 4px 0 4px;
            color: var(--muted);
        }

        .grid-wrap {
            margin-top: 10px;
        }

        .attendance-grid {
            width: 100%;
            border-collapse: collapse;
            font-size: 12px;
        }

        .attendance-grid th,
        .attendance-grid td {
            padding: 6px 8px;
            border: 1px solid rgba(255, 255, 255, 0.08);
        }

        .attendance-grid th {
            background: #2a0a55;
            color: #f5e9ff;
            font-weight: 600;
            white-space: nowrap;
        }

        .attendance-grid tr:nth-child(even) {
            background: rgba(0, 0, 0, 0.15);
        }

        .attendance-grid tr:nth-child(odd) {
            background: rgba(255, 255, 255, 0.01);
        }

        .attendance-grid tr:hover {
            background: rgba(102, 209, 255, 0.08);
        }

        .status-ddl {
            padding: 4px 6px;
            border-radius: 6px;
            border: 1px solid rgba(255, 255, 255, 0.18);
            background: #2a0a55;
            color: #f5e9ff;
            font-size: 12px;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
    <div class="page-wrapper">
        <div class="form-card">
            <div class="form-header">
                <div>
                    <h1 class="form-title">Mark Attendance</h1>
                    <p class="form-subtitle">
                        Pick date & lecture, then mark Present/Absent for each student.
                    </p>
                </div>
                <span class="badge">Faculty Panel</span>
            </div>

            <div class="divider"></div>

            <asp:ValidationSummary ID="valSummary" runat="server"
                CssClass="val-summary"
                ShowSummary="true"
                ShowMessageBox="false" />

            <asp:Label ID="lblInfo" runat="server" CssClass="info-message"></asp:Label>

            <!-- 1️⃣ LECTURE FILTER (DATE + COURSE + DIV) -->
            <div class="section-title">Lecture details</div>

            <div class="form-grid">
                <!-- Date -->
                <div class="field-group col-3">
                    <label for="txtDate">
                        Date <span class="required">*</span>
                    </label>
                    <asp:TextBox ID="txtDate" runat="server"
                        TextMode="Date" CssClass="input-control"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvDate" runat="server"
                        ControlToValidate="txtDate"
                        ErrorMessage="Date is required."
                        CssClass="val-error" />
                    <span class="hint">Lecture date (e.g. 2025-12-08)</span>
                </div>

                <!-- Stream (for grouping like your timetable) -->
                <div class="field-group col-3">
                    <label for="ddlStream">
                        Stream <span class="required">*</span>
                    </label>
                    <asp:DropDownList ID="ddlStream" runat="server"
                        CssClass="dropdown-control"
                        AutoPostBack="true"
                        OnSelectedIndexChanged="ddlStream_SelectedIndexChanged">
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
                        CssClass="val-error" />
                </div>

                <!-- Course -->
                <div class="field-group col-3">
                    <label for="ddlCourse">
                        Course <span class="required">*</span>
                    </label>
                    <asp:DropDownList ID="ddlCourse" runat="server"
                        CssClass="dropdown-control">
                        <asp:ListItem Text="-- Select Course --" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCourse" runat="server"
                        ControlToValidate="ddlCourse"
                        InitialValue=""
                        ErrorMessage="Course is required."
                        CssClass="val-error" />
                    <span class="hint">e.g. MCA – Master of...</span>
                </div>

                <!-- Semester -->
                <div class="field-group col-3">
                    <label for="ddlSem">
                        Semester <span class="required">*</span>
                    </label>
                    <asp:DropDownList ID="ddlSem" runat="server"
                        CssClass="dropdown-control">
                        <asp:ListItem Text="-- Select Sem --" Value=""></asp:ListItem>
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
                        ErrorMessage="Semester is required."
                        CssClass="val-error" />
                </div>

                <!-- Division -->
                <div class="field-group col-3">
                    <label for="ddlDivision">
                        Division <span class="required">*</span>
                    </label>
                    <asp:DropDownList ID="ddlDivision" runat="server"
                        CssClass="dropdown-control">
                        <asp:ListItem Text="-- Select Division --" Value=""></asp:ListItem>
                        <asp:ListItem>A</asp:ListItem>
                        <asp:ListItem>B</asp:ListItem>
                        <asp:ListItem>C</asp:ListItem>
                        <asp:ListItem>D</asp:ListItem>
                        <asp:ListItem>E</asp:ListItem>
                        <asp:ListItem>F</asp:ListItem>
                        <asp:ListItem>G</asp:ListItem>
                        <asp:ListItem>H</asp:ListItem>
                        <asp:ListItem>I</asp:ListItem>
                        
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvDivision" runat="server"
                        ControlToValidate="ddlDivision"
                        InitialValue=""
                        ErrorMessage="Division is required."
                        CssClass="val-error" />
                </div>

                <!-- Subject (from StudentTimetable_tbl based on Date+Course+Sem) -->
                <div class="field-group col-6">
                    <label for="ddlSubject">
                        Subject Name <span class="required">*</span>
                    </label>
                    <asp:DropDownList ID="ddlSubject" runat="server"
                        CssClass="dropdown-control">
                        <asp:ListItem Text="-- Select Subject --" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvSubject" runat="server"
                        ControlToValidate="ddlSubject"
                        InitialValue=""
                        ErrorMessage="Subject is required."
                        CssClass="val-error" />
                    <span class="hint">Loaded from timetable for selected date & course</span>
                </div>
            </div>

            <!-- BUTTONS -->
            <div class="btn-row">
                <asp:Button ID="btnLoadSubjects" runat="server"
                    Text="Load Subjects"
                    CssClass="btn-secondary"
                    CausesValidation="false"
                    OnClick="btnLoadSubjects_Click" />

                <div class="btn-group-right">
                    <asp:Button ID="btnLoadStudents" runat="server"
                        Text="Load Students"
                        CssClass="btn-secondary"
                        CausesValidation="false"
                        OnClick="btnLoadStudents_Click" />
                    <asp:Button ID="btnSave" runat="server"
                        Text="Save Attendance"
                        CssClass="btn-primary"
                        OnClick="btnSave_Click" />
                    <asp:Button ID="btnClear" runat="server"
                        Text="Clear"
                        CssClass="btn-secondary"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />
                </div>
            </div>

            <!-- STUDENT GRID -->
            <div class="grid-wrap">
                <asp:GridView ID="gvStudents" runat="server"
                    AutoGenerateColumns="False"
                    CssClass="attendance-grid"
                    DataKeyNames="StudentId"
                    EmptyDataText="No students loaded. Select Course / Sem / Division and click 'Load Students'.">
                    <Columns>
                        <asp:BoundField DataField="EnrollmentNumber" HeaderText="Enroll No." />
                        <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                        <asp:BoundField DataField="Stream" HeaderText="Course" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:DropDownList ID="ddlStatus" runat="server"
                                    CssClass="status-ddl">
                                    <asp:ListItem Text="Present" Value="Present"></asp:ListItem>
                                    <asp:ListItem Text="Absent" Value="Absent"></asp:ListItem>
                                </asp:DropDownList>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <div class="footer-note">
                Fields marked with <span class="required">*</span> are mandatory.
            </div>
        </div>
    </div>
</form>
</body>
</html>
