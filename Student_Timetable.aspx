<%@ Page Language="C#" AutoEventWireup="true"
    CodeFile="Student_Timetable.aspx.cs"
    Inherits="Student_Timetable"
    ClientIDMode="Static"
    UnobtrusiveValidationMode="None" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>My Timetable - Classroom Gazette</title>
    <meta charset="utf-8" />
    <style>
        :root {
            /* MATCHING StudentMainForm THEME */
            --accent: #4fc3f7;                /* Aqua Blue */
            --accent2: #4fc3f7;               /* Use same for gradients */
            --accent-glow: rgba(79,195,247,0.35);
            --dark: #071e2b;                  /* Deep Navy */
            --page-bg: #0a2735;               /* Dark Blue BG */
            --panel-bg: #103445;              /* Card BG */
            --muted-text: #b6d9e6;            /* Soft bluish text */
            --border-soft: rgba(255,255,255,0.08);
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
        }

        * { box-sizing: border-box; }

        html, body {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: "Segoe UI", Roboto, Arial, sans-serif;
            background: var(--page-bg);   /* same as StudentMainForm */
            color: #e9faff;
        }

        .page-wrap {
            min-height: 100%;
            padding: 18px;
            display: flex;
            justify-content: center;
        }

        .card {
            width: 100%;
            max-width: 1000px;
            background: var(--panel-bg);
            border-radius: 18px;
            padding: 18px 20px 20px;
            box-shadow: 0 12px 30px rgba(0,0,0,0.8);
            border: 1px solid var(--border-soft);
        }

        .card-header {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            align-items: flex-start;
            margin-bottom: 10px;
        }

        .title-block {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }

        .title {
            font-size: 20px;
            font-weight: 700;
            color: var(--accent);   /* blue accent */
        }

        .subtitle {
            font-size: 12px;
            color: var(--muted-text);
        }

        .tag {
            padding: 4px 10px;
            border-radius: 999px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            background: linear-gradient(135deg, var(--accent), var(--accent2));
            color: #071e2b;
            box-shadow: 0 0 10px var(--accent-glow);
            white-space: nowrap;
        }

        .divider {
            height: 1px;
            background: var(--border-soft);
            margin: 6px 0 10px;
        }

        /* Student info row */
        .info-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px 28px;
            margin-bottom: 8px;
            font-size: 12px;
            color: var(--muted-text);
        }

        .info-item-label {
            font-weight: 600;
            color: #e9faff;
        }

        .info-item-value {
            font-weight: 500;
        }

        /* Filter row */
        .filter-row {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            align-items: center;
            margin-bottom: 10px;
        }

        .filter-label {
            font-size: 12px;
            color: var(--muted-text);
        }

        .date-input {
            padding: 6px 10px;
            border-radius: 8px;
            border: 1px solid var(--border-soft);
            background: #0d2c3a;
            color: #e9faff;
            font-size: 12px;
            outline: none;
        }

        .date-input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 2px var(--accent-glow);
            background: #071e2b;
        }

        .btn-small {
            border-radius: 999px;
            border: none;
            padding: 6px 14px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            cursor: pointer;
            background: linear-gradient(135deg, var(--accent), #b3e5fc);
            color: #071e2b;
            box-shadow: 0 0 12px var(--accent-glow);
        }

        .btn-small:hover {
            box-shadow: 0 0 18px var(--accent-glow);
        }

        /* Message */
        .msg {
            font-size: 12px;
            margin-bottom: 6px;
        }

        .msg-info { color: var(--muted-text); }
        .msg-error { color: #ff6b81; }

        /* Grid styling → BOX/CARD style rows */
        .grid-wrap {
            margin-top: 10px;
        }

        .timegrid {
            width: 100%;
            border-collapse: separate;       /* important for spacing */
            border-spacing: 0 8px;           /* space between “cards” */
            font-size: 12px;
            background: transparent;
        }

        /* Header row as a flat bar */
        .timegrid thead tr {
            background: #0d2c3a;
        }

        .timegrid th {
            padding: 8px 10px;
            border: none;
            color: #e9faff;
            font-weight: 600;
            white-space: nowrap;
            border-bottom: 1px solid rgba(255,255,255,0.07);
        }

        /* Body rows as rounded boxes */
        .timegrid tbody tr {
            background: linear-gradient(135deg, #0f3040, #0b2533);
            box-shadow: 0 3px 10px rgba(0,0,0,0.6);
            border-radius: 10px;
            overflow: hidden;
        }

        .timegrid td {
            padding: 7px 10px;
            border: none;
            color: #e9faff;
        }

        /* Round first + last cell corners to make row look like one box */
        .timegrid tbody tr td:first-child {
            border-top-left-radius: 10px;
            border-bottom-left-radius: 10px;
        }

        .timegrid tbody tr td:last-child {
            border-top-right-radius: 10px;
            border-bottom-right-radius: 10px;
        }

        .timegrid tbody tr:hover {
            background: linear-gradient(135deg, rgba(79,195,247,0.25), rgba(15,60,80,0.95));
            transform: translateY(-1px);
            transition: 0.12s ease-out;
        }

        .timegrid .center {
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="page-wrap">
            <div class="card">
                <!-- HEADER -->
                <div class="card-header">
                    <div class="title-block">
                        <span class="title">My Lecture Timetable</span>
                        <span class="subtitle">
                            Showing timetable based on your registered course and semester.
                        </span>
                    </div>
                    <span class="tag">Student View</span>
                </div>

                <div class="divider"></div>

                <!-- STUDENT INFO -->
                <div class="info-row">
                    <div>
                        <span class="info-item-label">Name:</span>
                        <span class="info-item-value">
                            <asp:Label ID="lblStudentName" runat="server" Text="-"></asp:Label>
                        </span>
                    </div>
                    <div>
                        <span class="info-item-label">Course:</span>
                        <span class="info-item-value">
                            <asp:Label ID="lblCourse" runat="server" Text="-"></asp:Label>
                        </span>
                    </div>
                    <div>
                        <span class="info-item-label">Semester:</span>
                        <span class="info-item-value">
                            <asp:Label ID="lblSemester" runat="server" Text="-"></asp:Label>
                        </span>
                    </div>
                    <div>
                        <span class="info-item-label">Division:</span>
                        <span class="info-item-value">
                            <asp:Label ID="lblDivision" runat="server" Text="-"></asp:Label>
                        </span>
                    </div>
                </div>

                <!-- FILTER -->
                <div class="filter-row">
                    <span class="filter-label">Filter by date:</span>
                    <asp:TextBox ID="txtFilterDate" runat="server" TextMode="Date" CssClass="date-input"></asp:TextBox>
                    <asp:Button ID="btnFilterToday" runat="server" Text="Today"
                        CssClass="btn-small" OnClick="btnFilterToday_Click" />
                    <asp:Button ID="btnFilterAll" runat="server" Text="All"
                        CssClass="btn-small" OnClick="btnFilterAll_Click" />
                </div>

                <!-- MESSAGE -->
                <asp:Label ID="lblMessage" runat="server" CssClass="msg msg-info"></asp:Label>

                <!-- GRID (card-style rows) -->
                <div class="grid-wrap">
                    <asp:GridView ID="gvTimetable" runat="server"
                        AutoGenerateColumns="False"
                        CssClass="timegrid"
                        EmptyDataText="No lectures found for the selected criteria.">
                        <Columns>
                            <asp:BoundField DataField="LectureDate" HeaderText="Date" />
                            <asp:BoundField DataField="LectureDay" HeaderText="Day" />
                            <asp:BoundField DataField="StartTime" HeaderText="Start" ItemStyle-CssClass="center" />
                            <asp:BoundField DataField="EndTime" HeaderText="End" ItemStyle-CssClass="center" />
                            <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                            <asp:BoundField DataField="FacultyName" HeaderText="Faculty" />
                            <asp:BoundField DataField="BuildingName" HeaderText="Building" />
                            <asp:BoundField DataField="RoomNo" HeaderText="Room" />
                            <asp:BoundField DataField="SemesterTerm" HeaderText="Semester" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </div>
    </form>
</body>
</html>
