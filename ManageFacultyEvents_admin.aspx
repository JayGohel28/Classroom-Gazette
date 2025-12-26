<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ManageFacultyEvents_admin.aspx.cs" Inherits="ManageFacultyEvents_admin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <title>Manage Faculty Events</title>

    <style>
        :root{
            --yellow:#f1c40f;
            --yellow-dark:#d4ab0c;
            --bg:#0c0c0c;
            --panel:#151515;
            --panel-2:#0f0f0f;
            --muted:#c0c0c0;
            --input-bg:#0f0f0f;
            --accent-border:#262626;
        }
        html,body {height:100%; margin:0; background:linear-gradient(180deg,#070707 0%, #0b0b0d 100%); font-family: "Segoe UI", Roboto, Arial; color:var(--yellow);}
        .container { width:95%; max-width:1100px; margin:28px auto; }
        .panel { background:linear-gradient(180deg,var(--panel),var(--panel-2)); padding:22px; border-radius:12px; border:1px solid var(--accent-border); box-shadow:0 6px 30px rgba(0,0,0,0.6), 0 0 12px rgba(241,196,15,0.06); margin-bottom:20px; }
        .panel h1{ margin:0 0 18px 0; padding-left:12px; border-left:4px solid var(--yellow); font-size:22px; font-weight:700; color:var(--yellow); }

        .form-grid{ display:grid; grid-template-columns:1fr 1fr; gap:18px 20px; }
        .full { grid-column:1 / -1; }
        .field { display:flex; flex-direction:column; gap:6px; }
        label{ font-size:12px; text-transform:uppercase; color:var(--muted); letter-spacing:0.6px; }
        input[type="text"], input[type="date"], textarea, .asp-textbox { background:var(--input-bg); border:1px solid #2a2a2a; padding:10px 12px; border-radius:8px; font-size:14px; color:#eee; }
        input:focus, textarea:focus { outline:none; border-color:var(--yellow); box-shadow:0 0 8px rgba(241,196,15,0.12); }
        textarea { min-height:120px; resize:vertical; }

        .file-row{ display:flex; align-items:center; gap:12px; }
        .file-name{ color:var(--muted); font-size:13px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; max-width:420px; }
        .choose-btn { background:var(--yellow); color:#000; padding:9px 14px; font-weight:800; border-radius:8px; border:none; cursor:pointer; }
        .choose-btn:hover{ background:var(--yellow-dark); transform:translateY(-1px); }

        .actions { margin-top:14px; display:flex; gap:12px; }
        .btn { padding:10px 16px; border-radius:8px; border:none; font-weight:700; cursor:pointer; font-size:14px; }
        .btn-primary { background:var(--yellow); color:#000; box-shadow:0 8px 20px rgba(241,196,15,0.12); }
        .btn-reset { background:transparent; color:var(--muted); border:1px solid #2a2a2a; }

        .table-title { font-size:16px; margin:12px 0; color:var(--yellow); text-transform:uppercase; letter-spacing:0.6px; }
        .grid-box { background:#060606; padding:10px; border-radius:10px; border:1px solid #111; }

        .events-grid { width:100%; border-collapse:collapse; margin-top:8px; font-size:14px; }
        .events-grid thead th { background:var(--yellow); color:#000; font-weight:800; padding:12px 10px; text-align:left; border-radius:6px; }
        .events-grid tbody tr { transition:background .12s; }
        .events-grid tbody tr:hover { background:#101010; }
        .events-grid td { padding:12px 10px; color:var(--yellow); vertical-align:middle; border-bottom:1px solid rgba(255,255,255,0.03); }
        .small-muted { color:var(--muted); font-size:13px; display:block; }

        .grid-btn { display:inline-block; padding:6px 10px; border-radius:8px; font-weight:700; background:#111; color:var(--yellow); text-decoration:none; border:1px solid #222; cursor:pointer; }
        .grid-btn:hover { transform:translateY(-1px); background:#0d0d0d; }
        .grid-btn.edit { background:transparent; border:1px solid var(--yellow); color:var(--yellow); }
        .grid-btn.delete { background:transparent; border:1px solid #8b1f1f; color:#f28b8b; }
        .grid-btn.view { background:var(--yellow); color:#000; }
        .grid-input { width:100%; padding:8px; border-radius:6px; background:#0c0c0c; color:#eee; border:1px solid #222; }

        .validation-summary { color:#ffb3b3; margin-bottom:10px; }
        .validator { color:#ffb3b3; font-size:12px; margin-top:4px; }

        @media (max-width:900px){ .form-grid { grid-template-columns:1fr; } }
    </style>

    <script>
        function chooseFile(id, label) {
            var control = document.getElementById(id);
            if (!control) return;
            control.click();
            control.onchange = function () {
                var name = this.files && this.files.length ? this.files[0].name : "No file chosen";
                var lbl = document.getElementById(label);
                if (lbl) lbl.textContent = name;
            };
        }
        function confirmDelete() { return confirm('Are you sure you want to delete this event? This cannot be undone.'); }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="sm" runat="server" EnablePageMethods="true" />
        <div class="container">
            <div class="panel">
                <h1>Manage Faculty Events</h1>

                <!-- Validation summary -->
                <asp:ValidationSummary ID="vsSummary" runat="server" CssClass="validation-summary" HeaderText="Please correct the following:" />

                <div class="form-grid">
                    <div class="field">
                        <label>Event Name</label>
                        <asp:TextBox ID="txtEventName" runat="server" placeholder="Enter event name" CssClass="asp-textbox"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEventName" runat="server"
                            ControlToValidate="txtEventName" ErrorMessage="Event name is required." CssClass="validator" Display="Dynamic" EnableClientScript="true" />
                    </div>

                    <div class="field">
                        <label>Start Date</label>
                        <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="asp-textbox"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvStart" runat="server"
                            ControlToValidate="txtStartDate" ErrorMessage="Start date is required." CssClass="validator" Display="Dynamic" EnableClientScript="true" />
                    </div>

                    <div class="field">
                        <label>End Date</label>
                        <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="asp-textbox"></asp:TextBox>
                    </div>

                    <div class="field full">
                        <label>Description</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" placeholder="Write event details..." CssClass="asp-textbox"></asp:TextBox>
                    </div>

                    <div class="field full">
                        <label>Upload Circular</label>
                        <div class="file-row">
                            <asp:FileUpload ID="fileCircular" runat="server" Style="display:none" />
                            <button type="button" class="choose-btn" onclick="chooseFile('<%= fileCircular.ClientID %>', 'fileLabel')">Choose File</button>
                            <div id="fileLabel" class="file-name">No file chosen</div>
                        </div>
                    </div>

                    <div class="field full">
                        <div class="actions">
                            <asp:Button ID="btnCreate" runat="server" OnClick="btnCreate_Click" Text="Create Event" CssClass="btn btn-primary" />
                            <asp:Button ID="btnReset" runat="server" Text="Reset" CssClass="btn btn-reset"
                                        OnClientClick="document.getElementById('<%= txtEventName.ClientID %>').value=''; document.getElementById('<%= txtStartDate.ClientID %>').value=''; document.getElementById('<%= txtEndDate.ClientID %>').value=''; document.getElementById('<%= txtDescription.ClientID %>').value=''; document.getElementById('fileLabel').textContent='No file chosen'; return false;" />
                        </div>
                    </div>
                </div>
            </div>

            <div class="table-title">Faculty Events</div>
            <div class="grid-box">
                <asp:GridView ID="gvEvents" runat="server" CssClass="events-grid"
                    AutoGenerateColumns="False" DataKeyNames="Id" EmptyDataText="No events found."
                    OnRowEditing="gvEvents_RowEditing" OnRowCancelingEdit="gvEvents_RowCancelingEdit"
                    OnRowUpdating="gvEvents_RowUpdating" OnRowDeleting="gvEvents_RowDeleting"
                    OnRowCommand="gvEvents_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="Event Name">
                            <ItemTemplate>
                                <%# Eval("EventName") %>
                                <div class="small-muted"><%# Eval("Id") != null ? "ID: " + Eval("Id") : "" %></div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEvtName_Edit" runat="server" Text='<%# Bind("EventName") %>' CssClass="grid-input" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Start Date" ItemStyle-Width="120px">
                            <ItemTemplate>
                                <%# Eval("StartDate") != DBNull.Value ? String.Format("{0:dd-MM-yyyy}", Eval("StartDate")) : "" %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtStart_Edit" runat="server" Text='<%# Bind("StartDate", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="grid-input" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="End Date" ItemStyle-Width="120px">
                            <ItemTemplate>
                                <%# Eval("EndDate") != DBNull.Value ? String.Format("{0:dd-MM-yyyy}", Eval("EndDate")) : "" %>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtEnd_Edit" runat="server" Text='<%# Bind("EndDate", "{0:yyyy-MM-dd}") %>' TextMode="Date" CssClass="grid-input" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Description">
                            <ItemTemplate>
                                <asp:Label ID="lblDesc" runat="server" Text='<%# Eval("Description") %>' CssClass="small-muted"></asp:Label>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:TextBox ID="txtDesc_Edit" runat="server" Text='<%# Bind("Description") %>' TextMode="MultiLine" CssClass="grid-input" />
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Circular" ItemStyle-Width="140px">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkView" runat="server" CommandName="ViewFile" CommandArgument='<%# Eval("Id") %>' CssClass="grid-btn view">View</asp:LinkButton>
                                <div class="small-muted"><%# Eval("FileName") %></div>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <div style="display:flex; align-items:center; gap:8px;">
                                    <asp:FileUpload ID="file_Edit" runat="server" />
                                    <span class="small-muted">Leave blank to keep existing</span>
                                </div>
                            </EditItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="Actions" ItemStyle-Width="180px">
                            <ItemTemplate>
                                <asp:LinkButton ID="lnkEdit" runat="server" CommandName="Edit" Text="Edit" CssClass="grid-btn edit"></asp:LinkButton>
                                &nbsp;
                                <asp:LinkButton ID="lnkDelete" runat="server" CommandName="Delete" CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirmDelete();" Text="Delete" CssClass="grid-btn delete"></asp:LinkButton>
                            </ItemTemplate>
                            <EditItemTemplate>
                                <asp:LinkButton ID="lnkUpdate" runat="server" CommandName="Update" Text="Update" CssClass="grid-btn view"></asp:LinkButton>
                                &nbsp;
                                <asp:LinkButton ID="lnkCancel" runat="server" CommandName="Cancel" Text="Cancel" CssClass="grid-btn"></asp:LinkButton>
                            </EditItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
