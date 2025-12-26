<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FacultyReport.aspx.cs" Inherits="FacultyReport" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <title>Faculty Report — Classroom Gazette</title>
    <style>
        /* (Same CSS as you provided — omitted here for brevity in the snippet)
           Paste your full CSS here or keep as in your previous .aspx */
        :root {
            --accent: #a770ef;
            --accent2:#66d1ff;
            --dark: #150026;
            --page-bg:#1a0533;
            --panel-bg:#220744;
            --muted-text:#cab6e6;
            --tab-active-bg:#3c0f76;
            --white: #ffffff;
            --card-radius: 12px;
            --input-radius: 8px;
            --shadow-soft: 0 8px 28px rgba(0,0,0,0.6);
        }
        * { box-sizing: border-box; }
        html,body{ margin:0; padding:0; font-family:"Segoe UI", Tahoma; color:var(--muted-text);
            background: linear-gradient(180deg,var(--page-bg), #070611);
        }
        .wrap{ max-width:1140px; margin:28px auto; padding:20px; }
        .panel{ background: linear-gradient(180deg,var(--panel-bg), #2a0a55); border-radius:12px; padding:20px; border:1px solid rgba(255,255,255,0.04); box-shadow:0 8px 28px rgba(0,0,0,0.6); }
        h1{ margin:0 0 10px 0; color:#fff; }
        .row{ display:flex; gap:16px; margin-bottom:12px; }
        .col{ flex:1; display:flex; flex-direction:column; }
        label{ font-size:0.82rem; color:var(--accent2); font-weight:700; margin-bottom:8px; }
        input[type="text"], input[type="date"], textarea { width:100%; padding:10px 12px; border-radius:8px; background:#0f0f0f; border:1px solid rgba(255,255,255,0.12); color:#fff; outline:none; }
        input:focus, textarea:focus { box-shadow:0 0 10px rgba(167,112,239,0.4); border-color:var(--accent); }
        textarea{ min-height:120px; }
        .select-wrap { position:relative; width:100%; }
        .select-wrap select, .styled-select { width:100%; padding:10px 12px; padding-right:42px; background:#0f0f0f !important; color:#fff !important; border-radius:8px; border:1px solid rgba(255,255,255,0.15); appearance:none; -webkit-appearance:none; -moz-appearance:none; }
        .select-wrap::after { content:""; position:absolute; right:12px; top:50%; transform:translateY(-50%); width:18px; height:18px; pointer-events:none; background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 20 20'><polygon points='2,6 10,14 18,6' fill='%23a770ef'/></svg>"); opacity:0.9; }
        input[type="file"]{ position:absolute; left:-9999px; }
        .filebox{ display:flex; align-items:center; gap:10px; }
        .filebtn{ padding:9px 14px; background:linear-gradient(90deg,var(--accent), var(--tab-active-bg)); border:none; border-radius:8px; color:#fff; font-weight:700; cursor:pointer; }
        .filename{ font-size:0.9rem; color:rgba(255,255,255,0.75); max-width:250px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }
        .actions{ display:flex; justify-content:flex-end; gap:10px; }
        .btn{ padding:10px 16px; border-radius:8px; border:none; cursor:pointer; background:linear-gradient(90deg,var(--accent), var(--tab-active-bg)); color:#fff; font-weight:700; }
        .btn.secondary{ background:transparent; border:1px solid rgba(255,255,255,0.2); color:var(--muted-text); }
        .gridwrap{ margin-top:20px; border-radius:10px; overflow:auto; border:1px solid rgba(255,255,255,0.04); }
        table.grid{ width:100%; border-collapse:collapse; min-width:800px; }
        table.grid thead th{ padding:12px; background: rgba(167,112,239,0.1); color:var(--accent2); font-weight:800; }
        table.grid tbody td{ padding:12px; border-bottom:1px solid rgba(255,255,255,0.08); color:var(--muted-text); }
        table.grid tbody tr:hover{ background: rgba(167,112,239,0.12); }
        .download-link{ color:var(--accent2); font-weight:700; text-decoration:none; }
        .validation-summary{ color:#ffb3b3; margin-bottom:10px; }
        @media(max-width:920px){ .row{ flex-direction:column; } }
    </style>

    <script type="text/javascript">
        async function onStreamChange() {
            var streamEl = document.getElementById('<%= ddlStream.ClientID %>');
            var courseEl = document.getElementById('<%= ddlCourse.ClientID %>');
            if (!courseEl) return;

            courseEl.options.length = 0;
            var ph = document.createElement('option');
            ph.text = '-- Select Course --';
            ph.value = '';
            courseEl.add(ph);

            if (!streamEl.value) return;

            try {
                var resp = await fetch('FacultyReport.aspx/GetCourses', {
                    method: 'POST',
                    headers:{'Content-Type':'application/json; charset=utf-8'},
                    body: JSON.stringify({ stream: streamEl.value })
                });
                var json = await resp.json();
                var list = json.d || [];

                list.forEach(c=>{
                    var opt=document.createElement('option');
                opt.value=c;
                opt.text=c;
                courseEl.add(opt);
            });

        } catch (err) { console.error(err); }
        }

        function chooseFile() {
            document.getElementById('<%= fuReportFile.ClientID %>').click();
        }

        function showFileName() {
            var f=document.getElementById('<%= fuReportFile.ClientID %>');
            var lbl = document.getElementById('lblFileName');
            lbl.textContent = f.files.length>0 ? f.files[0].name : 'No file chosen';
        }

        function validateFileClient(source, args) {
            var f = document.getElementById('<%= fuReportFile.ClientID %>');
            args.IsValid = (f && f.files && f.files.length > 0);
        }

        window.addEventListener('load', ()=>{
            var stream = document.getElementById('<%= ddlStream.ClientID %>');
        if (stream) stream.addEventListener('change', onStreamChange);
        var fu = document.getElementById('<%= fuReportFile.ClientID %>');
            if (fu) fu.addEventListener('change', showFileName);
            });
    </script>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <!-- ScriptManager is required for ScriptResourceMapping and for some client features -->
        <asp:ScriptManager runat="server" ID="ScriptManager1" EnablePageMethods="true" />
        <div class="wrap">
            <h1>Admin Report</h1>

            <div class="panel">
                <asp:Label ID="lblMsg" runat="server" Text="" />

                <!-- Validation summary -->
                <asp:ValidationSummary ID="vsSummary" runat="server" HeaderText="Please fix the following:" 
                    CssClass="validation-summary" ShowMessageBox="false" ShowSummary="true" />

                <div class="row">
                    <div class="col">
                        <label>Report Date</label>
                        <asp:TextBox ID="txtReportDate" runat="server" TextMode="Date" />
                        <asp:RequiredFieldValidator ID="rfvDate" runat="server"
                            ControlToValidate="txtReportDate" ErrorMessage="Report Date is required."
                            Display="Dynamic" EnableClientScript="true" />
                    </div>

                    <div class="col">
                        <label>Faculty Name</label>
                        <asp:TextBox ID="txtFacultyName" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvName" runat="server"
                            ControlToValidate="txtFacultyName" ErrorMessage="Faculty Name is required."
                            Display="Dynamic" EnableClientScript="true" />
                    </div>

                    <div class="col">
                        <label>Faculty ID</label>
                        <asp:TextBox ID="txtFacultyID" runat="server" />
                        <asp:RequiredFieldValidator ID="rfvFacultyID" runat="server"
                            ControlToValidate="txtFacultyID" ErrorMessage="Faculty ID is required."
                            Display="Dynamic" EnableClientScript="true" />
                        <asp:RegularExpressionValidator ID="revFacultyID" runat="server"
                            ControlToValidate="txtFacultyID" ErrorMessage="Faculty ID must be numeric."
                            ValidationExpression="^\d+$" Display="Dynamic" EnableClientScript="true" />
                    </div>
                </div>

                <div class="row">
                    <div class="col">
                        <label>Stream</label>
                        <div class="select-wrap">
                            <asp:DropDownList ID="ddlStream" runat="server">
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
                                ControlToValidate="ddlStream" InitialValue="" ErrorMessage="Please select a Stream."
                                Display="Dynamic" EnableClientScript="true" />
                        </div>
                    </div>

                    <div class="col">
                        <label>Course</label>
                        <div class="select-wrap">
                            <select id="ddlCourse" runat="server" class="styled-select"></select>
                            <asp:RequiredFieldValidator ID="rfvCourse" runat="server"
                                ControlToValidate="ddlCourse" InitialValue="" ErrorMessage="Please select a Course."
                                Display="Dynamic" EnableClientScript="true" />
                        </div>
                    </div>

                    <div class="col">
                        <label>Upload File</label>
                        <div class="filebox">
                            <asp:FileUpload ID="fuReportFile" runat="server" />
                            <button type="button" class="filebtn" onclick="chooseFile();">Choose File</button>
                            <div id="lblFileName" class="filename">No file chosen</div>
                        </div>
                        <asp:CustomValidator ID="cvFile" runat="server"
                            ErrorMessage="Please choose a file to upload."
                            ClientValidationFunction="validateFileClient"
                            Display="Dynamic" EnableClientScript="true" />
                    </div>
                </div>

                <label>Description</label>
                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" />

                <div class="actions">
                    <asp:Button ID="btnClear" runat="server" Text="Clear" CssClass="btn secondary" OnClick="btnClear_Click" />
                    <asp:Button ID="btnSave" runat="server" Text="Save Report" CssClass="btn" OnClick="btnSave_Click" />
                </div>
            </div>

            <div class="gridwrap panel">
                <asp:GridView ID="gvReports" runat="server" AutoGenerateColumns="False" CssClass="grid" OnRowCommand="gvReports_RowCommand">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="ID" />
                        <asp:BoundField DataField="Name" HeaderText="Name" />
                        <asp:BoundField DataField="FacultyID" HeaderText="Faculty ID" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:TemplateField HeaderText="Action">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkDownload" runat="server"
                                    CommandName="download"
                                    CommandArgument='<%# Eval("Id") %>'
                                    CssClass="download-link">Download</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

        </div>
    </form>
</body>
</html>
