<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FacultyAssign.aspx.cs" Inherits="FacultyAssign" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title>Faculty - Create Assignment</title>
    <meta charset="utf-8" />

    <style>
        /* (same CSS as you had; shortened here for brevity in this example) */
        :root{ --accent:#a770ef; --accent2:#66d1ff; --page-bg:#1a0533; --panel-bg:#220744; --muted-text:#cab6e6; }
        body{ background:var(--page-bg); color:var(--muted-text); font-family:"Segoe UI", Arial, sans-serif; padding:24px; }
        .card{ background:linear-gradient(180deg, rgba(255,255,255,0.02), rgba(0,0,0,0.04)), var(--panel-bg); border-radius:14px; padding:20px; max-width:980px; margin:0 auto; box-shadow:0 6px 30px rgba(0,0,0,0.6); border:1px solid rgba(255,255,255,0.03); }
        h1{ color:var(--accent); margin-top:0; }
        .row{ display:flex; gap:12px; flex-wrap:wrap; }
        .col{ flex:1; min-width:220px; display:flex; flex-direction:column; }
        label{ font-size:13px; margin-bottom:6px; color:var(--muted-text); }
        input[type="text"], input[type="date"], select, textarea{ padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,0.06); background:rgba(255,255,255,0.02); color:var(--muted-text); }
        textarea{ min-height:120px; resize:vertical; }
        .btn{ background:linear-gradient(90deg, var(--accent), var(--accent2)); color:#fff; padding:10px 16px; border-radius:10px; border:none; cursor:pointer; box-shadow:0 8px 20px rgba(167,112,239,0.18); }
        .grid-panel{ margin-top:18px; background:rgba(255,255,255,0.02); padding:12px; border-radius:10px; }
        .note{ font-size:12px; color:#e6d9ff; margin-top:6px; }
        .gv{ width:100%; border-collapse:collapse; margin-top:10px; }
        .gv th,.gv td{ padding:8px 10px; border-bottom:1px solid rgba(255,255,255,0.04); text-align:left; }
        .gv th{ color:var(--accent2); }
        .field-error{ color:#ff6b6b; font-size:12px; margin-top:4px; }
    </style>

    <!-- server-side block to register jquery ScriptResourceMapping early -->
    <script runat="server">
        protected override void OnInit(EventArgs e)
        {
            // Register jquery mapping (name must be "jquery", case-sensitive)
            System.Web.UI.ScriptManager.ScriptResourceMapping.AddDefinition("jquery",
                new System.Web.UI.ScriptResourceDefinition
                {
                    // If you have a local copy, change Path/DebugPath to local file paths like "~/Scripts/jquery-3.6.0.min.js"
                    Path = "https://code.jquery.com/jquery-3.6.0.min.js",
                    DebugPath = "https://code.jquery.com/jquery-3.6.0.js",
                    CdnPath = "https://code.jquery.com/jquery-3.6.0.min.js",
                    CdnDebugPath = "https://code.jquery.com/jquery-3.6.0.js",
                    CdnSupportsSecureConnection = true,
                    LoadSuccessExpression = "window.jQuery"
                });

            base.OnInit(e);
        }
    </script>

    <script type="text/javascript">
        // client-side validators (same as you used)
        function compareDatesClientValidation(source, args) {
            var startEl = document.getElementById('<%= txtDate.ClientID %>');
            var endEl = document.getElementById('<%= txtLastDate.ClientID %>');
            if (!startEl || !endEl) { args.IsValid = true; return; }

            var startVal = startEl.value;
            var endVal = endEl.value;
            if (!startVal || !endVal) { args.IsValid = true; return; }

            var startDate = new Date(startVal);
            var endDate = new Date(endVal);
            if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) { args.IsValid = false; return; }

            args.IsValid = (startDate <= endDate);
        }

        function validateFileExtension(source, args) {
            var fu = document.getElementById('<%= fuAssignment.ClientID %>');
            if (!fu) { args.IsValid = true; return; }
            var filePath = fu.value;
            if (!filePath) { args.IsValid = true; return; }
            var allowed = ['.pdf', '.doc', '.docx', '.zip', '.rar', '.txt', '.ppt', '.pptx'];
            var lower = filePath.toLowerCase();
            var ok = false;
            for (var i = 0; i < allowed.length; i++) {
                if (lower.endsWith(allowed[i])) { ok = true; break; }
            }
            args.IsValid = ok;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <!-- ScriptManager is required for client-side validation scripts to load -->
        <asp:ScriptManager ID="ScriptManager1" runat="server" EnableCdn="true" />

        <div class="card">
            <h1>Faculty — Create Assignment</h1>

            <asp:ValidationSummary ID="valSummary" runat="server" CssClass="note" HeaderText="Please fix the following:" />

            <div class="row">
                <div class="col">
                    <label>Date</label>
                    <asp:TextBox ID="txtDate" runat="server" TextMode="Date" />
                    <asp:RequiredFieldValidator ID="rfvDate" runat="server"
                        ControlToValidate="txtDate"
                        ErrorMessage="Assignment Date is required."
                        Display="Dynamic"
                        CssClass="field-error" />
                </div>

                <div class="col">
                    <label>Stream</label>
                    <asp:DropDownList ID="ddlStream" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlStream_SelectedIndexChanged">
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
                        ErrorMessage="Please select a Stream."
                        Display="Dynamic"
                        CssClass="field-error" />
                </div>

                <div class="col">
                    <label>Course</label>
                    <asp:DropDownList ID="ddlCourse" runat="server">
                        <asp:ListItem Text="-- Select Course --" Value=""></asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvCourse" runat="server"
                        ControlToValidate="ddlCourse"
                        InitialValue=""
                        ErrorMessage="Please select a Course."
                        Display="Dynamic"
                        CssClass="field-error" />
                </div>

                <div class="col">
                    <label>Subject</label>
                    <asp:TextBox ID="txtSubject" runat="server" />
                    <asp:RequiredFieldValidator ID="rfvSubject" runat="server"
                        ControlToValidate="txtSubject"
                        ErrorMessage="Subject is required."
                        Display="Dynamic"
                        CssClass="field-error" />
                </div>
            </div>

            <div class="row" style="margin-top:12px;">
                <div class="col">
                    <label>Select Semester</label>
                    <asp:DropDownList ID="ddlSem" runat="server">
                        <asp:ListItem Value="">-- Select --</asp:ListItem>
                        <asp:ListItem>1</asp:ListItem>
                        <asp:ListItem>2</asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                        <asp:ListItem>5</asp:ListItem>
                        <asp:ListItem>6</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvSem" runat="server"
                        ControlToValidate="ddlSem"
                        InitialValue=""
                        ErrorMessage="Please select Semester."
                        Display="Dynamic"
                        CssClass="field-error" />
                </div>

                <div class="col">
                    <label>Assignment Type</label>
                    <asp:DropDownList ID="ddlAssignType" runat="server">
                        <asp:ListItem Value="">-- Select Type --</asp:ListItem>
                        <asp:ListItem>Homework</asp:ListItem>
                        <asp:ListItem>Lab Assignment</asp:ListItem>
                        <asp:ListItem>Project</asp:ListItem>
                        <asp:ListItem>Viva / Practical</asp:ListItem>
                        <asp:ListItem>Internal Test Work</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="rfvAssignType" runat="server"
                        ControlToValidate="ddlAssignType"
                        InitialValue=""
                        ErrorMessage="Please select Assignment Type."
                        Display="Dynamic"
                        CssClass="field-error" />
                </div>

                <div class="col">
                    <label>Last Date (Due)</label>
                    <asp:TextBox ID="txtLastDate" runat="server" TextMode="Date" />
                    <asp:RequiredFieldValidator ID="rfvLastDate" runat="server"
                        ControlToValidate="txtLastDate"
                        ErrorMessage="Last (Due) Date is required."
                        Display="Dynamic"
                        CssClass="field-error" />
                    <asp:CustomValidator ID="cvDateCompare" runat="server"
                        ControlToValidate="txtLastDate"
                        ErrorMessage="Last Date must be same or after Assignment Date."
                        ClientValidationFunction="compareDatesClientValidation"
                        Display="Dynamic"
                        CssClass="field-error" />
                </div>

                <div class="col">
                    <label>Faculty Name</label>
                    <asp:TextBox ID="txtFacultyName" runat="server" />
                    <asp:RequiredFieldValidator ID="rfvFaculty" runat="server"
                        ControlToValidate="txtFacultyName"
                        ErrorMessage="Faculty Name is required."
                        Display="Dynamic"
                        CssClass="field-error" />
                </div>
            </div>

            <div style="margin-top:12px;">
                <label>Assignment Description</label>
                <asp:TextBox ID="txtDesc" runat="server" TextMode="MultiLine" />
                <asp:RequiredFieldValidator ID="rfvDesc" runat="server"
                    ControlToValidate="txtDesc"
                    ErrorMessage="Assignment Description is required."
                    Display="Dynamic"
                    CssClass="field-error" />
            </div>

            <div style="margin-top:12px;">
                <label>Attachment (pdf, docx, zip etc.)</label><br />
                <asp:FileUpload ID="fuAssignment" runat="server" />
                <asp:CustomValidator ID="cvFileExt" runat="server"
                    ErrorMessage="Allowed file types: .pdf, .doc, .docx, .zip, .rar, .txt, .ppt, .pptx"
                    ClientValidationFunction="validateFileExtension"
                    Display="Dynamic"
                    CssClass="field-error" />
            </div>

            <div style="margin-top:12px;">
                <asp:Button ID="btnSave" runat="server" CssClass="btn" Text="Save Assignment" OnClick="btnSave_Click" />
            </div>

            <div class="grid-panel">
                <h3 style="margin:0 0 8px 0; color:var(--accent2)">Student Submissions</h3>
                <asp:GridView ID="gvSubmissions" runat="server" AutoGenerateColumns="false" CssClass="gv">
                    <Columns>
                        <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                        <asp:BoundField DataField="EnrollmentNo" HeaderText="Enrollment No" />
                        <asp:BoundField DataField="SemesterNo" HeaderText="Sem" />
                        <asp:BoundField DataField="FileName" HeaderText="Uploaded File" />
                        <asp:BoundField DataField="AssignDate" HeaderText="Submitted On" DataFormatString="{0:yyyy-MM-dd}" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:Label ID="lblStatus" runat="server" Text='<%# Eval("StatusText") %>' CssClass='<%# Eval("StatusClass") %>'></asp:Label>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:HyperLink ID="lnkOpen" runat="server" Text="Open" Target="_blank" NavigateUrl='<%# Eval("FilePath") %>'></asp:HyperLink>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <div class="note">Note: Student submissions past the assignment's last date will show highlighted in red.</div>
            </div>
        </div>
    </form>
</body>
</html>
