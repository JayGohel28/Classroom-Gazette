<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ManageReport_admin.aspx.cs" Inherits="ManageReport_admin" %> 

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <title>Manage Reports — Admin</title>

    <style>
        :root{
            --accent: #f1c40f;         /* yellow */
            --accent-2: #d4ab0c;      /* darker yellow */
            --bg: #0b0b0b;
            --panel: linear-gradient(180deg,#101010,#0d0d0d);
            --muted: #bfbfbf;
            --card-border: rgba(241,196,15,0.06);
            --glass: rgba(255,255,255,0.02);
            --success: #2ecc71;
            --danger: #c0392b;
            --radius: 12px;
        }

        /* Reset / Base */
        *{ box-sizing: border-box; }
        html,body{ height:100%; margin:0; padding:0; background: radial-gradient(circle at 10% 10%, rgba(167,112,239,0.04), transparent 10%), var(--bg); color: #eee; font-family: "Segoe UI", Tahoma, Arial, sans-serif; -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale; }

        .container{ max-width:1200px; margin:28px auto; padding: 0 18px; }

        .panel{
            background: var(--panel);
            border-radius: var(--radius);
            padding:20px;
            border:1px solid var(--card-border);
            box-shadow: 0 8px 30px rgba(0,0,0,0.6), 0 0 40px rgba(167,112,239,0.02) inset;
            overflow:hidden;
        }

        .panel h1{
            margin:0 0 14px 0;
            font-size:20px;
            color:var(--accent);
            padding-left:10px;
            border-left:4px solid var(--accent);
            letter-spacing:0.2px;
        }

        /* form grid */
        .form-grid{
            display:grid;
            grid-template-columns: 1fr 1fr;
            gap:16px 18px;
            align-items:start;
        }

        .field{ display:flex; flex-direction:column; gap:8px; }
        .full{ grid-column: 1 / -1; }

        label{ font-size:12px; color:var(--muted); text-transform:uppercase; letter-spacing:0.6px; }

        input[type="text"], input[type="date"], textarea, select, .custom-file-button{
            width:100%;
            padding:10px 12px;
            border-radius:8px;
            background:var(--glass);
            border:1px solid rgba(255,255,255,0.04);
            color:#fff;
            font-size:14px;
        }
        textarea{ min-height:110px; resize:vertical; }

        input:focus, textarea:focus, select:focus { outline:none; border-color: rgba(241,196,15,0.9); box-shadow: 0 6px 20px rgba(241,196,15,0.06); }

        /* file input row */
        .file-row{ display:flex; gap:10px; align-items:center; }
        .file-name{ color:var(--muted); font-size:13px; min-width:0; overflow:hidden; text-overflow:ellipsis; white-space:nowrap; }

        .custom-file-button{
            display:inline-block;
            background: linear-gradient(90deg, var(--accent), var(--accent-2));
            color:#000;
            font-weight:800;
            border:none;
            cursor:pointer;
            padding:10px 14px;
            border-radius:8px;
            box-shadow: 0 8px 18px rgba(0,0,0,0.45);
        }
        .custom-file-button:hover{ transform:translateY(-2px); }

        /* actions */
        .actions{ display:flex; gap:12px; justify-content:flex-end; margin-top:8px; flex-wrap:wrap; }
        .btn{ padding:10px 16px; border-radius:8px; font-weight:700; cursor:pointer; border:1px solid rgba(255,255,255,0.04); }
        .btn.primary{ background: linear-gradient(90deg,var(--accent),var(--accent-2)); color:#000; border:none; }
        .btn.ghost{ background:transparent; color:var(--muted); }

        /* Reports grid heading */
        .reports-heading{ margin:20px 0 12px; color:var(--accent); text-transform:uppercase; font-weight:800; font-size:13px; letter-spacing:0.8px; }

        /* table styling */
        .grid-wrap{ background: linear-gradient(180deg,#0b0b0b,#0d0d0d); border-radius:10px; border:1px solid rgba(255,255,255,0.02); padding:12px; box-shadow: 0 8px 30px rgba(0,0,0,0.6); overflow:auto; }
        table.reports-grid{ width:100%; border-collapse:collapse; min-width:900px; font-size:14px; color: #ddd; }
        table.reports-grid thead th{
            text-align:left;
            padding:12px 14px;
            background: linear-gradient(90deg,var(--accent), var(--accent-2));
            color:#000;
            font-weight:800;
            position:sticky;
            top:0;
            z-index:1;
            box-shadow: 0 4px 10px rgba(0,0,0,0.3);
        }
        table.reports-grid tbody td{ padding:12px 14px; border-bottom:1px solid rgba(255,255,255,0.03); vertical-align:middle; color:var(--muted); }
        table.reports-grid tbody tr:hover td{ background: rgba(241,196,15,0.02); color:#fff; }

        .small-muted{ font-size:13px; color:var(--muted); }

        /* action buttons inside table */
        .action-btn{ padding:6px 10px; border-radius:6px; font-weight:700; border:none; cursor:pointer; }
        .action-btn.download{ background: rgba(102,209,255,0.12); color: var(--accent-2); border:1px solid rgba(102,209,255,0.08); }
        .action-btn.delete{ background: var(--danger); color:#fff; }

        /* validation styling */
        .validation-summary { color:#ffb3b3; margin-bottom:10px; }
        .field .validator { color:#ffb3b3; font-size:12px; margin-top:4px; }

        /* responsive */
        @media (max-width:980px){
            .form-grid{ grid-template-columns: 1fr; }
            table.reports-grid{ min-width:unset; font-size:13px; }
            table.reports-grid thead th{ font-size:12px; padding:10px; }
            table.reports-grid tbody td{ padding:10px; }
        }
    </style>

    <script>
        function handleFileChange(inputId, labelId) {
            var f = document.getElementById(inputId);
            var l = document.getElementById(labelId);
            if (f && f.files && f.files.length > 0) {
                l.textContent = f.files[0].name;
            } else {
                l.textContent = 'No file chosen';
            }
        }
        function triggerFile(inputId) {
            var f = document.getElementById(inputId);
            if (f) f.click();
        }
    </script>
</head>
<body>
    <form id="form1" runat="server" enctype="multipart/form-data">
        <asp:ScriptManager ID="sm" runat="server" EnablePageMethods="true" />
        <div class="container">
            <div class="panel">
                <h1>Create Report</h1>

                <!-- validation summary -->
                <asp:ValidationSummary ID="vsSummary" runat="server" CssClass="validation-summary" HeaderText="Please correct the errors:" />

                <div class="form-grid">

                    <div class="field">
                        <label for="txtName">Name</label>
                        <asp:TextBox ID="txtName" runat="server" placeholder="Enter name" />
                        <asp:RequiredFieldValidator ID="rfvName" runat="server"
                            ControlToValidate="txtName" ErrorMessage="Name is required." CssClass="validator"
                            Display="Dynamic" EnableClientScript="true" />
                    </div>

                    <div class="field">
                        <label for="txtFacultyID">Faculty ID</label>
                        <asp:TextBox ID="txtFacultyID" runat="server" placeholder="e.g. F1234" />
                        <asp:RequiredFieldValidator ID="rfvFacultyID" runat="server"
                            ControlToValidate="txtFacultyID" ErrorMessage="Faculty ID is required." CssClass="validator"
                            Display="Dynamic" EnableClientScript="true" />
                        <asp:RegularExpressionValidator ID="revFacultyID" runat="server"
                            ControlToValidate="txtFacultyID" ErrorMessage="Invalid Faculty ID (letters/numbers/hyphen only)."
                            ValidationExpression="^[A-Za-z0-9\-]+$" CssClass="validator" Display="Dynamic" EnableClientScript="true" />
                    </div>

                    <div class="field full">
                        <label for="txtDescription">Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" placeholder="Write report description..." />
                    </div>

                    <div class="field">
                        <label>Upload File</label>
                        <div class="file-row">
                            <asp:FileUpload ID="fileReport" runat="server" Style="display:none" onchange="handleFileChange(this.id,'lblFileName')" />
                            <button type="button" class="custom-file-button" onclick="triggerFile('fileReport')">Choose file</button>
                            <div id="lblFileName" class="file-name">No file chosen</div>
                        </div>
                        <div class="small-muted" style="margin-top:6px;">Allowed: any file type. Max size depends on server settings.</div>
                    </div>

                    <!-- Date -->
                    <div class="field">
                        <label for="txtDate">Date</label>
                        <asp:TextBox ID="txtDate" runat="server" TextMode="Date" />
                        <asp:RequiredFieldValidator ID="rfvDate" runat="server"
                            ControlToValidate="txtDate" ErrorMessage="Date is required." CssClass="validator"
                            Display="Dynamic" EnableClientScript="true" />
                    </div>

                    <div class="field full">
                        <div class="actions">
                            <asp:Button ID="btnCreate" runat="server" Text="Create Report" CssClass="btn primary" OnClick="btnCreate_Click" />
                            <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn ghost" OnClientClick="return false;" />
                        </div>
                    </div>
                </div>

            </div>
            <!-- end panel -->

            <div class="reports-heading">Reports</div>

            <div class="grid-wrap panel">

                <asp:GridView ID="gvReports" runat="server" AutoGenerateColumns="False" OnRowCommand="gvReports_RowCommand" CssClass="reports-table">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="ID" ItemStyle-Width="50px" />
                        <asp:BoundField DataField="ReportDate" HeaderText="Date" DataFormatString="{0:yyyy-MM-dd}" ItemStyle-Width="110px" />
                        <asp:BoundField DataField="Name" HeaderText="Name" />
                        <asp:BoundField DataField="FacultyID" HeaderText="Faculty ID" ItemStyle-Width="120px" />
                        <asp:BoundField DataField="Stream" HeaderText="Stream" />
                        <asp:BoundField DataField="Course" HeaderText="Course" />
                        <asp:BoundField DataField="Description" HeaderText="Description" />
                        <asp:BoundField DataField="FileName" HeaderText="File" ItemStyle-Width="160px" />

                        <asp:TemplateField HeaderText="Action" ItemStyle-Width="140px">
                            <ItemTemplate>
                                <div style="display:flex;gap:8px;align-items:center">
                                    <asp:LinkButton ID="lnkDownload" runat="server" CommandName="download"
                                        CommandArgument='<%# Eval("Id") %>' CssClass="action-btn download">Download</asp:LinkButton>

                                    <asp:LinkButton ID="lnkDelete" runat="server" CommandName="delete"
                                        CommandArgument='<%# Eval("Id") %>' CssClass="action-btn delete" OnClientClick="return confirm('Delete this report?');">Delete</asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <!-- end grid-wrap -->
        </div>
    </form>
</body>
</html>
