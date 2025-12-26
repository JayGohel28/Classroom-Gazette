<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="Attendance_Report.aspx.cs"
    Inherits="Attendance_Report"
    ClientIDMode="Static"
    UnobtrusiveValidationMode="None" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Attendance Summary - Classroom Gazette</title>
    <meta charset="utf-8" />
    <style>
        :root{
            --accent: #4fc3f7;          /* Aqua Blue */
            --accent-glow: rgba(79,195,247,0.35);
            --dark: #071e2b;            /* Deep Navy */
            --page-bg: #0a2735;         /* Dark Blue BG */
            --panel-bg: #103445;        /* Card BG */
            --muted-text: #b6d9e6;      /* Soft bluish text */
            --tab-bg: #0d2c3a;
            --tab-active-bg: #164b61;
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
        }

        *{ box-sizing:border-box; }

        html, body{
            margin:0;
            padding:0;
            height:100%;
            background:var(--page-bg);
            color:#e9faff;
            font-family:"Segoe UI", Roboto, Arial, sans-serif;
        }

        .page-wrap{
            min-height:100%;
            display:flex;
            justify-content:center;
            padding:18px;
        }

        .card{
            width:100%;
            max-width:1100px;
            background:var(--panel-bg);
            border-radius:18px;
            padding:18px 20px 20px;
            box-shadow:0 14px 32px rgba(0,0,0,0.8);
            border:1px solid rgba(255,255,255,0.06);
        }

        .card-header{
            display:flex;
            justify-content:space-between;
            gap:10px;
            align-items:flex-start;
            margin-bottom:8px;
        }

        .title-block{
            display:flex;
            flex-direction:column;
            gap:3px;
        }

        .title{
            font-size:20px;
            font-weight:700;
            color:var(--accent);
        }

        .subtitle{
            font-size:12px;
            color:var(--muted-text);
        }

        .tag{
            padding:4px 10px;
            border-radius:999px;
            font-size:11px;
            font-weight:600;
            text-transform:uppercase;
            letter-spacing:0.06em;
            background:linear-gradient(135deg, var(--accent), #b3e5fc);
            color:var(--dark);
            box-shadow:0 0 12px var(--accent-glow);
            white-space:nowrap;
        }

        .divider{
            height:1px;
            background:rgba(255,255,255,0.08);
            margin:6px 0 10px;
        }

        /* FILTER AREA */
        .section-title{
            font-size:11px;
            text-transform:uppercase;
            letter-spacing:0.12em;
            color:var(--muted-text);
            margin-bottom:6px;
        }

        .filter-grid{
            display:grid;
            grid-template-columns:repeat(12, 1fr);
            gap:10px 14px;
            margin-bottom:10px;
        }

        .field-group{
            display:flex;
            flex-direction:column;
            gap:3px;
        }

        .col-2{ grid-column:span 2; }
        .col-3{ grid-column:span 3; }
        .col-4{ grid-column:span 4; }
        .col-6{ grid-column:span 6; }
        .col-12{ grid-column:span 12; }

        @media (max-width:900px){
            .col-2, .col-3, .col-4, .col-6, .col-12{
                grid-column:span 12;
            }
            .card{ padding:16px 14px 18px; }
            .title{ font-size:18px; }
        }

        label{
            font-size:12px;
            font-weight:600;
            color:#e9faff;
        }

        .required{ color:#ff6b81; margin-left:3px; }

        .input-control,
        .dropdown-control{
            width:100%;
            padding:7px 9px;
            border-radius:8px;
            border:1px solid rgba(255,255,255,0.10);
            background:var(--tab-bg);
            color:#e9faff;
            font-size:12px;
            outline:none;
        }

        .input-control:focus,
        .dropdown-control:focus{
            border-color:var(--accent);
            box-shadow:0 0 0 2px var(--accent-glow);
            background:#071e2b;
        }

        .hint{
            font-size:10px;
            color:var(--muted-text);
        }

        .btn-row{
            display:flex;
            justify-content:space-between;
            align-items:center;
            margin-top:4px;
            margin-bottom:6px;
        }

        .btn-primary{
            border:none;
            border-radius:999px;
            padding:8px 18px;
            font-size:12px;
            font-weight:600;
            text-transform:uppercase;
            letter-spacing:0.08em;
            cursor:pointer;
            background:linear-gradient(135deg, var(--accent), #b3e5fc);
            color:var(--dark);
            box-shadow:0 0 16px var(--accent-glow);
        }

        .btn-primary:hover{
            box-shadow:0 0 22px var(--accent-glow);
        }

        .btn-secondary{
            border-radius:999px;
            padding:6px 14px;
            font-size:11px;
            font-weight:500;
            border:1px solid rgba(255,255,255,0.15);
            background:var(--tab-bg);
            color:var(--muted-text);
            cursor:pointer;
        }

        .btn-secondary:hover{ background:var(--tab-active-bg); }

        .msg{
            font-size:12px;
            margin:4px 0;
        }

        .msg-info{ color:var(--muted-text); }
        .msg-error{ color:#ff6b81; }

        .val-summary{
            margin:4px 0;
            padding:5px 8px;
            border-radius:6px;
            background:rgba(255,107,129,0.07);
            border:1px solid rgba(255,107,129,0.4);
            color:#ffb3be;
            font-size:11px;
        }

        /* GRID */
        .grid-wrap{
            margin-top:8px;
        }

        .grid-title{
            font-size:13px;
            font-weight:600;
            color:#e9faff;
            margin-bottom:4px;
        }

        .attendance-grid{
            width:100%;
            border-collapse:collapse;
            font-size:12px;
        }

        .attendance-grid th,
        .attendance-grid td{
            padding:6px 8px;
            border:1px solid rgba(255,255,255,0.08);
        }

        .attendance-grid th{
            background:var(--tab-bg);
            color:#e9faff;
            font-weight:600;
            white-space:nowrap;
        }

        .attendance-grid tr:nth-child(even){
            background:rgba(0,0,0,0.20);
        }

        .attendance-grid tr:nth-child(odd){
            background:rgba(255,255,255,0.02);
        }

        .attendance-grid tr:hover{
            background:rgba(79,195,247,0.18);
        }

        .center{text-align:center;}
        .right{text-align:right;}
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="page-wrap">
            <div class="card">
                <!-- HEADER -->
                <div class="card-header">
                    <div class="title-block">
                        <span class="title">Attendance Summary</span>
                        <span class="subtitle">
                            View per-subject attendance: total lectures, presents, and percentage.
                        </span>
                    </div>
                    <span class="tag">Report</span>
                </div>

                <div class="divider"></div>

                <!-- VALIDATION + MESSAGE -->
                <asp:ValidationSummary ID="valSummary" runat="server"
                    CssClass="val-summary"
                    ShowSummary="true"
                    ShowMessageBox="false" />

                <asp:Label ID="lblMessage" runat="server" CssClass="msg msg-info"></asp:Label>

                <!-- FILTERS -->
                <div class="section-title">Filter options</div>

                <div class="filter-grid">
                    <!-- Course/Stream key (short) -->
                    <div class="field-group col-3">
                        <label for="ddlCourseKey">
                            Course / Stream <span class="required">*</span>
                        </label>
                        <asp:DropDownList ID="ddlCourseKey" runat="server"
                            CssClass="dropdown-control">
                            <asp:ListItem Text="-- Select Course --" Value=""></asp:ListItem>
                            <asp:ListItem>MCA</asp:ListItem>
                            <asp:ListItem>BCA</asp:ListItem>
                            <asp:ListItem>B.Tech</asp:ListItem>
                            <asp:ListItem>B.Sc</asp:ListItem>
                            <asp:ListItem>M.Sc</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvCourseKey" runat="server"
                            ControlToValidate="ddlCourseKey"
                            InitialValue=""
                            ErrorMessage="Course / Stream is required."
                            CssClass="msg msg-error" />
                        <span class="hint">Matches Students_tbl.Stream & Attendance.CourseKey</span>
                    </div>

                    <!-- Semester -->
                    <div class="field-group col-3">
                        <label for="ddlSemester">
                            Semester <span class="required">*</span>
                        </label>
                        <asp:DropDownList ID="ddlSemester" runat="server"
                            CssClass="dropdown-control">
                            <asp:ListItem Text="-- Select Sem --" Value=""></asp:ListItem>
                            <asp:ListItem Value="1">Semester 1</asp:ListItem>
                            <asp:ListItem Value="2">Semester 2</asp:ListItem>
                            <asp:ListItem Value="3">Semester 3</asp:ListItem>
                            <asp:ListItem Value="4">Semester 4</asp:ListItem>
                            <asp:ListItem Value="5">Semester 5</asp:ListItem>
                            <asp:ListItem Value="6">Semester 6</asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvSemester" runat="server"
                            ControlToValidate="ddlSemester"
                            InitialValue=""
                            ErrorMessage="Semester is required."
                            CssClass="msg msg-error" />
                    </div>

                    <!-- Division -->
                    <div class="field-group col-2">
                        <label for="ddlDivision">
                            Division <span class="required">*</span>
                        </label>
                        <asp:DropDownList ID="ddlDivision" runat="server"
                            CssClass="dropdown-control">
                            <asp:ListItem Text="-- Select --" Value=""></asp:ListItem>
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
                            CssClass="msg msg-error" />
                    </div>

                    <!-- Optional Subject filter -->
                    <div class="field-group col-4">
                        <label for="txtSubject">
                            Subject (optional)
                        </label>
                        <asp:TextBox ID="txtSubject" runat="server"
                            CssClass="input-control"
                            placeholder="Leave blank for all subjects"></asp:TextBox>
                        <span class="hint">Exact or partial name, e.g. “Data Structure”</span>
                    </div>

                    <!-- Date From -->
                    <div class="field-group col-3">
                        <label for="txtFromDate">From Date</label>
                        <asp:TextBox ID="txtFromDate" runat="server"
                            CssClass="input-control"
                            TextMode="Date"></asp:TextBox>
                        <span class="hint">Optional start date filter</span>
                    </div>

                    <!-- Date To -->
                    <div class="field-group col-3">
                        <label for="txtToDate">To Date</label>
                        <asp:TextBox ID="txtToDate" runat="server"
                            CssClass="input-control"
                            TextMode="Date"></asp:TextBox>
                        <span class="hint">Optional end date filter</span>
                    </div>
                </div>

                <!-- BUTTONS -->
                <div class="btn-row">
                    <asp:Button ID="btnLoad" runat="server"
                        Text="Load Report"
                        CssClass="btn-primary"
                        OnClick="btnLoad_Click" />

                    <asp:Button ID="btnClear" runat="server"
                        Text="Clear Filters"
                        CssClass="btn-secondary"
                        CausesValidation="false"
                        OnClick="btnClear_Click" />
                </div>

                <!-- GRID -->
                <div class="grid-wrap">
                    <div class="grid-title">Attendance summary (per student & subject)</div>
                    <asp:GridView ID="gvAttendance" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="attendance-grid"
                        EmptyDataText="No attendance records found for selected filters.">
                        <Columns>
                            <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                            <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                            <asp:BoundField DataField="TotalLectures" HeaderText="Total Lectures"
                                ItemStyle-CssClass="center" />
                            <asp:BoundField DataField="Presents" HeaderText="Present"
                                ItemStyle-CssClass="center" />
                            <asp:BoundField DataField="AttendancePercent"
                                HeaderText="Attendance %"
                                DataFormatString="{0:0.00}%"
                                HtmlEncode="false"
                                ItemStyle-CssClass="right" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
