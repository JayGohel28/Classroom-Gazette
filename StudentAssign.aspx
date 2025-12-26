<%@ Page Language="C#" AutoEventWireup="true" CodeFile="StudentAssign.aspx.cs" Inherits="StudentAssign" %>

<!DOCTYPE html>
<html>
<head id="Head1" runat="server">
    <title>Student — Submit Assignment</title>
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
        }

        body{ background:var(--page-bg); color:var(--muted-text); font-family: "Segoe UI", Arial; padding:24px; }
        .card{ max-width:900px; margin:0 auto; background:var(--panel-bg); padding:18px; border-radius:12px; }
        h1{ color:var(--accent); margin:0 0 10px 0; }
        .row{ display:flex; gap:10px; flex-wrap:wrap; }
        .col{ flex:1; min-width:200px; display:flex; flex-direction:column; }
        label{ font-size:13px; margin-bottom:6px; color:var(--muted-text); }
        input[type="text"], select, input[type="date"]{ padding:10px; border-radius:8px; border:1px solid rgba(255,255,255,0.04); background:transparent; color:var(--muted-text); }
        .btn{ background: linear-gradient(90deg,var(--accent), #2fb3e0); border:none; padding:10px 14px; border-radius:8px; color:#012; cursor:pointer; font-weight:600; }
        .gv{ width:100%; border-collapse:collapse; margin-top:12px; }
        .gv th, .gv td { padding:8px; border-bottom:1px solid rgba(255,255,255,0.04); }
        .late { color:#ff6b6b; font-weight:700; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="card">
            <h1>Submit Assignment</h1>

            <asp:ValidationSummary ID="valSummary" runat="server" CssClass="note" />

            <div class="row">
                <div class="col">
                    <label>Stream</label>
                    <asp:TextBox ID="txtStream" runat="server" ReadOnly="true" />
                </div>

                <div class="col">
                    <label>Subject</label>
                    <asp:TextBox ID="txtSubject" runat="server" />
                </div>

                <div class="col">
                    <label>Semester</label>
                    <asp:DropDownList ID="ddlSem" runat="server">
                        <asp:ListItem>1</asp:ListItem>
                        <asp:ListItem>2</asp:ListItem>
                        <asp:ListItem>3</asp:ListItem>
                        <asp:ListItem>4</asp:ListItem>
                        <asp:ListItem>5</asp:ListItem>
                        <asp:ListItem>6</asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="col">
                    <label>Date</label>
                    <asp:TextBox ID="txtDate" runat="server" TextMode="Date" />
                </div>
            </div>

            <div style="margin-top:12px;">
                <label>Upload File</label><br />
                <asp:FileUpload ID="fuStudent" runat="server" />
            </div>

            <div style="margin-top:12px;">
                <asp:Button ID="btnSubmit" runat="server" CssClass="btn" Text="Submit Assignment" OnClick="btnSubmit_Click" />
            </div>

            <hr style="margin:14px 0; border-color: rgba(255,255,255,0.03);" />

            <h3 style="margin:6px 0 8px 0; color:var(--accent)">Available Assignments (for your course)</h3>
            <asp:GridView ID="gvFacultyAssignments" runat="server" AutoGenerateColumns="false" CssClass="gv">
                <Columns>
                    <asp:BoundField DataField="Course" HeaderText="Course" />
                    <asp:BoundField DataField="Subject" HeaderText="Subject" />
                    <asp:BoundField DataField="SemesterNo" HeaderText="Sem" />
                    <asp:BoundField DataField="AssignmentType" HeaderText="Type" />
                    <asp:BoundField DataField="LastDate" HeaderText="Due Date" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:TemplateField HeaderText="File">
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkAssign" runat="server" NavigateUrl='<%# Eval("FilePath") %>' Target="_blank" Text='<%# Eval("FileName") %>'></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <h3 style="margin-top:14px; color:var(--accent)">Your Submitted Assignments</h3>
            <asp:GridView ID="gvYourSubmissions" runat="server" AutoGenerateColumns="false" CssClass="gv">
                <Columns>
                    <asp:BoundField DataField="Subject" HeaderText="Subject" />
                    <asp:BoundField DataField="SemesterNo" HeaderText="Sem" />
                    <asp:BoundField DataField="FileName" HeaderText="File" />
                    <asp:BoundField DataField="AssignDate" HeaderText="Submitted On" DataFormatString="{0:yyyy-MM-dd}" />
                    <asp:TemplateField HeaderText="Open">
                        <ItemTemplate>
                            <asp:HyperLink ID="lnkOpen" runat="server" NavigateUrl='<%# Eval("FilePath") %>' Target="_blank" Text="Open"></asp:HyperLink>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="StatusText" HeaderText="Status" />
                </Columns>
            </asp:GridView>

        </div>
    </form>
</body>
</html>
